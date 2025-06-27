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
import ballerinax/paypal.subscriptions as paypal;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string subscriptionId = ?;

final paypal:Client paypal = check new ({
    auth: {
        clientId,
        clientSecret
    }
});

public function main() returns error? {
    // Retrieve subscription details
    paypal:SubscriptionsGetQueries queries = {
        fields: "id,plan_id,status"
    };
    paypal:Subscription subscription = check paypal->/subscriptions/[subscriptionId].get(queries = queries);
    io:println("Subscription ID: ", subscription.id, ", Status: ", subscription.status);

    // Suspend or reactivate based on status
    if subscription.status == "ACTIVE" {
        paypal:SubscriptionSuspendRequest suspendPayload = {
            reason: "Temporary pause due to customer request"
        };
        check paypal->/subscriptions/[subscriptionId]/suspend.post(suspendPayload);
        io:println("Subscription suspended successfully");
    } else if subscription.status == "SUSPENDED" {
        paypal:SubscriptionActivateRequest activatePayload = {
            reason: "Reactivating subscription per customer request"
        };
        check paypal->/subscriptions/[subscriptionId]/activate.post(activatePayload);
        io:println("Subscription reactivated successfully");
    } else {
        io:println("Subscription status is ", subscription.status, "; no action taken");
    }
}
