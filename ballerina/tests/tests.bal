import ballerina/http;
import ballerina/io;
import ballerina/test;
import ballerina/time;

// Define configurable variables
configurable string serviceUrl = isLiveServer ? "https://api-m.sandbox.paypal.com/v1/billing" : "http://localhost:9090/v1/billing";
configurable string clientId = ?;
configurable string clientSecret = ?;
string testProductId = "";
string testPlanId = "";

ConnectionConfig config = {
    auth: {
        tokenUrl: "https://api-m.sandbox.paypal.com/v1/oauth2/token",
        clientId: clientId,
        clientSecret: clientSecret
    }
};

final Client paypal = check initClient();

function initClient() returns Client|error {
    // Log the service URL and credentials for debugging
    io:println("API URL: " + serviceUrl);
    //io:println("Client ID: " + clientId);
    //io:println("Client Secret: " + clientSecret);

    return new Client(config, serviceUrl);
}

# # Test cases for PayPal Billing Plans Connectors
#
# Test to list all plans
@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreatePlan]
}
function testListPlans() returns error? {
    plan_collection response = check paypal->/plans();
    // io:println("List Plans Response: " + response.toString());
    test:assertTrue(response?.plans !is ());

}

// Function to create a product
@test:BeforeSuite
function createProduct() returns error? {
    if !isLiveServer {
        testProductId = "PRD-TEMP";
        return;
    }
    // Generate timestamp for unique ID
    time:Utc currentTime = time:utcNow();
    int timestamp = currentTime[0]; // This gives you Unix timestamp like 1750142621

    // Create HTTP client for PayPal API
    http:Client productClient = check new ("https://api-m.sandbox.paypal.com/v1/catalogs", config = {
        auth: {
            tokenUrl: "https://api-m.sandbox.paypal.com/v1/oauth2/token",
            clientId: clientId,
            clientSecret: clientSecret
        }
    });

    // Make API call to create product
    http:Response response = check productClient->/products.post({
        id: timestamp.toString(), // Convert int to string
        name: "T-Shirt",
        "type": "PHYSICAL",
        description: "Cotton XL",
        category: "CLOTHING",
        image_url: string `https://example.com/gallery/images/${timestamp}.jpg`,
        home_url: string `https://example.com/catalog/${timestamp}.jpg`
    });

    json responseJson = check response.getJsonPayload();
    string productId = check responseJson.id;
    // io:println("Created Product ID: " + productId);
    testProductId = productId;
}

# Test to create a new plan
@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreatePlan() returns error? {
    plan_request_POST payload = {
        product_id: testProductId,
        name: "Fresh Clean Tees Plan",
        status: "ACTIVE",
        billing_cycles: [
            {
                frequency: {
                    interval_unit: "MONTH",
                    interval_count: 1
                },
                tenure_type: "TRIAL",
                sequence: 1,
                total_cycles: 1,
                pricing_scheme: {
                    fixed_price: {
                        value: "1",
                        currency_code: "USD"
                    }
                }
            },
            {
                frequency: {
                    interval_unit: "MONTH",
                    interval_count: 1
                },
                tenure_type: "REGULAR",
                sequence: 2,
                total_cycles: 12,
                pricing_scheme: {
                    fixed_price: {
                        value: "44",
                        currency_code: "USD"
                    }
                }
            }
        ],
        payment_preferences: {
            auto_bill_outstanding: true,
            setup_fee_failure_action: "CONTINUE",
            payment_failure_threshold: 3
        }
    };
    plan createdPlan = check paypal->/plans.post(payload);
    io:println("Plan created successfully: ", createdPlan.id);
    test:assertTrue(createdPlan.id is string, "Created plan should have an ID");
    testPlanId = <string>createdPlan.id;
}

# Test to get a specific plan
@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreatePlan]
}
function testGetPlan() returns error? {
    plan plan = check paypal->/plans/[testPlanId].get();
    test:assertEquals(plan.id, testPlanId, "Retrieved plan ID should match the requested ID");
    //io:println("Retrieved Plan: ", plan.toString());
}

# Test to update a plan
@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreatePlan],
    after: testGetPlan

}
function testUpdatePlan() returns error? {
    patch_request payload =
        [
        {
            op: "replace",
            path: "/name",
            value: "Updated Fresh Clean Tees Plan"
        }
    ];

    error? response = check paypal->/plans/[testPlanId].patch(payload);
    test:assertTrue(response is (), "Response should be empty on successful patch");
    io:println("Plan updated successfully: " + testPlanId);
}

# Test to deactivate a plan

@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreatePlan],
    after: testGetPlan
}
function testDeactivatePlan() returns error? {
    error? response = check paypal->/plans/[testPlanId]/deactivate.post();
    test:assertTrue(response is (), "Response should be empty on successful deactivation");
    io:println("Plan deactivated successfully: " + testPlanId);
}

# Test to activate a plan
@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreatePlan, testDeactivatePlan],
    after: testGetPlan
}
function testActivatePlan() returns error? {
    error? response = check paypal->/plans/[testPlanId]/activate.post();
    test:assertTrue(response is (), "Response should be empty on successful activation");
    io:println("Plan activated successfully: " + testPlanId);
}

# Test to update pricing schemes
@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreatePlan, testGetPlan],
    after: testGetPlan
}
function testUpdatePricingSchemes() returns error? {
    update_pricing_schemes_list_request payload = {
        pricing_schemes: [
            {
                billing_cycle_sequence: 1,
                pricing_scheme: {
                    fixed_price: {
                        value: "120",
                        currency_code: "USD"
                    }
                }
            },
            {
                billing_cycle_sequence: 2,
                pricing_scheme: {
                    fixed_price: {
                        value: "555",
                        currency_code: "USD"
                    }
                }
            }
        ]
    };
    error? response = check paypal->/plans/[testPlanId]/update\-pricing\-schemes.post(payload);
    test:assertTrue(response is (), "Response should be empty on successful update of pricing schemes");
    io:println("Pricing schemes updated successfully for plan: " + testPlanId);
}
