// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

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
string testSubscriptionId = "";
configurable string testActivatedSubscriptionId = ?;
string testActivatedSubscriptionPlanId = "";

ConnectionConfig config = {
    auth: {
        tokenUrl: "https://api-m.sandbox.paypal.com/v1/oauth2/token",
        clientId,
        clientSecret
    }
};

final Client paypal = check new Client(config, serviceUrl);

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

# # Test cases for PayPal Billing Subscription Connectors
#
# Test to create a new subscription
@test:Config {
    groups: ["live_tests", "mock_tests"],
    dependsOn: [testActivatePlan]
}
function testCreateSubscription() returns error? {
    string twoMinutesFromNow = time:utcToString(time:utcAddSeconds(time:utcNow(), 120));
    subscription_request_post payload = {
        plan_id: testPlanId,
        start_time: twoMinutesFromNow,
        shipping_amount: {
            currency_code: "USD",
            value: "10.00"
        },
        subscriber: {
            name: {
                given_name: "FooBuyer",
                surname: "Jones"
            },
            email_address: "foobuyer@example.com",
            shipping_address: {
                name: {
                    full_name: "John Doe"
                },
                address: {
                    address_line_1: "2211 N First Street",
                    address_line_2: "Building 17",
                    admin_area_2: "San Jose",
                    admin_area_1: "CA",
                    postal_code: "95131",
                    country_code: "US"
                }
            }
        },
        application_context: {
            brand_name: "Example Inc",
            locale: "en-US",
            shipping_preference: "SET_PROVIDED_ADDRESS",
            user_action: "SUBSCRIBE_NOW",
            payment_method: {
                payer_selected: "PAYPAL",
                payee_preferred: "IMMEDIATE_PAYMENT_REQUIRED"
            },
            return_url: "https://example.com/return",
            cancel_url: "https://example.com/cancel"
        }
    };
    subscription response = check paypal->/subscriptions.post(payload);
    test:assertTrue(response.id is string, "Created subscription should have an ID");
    testSubscriptionId = <string>response.id;
    io:println("Subscription created successfully: ", response.id);
}

# Test to get a specific subscription
@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetSubscription() returns error? {
    SubscriptionsGetQueries queries = {
        fields: "id,plan_id,status"
    };
    subscription response = check paypal->/subscriptions/[testSubscriptionId].get(queries = queries);
    test:assertEquals(response.id, testSubscriptionId, "Retrieved subscription ID should match the requested ID");
    io:println("Retrieved Subscription: ", response.toString());
    testActivatedSubscriptionPlanId = <string>response.plan_id;

}

# Test to update a subscription
@test:Config {
    groups: ["mock_tests", "live_active_subscription_tests"],
    after: testGetSubscription
}
function testUpdateSubscription() returns error? {
    patch_request payload = [
        {
            op: "replace",
            path: "/subscriber/shipping_address",
            value: {
                name: {
                    full_name: "Roy Nesarajah Viththagan"
                },
                address: {
                    address_line_1: "2211 N First Street",
                    address_line_2: "Building 17",
                    admin_area_2: "San Jose",
                    admin_area_1: "CA",
                    postal_code: "95131",
                    country_code: "US"
                }
            }
        }
    ];
    error? response = check paypal->/subscriptions/[testActivatedSubscriptionId].patch(payload);
    test:assertTrue(response is (), "Response should be empty on successful patch");
    io:println("Subscription updated successfully: " + testActivatedSubscriptionId);
    testSubscriptionId = testActivatedSubscriptionId;
}

# Test to revise a subscription
@test:Config {
    groups: ["mock_tests", "live_active_subscription_tests"],
    dependsOn: [testUpdateSubscription],
    after: testGetSubscription
}
function testReviseSubscription() returns error? {
    subscription_revise_request payload = {
        plan_id: testActivatedSubscriptionPlanId,
        shipping_amount: {
            currency_code: "USD",
            value: "2222.00"
        }
    };

    subscription_revise_response|error response = check paypal->/subscriptions/[testActivatedSubscriptionId]/revise.post(payload);
    if response is error {
        io:println("Error revising subscription: ", response.message());
        return response;
    }
    io:println("Subscription revised successfully: " + testActivatedSubscriptionId);
    test:assertTrue(response.plan_id is string, "Revised subscription should have a plan ID");
    testSubscriptionId = testActivatedSubscriptionId;
}

# Test to suspend a subscription
@test:Config {
    groups: ["mock_tests", "live_active_subscription_tests"],
    dependsOn: [testReviseSubscription],
    after: testGetSubscription
}
function testSuspendSubscription() returns error? {
    subscription_suspend_request payload = {
        reason: "Item out of stock"
    };
    error? response = check paypal->/subscriptions/[testActivatedSubscriptionId]/suspend.post(payload);
    test:assertTrue(response is (), "Response should be empty on successful suspension");
    io:println("Subscription suspended successfully: " + testActivatedSubscriptionId);
}

# Test to activate a subscription
@test:Config {
    groups: ["mock_tests", "live_active_subscription_tests"],
    dependsOn: [testSuspendSubscription],
    after: testGetSubscription
}
function testActivateSubscription() returns error? {
    subscription_activate_request payload = {
        reason: "Items are back in stock"
    };
    error? response = check paypal->/subscriptions/[testActivatedSubscriptionId]/activate.post(payload);
    test:assertTrue(response is (), "Response should be empty on successful activation");
    io:println("Subscription activated successfully: " + testActivatedSubscriptionId);
}

# Test to cancel a subscription
@test:Config {
    groups: ["mock_tests", "live_active_subscription_tests"],
    dependsOn: [testActivateSubscription],
    after: testGetSubscription
}
function testCancelSubscription() returns error? {
    subscription_cancel_request payload = {
        reason: "Customer requested cancellation"
    };
    error? response = check paypal->/subscriptions/[testActivatedSubscriptionId]/cancel.post(payload);
    test:assertTrue(response is (), "Response should be empty on successful cancellation");
    io:println("Subscription cancelled successfully: " + testActivatedSubscriptionId);
}
