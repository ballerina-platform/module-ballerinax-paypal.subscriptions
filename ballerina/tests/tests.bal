import ballerina/http;
import ballerina/io;
import ballerina/test;
import ballerina/time;

// Define configurable variables
configurable string serviceUrl = isLiveServer ? "https://api-m.sandbox.paypal.com/v1/billing" : "http://localhost:9090/v1/billing";
configurable string clientId = ?;
configurable string clientSecret = ?;

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

# Test to list all plans
@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testCreatePlan]
}
function testListPlans() returns error? {
    PlanCollection response = check paypal->/plans.get();
    // io:println("List Plans Response: " + response.toString());
    test:assertTrue(response?.plans !is ());

}

// Function to create a product
function createProduct() returns string|error {
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
        "id": timestamp.toString(), // Convert int to string
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
    return productId;
}

# Test to create a new plan
@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreatePlan() returns error? {
    string productId = check createProduct();

    PlanRequestPOST payload = {
        productId: productId,
        name: "Fresh Clean Tees Plan",
        status: "ACTIVE",
        billingCycles: [
            {
                frequency: {
                    intervalUnit: "MONTH",
                    intervalCount: 1
                },
                tenureType: "TRIAL",
                sequence: 1,
                totalCycles: 1,
                pricingScheme: {
                    fixedPrice: {
                        value: "1",
                        currencyCode: "USD"
                    }
                }
            },
            {
                frequency: {
                    intervalUnit: "MONTH",
                    intervalCount: 1
                },
                tenureType: "REGULAR",
                sequence: 2,
                totalCycles: 12,
                pricingScheme: {
                    fixedPrice: {
                        value: "44",
                        currencyCode: "USD"
                    }
                }
            }
        ],
        paymentPreferences: {
            autoBillOutstanding: true,
            setupFeeFailureAction: "CONTINUE",
            paymentFailureThreshold: 3
        }
    };
    Plan createdPlan = check paypal->/plans.post(payload);
    //io:println("Created Plan: ", createdPlan.toString());
    test:assertTrue(createdPlan.id is string, "Created plan should have an ID");
}
