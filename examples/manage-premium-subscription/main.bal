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

import ballerina/io;
import ballerina/time;
import ballerinax/paypal.subscriptions as paypal;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string productId = ?;

final paypal:Client paypal = check new paypal:Client({auth: {clientId, clientSecret}});

public function main() returns error? {
    // Create a subscription plan with trial and regular billing
    paypal:PlanRequestPOST planPayload = {
        product_id: productId,
        name: "Premium Membership",
        description: "Monthly subscription for premium access with a trial period",
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
                        value: "1.00",
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
                total_cycles: 0, // Infinite regular cycles
                pricing_scheme: {
                    fixed_price: {
                        value: "15.00",
                        currency_code: "USD"
                    }
                }
            }
        ],
        payment_preferences: {
            auto_bill_outstanding: true,
            setup_fee: {
                value: "0.00",
                currency_code: "USD"
            },
            setup_fee_failure_action: "CONTINUE",
            payment_failure_threshold: 3
        }
    };
    paypal:Plan createdPlan = check paypal->/plans.post(planPayload);
    io:println("Created Plan ID: ", createdPlan.id, ", Name: ", createdPlan.name);

    // Create a subscription for a customer
    string startTime = time:utcToString(time:utcAddSeconds(time:utcNow(), 120)); // Start in 2 minutes
    paypal:SubscriptionRequestPost subscriptionPayload = {
        plan_id: check createdPlan.id.ensureType(string),
        start_time: startTime,
        subscriber: {
            name: {
                given_name: "Jane",
                surname: "Smith"
            },
            email_address: "jane.smith@example.com",
            shipping_address: {
                name: {
                    full_name: "Jane Smith"
                },
                address: {
                    address_line_1: "123 Main Street",
                    admin_area_2: "San Francisco",
                    admin_area_1: "CA",
                    postal_code: "94105",
                    country_code: "US"
                }
            }
        },
        application_context: {
            brand_name: "SaaS Platform Inc",
            locale: "en-US",
            shipping_preference: "SET_PROVIDED_ADDRESS",
            user_action: "SUBSCRIBE_NOW",
            payment_method: {
                payer_selected: "PAYPAL",
                payee_preferred: "IMMEDIATE_PAYMENT_REQUIRED"
            },
            return_url: "https://saasplatform.com/return",
            cancel_url: "https://saasplatform.com/cancel"
        }
    };
    paypal:Subscription createdSubscription = check paypal->/subscriptions.post(subscriptionPayload);
    io:println("Created Subscription ID: ", createdSubscription.id, ", Status: ", createdSubscription.status);
    string createdSubscriptionId = check createdSubscription.id.ensureType(string);

    // Retrieve and display subscription details
    paypal:Subscription subscriptionDetails = check paypal->/subscriptions/[createdSubscriptionId].get();
    io:println("\nSubscription Details:");
    io:println("  ID: ", subscriptionDetails.id);
    io:println("  Plan ID: ", subscriptionDetails.plan_id);
    io:println("  Status: ", subscriptionDetails.status);
    paypal:Subscriber subscriber = check subscriptionDetails.subscriber.ensureType(paypal:Subscriber);
    io:println("  Subscriber: ", subscriber.name?.full_name ?: "N/A");
    io:println("  Start Time: ", subscriptionDetails.start_time ?: "N/A");
}
