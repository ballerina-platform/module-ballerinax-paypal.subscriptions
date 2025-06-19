import ballerina/http;
import ballerina/log;

configurable boolean isLiveServer = ?;

listener http:Listener httpListener = new (9090);

http:Service mockService = service object {

    # # Mock service for testing billing plans API

    # List plans
    #
    # + return - A successful request returns the HTTP 200 OK status code with a JSON response body that lists billing plans
    resource function get plans() returns plan_collection|error {
        return {
            plans: [
                {
                    name: "Basic Plan",
                    id: "P-1234567890",
                    status: "ACTIVE",
                    "product_id": "PROD-1234567890",
                    "billing_cycles": [
                        {
                            sequence: 1,
                            tenure_type: "REGULAR",
                            total_cycles: 0,
                            frequency: {interval_unit: "MONTH", interval_count: 1},
                            pricing_scheme: {fixed_price: {currency_code: "USD", value: "10.00"}}
                        }
                    ],
                    "payment_preferences": {
                        auto_bill_outstanding: true,
                        setup_fee: {currency_code: "USD", value: "0.00"},
                        setup_fee_failure_action: "CANCEL",
                        payment_failure_threshold: 3
                    },
                    "create_time": "2025-06-16T10:53:00Z",
                    links: [{href: "/v1/billing/plans/P-1234567890", rel: "self", method: "GET"}]
                }
            ],
            "total_items": 1,
            "total_pages": 1,
            links: [{href: "/v1/billing/plans?page=1", rel: "self", method: "GET"}]
        };
    }

    # Create plan

    # + payload - The plan request payload
    # + return - A successful request returns the HTTP 200 OK status code with a JSON response body that shows billing plan details
    resource function post plans(@http:Payload plan_request_POST payload) returns plan|error {
        return {
            name: payload.name,
            id: "P-20250618",
            status: payload.status,
            product_id: payload.product_id,
            "billing_cycles": [
                {
                    sequence: 1,
                    tenure_type: "REGULAR",
                    total_cycles: 0,
                    frequency: {interval_unit: "MONTH", interval_count: 1},
                    pricing_scheme: {fixed_price: {currency_code: "USD", value: "10.00"}}
                }
            ],
            "payment_preferences": {
                auto_bill_outstanding: true,
                setup_fee: {currency_code: "USD", value: "0.00"},
                setup_fee_failure_action: "CANCEL",
                payment_failure_threshold: 3
            },
            "create_time": "2025-06-16T10:53:00Z",
            links: [{href: "/v1/billing/plans/P-1234567890", rel: "self", method: "GET"}]
        };
    }

    # Get plan by ID
    #
    # + planId - The ID of the plan to retrieve
    # + return - A successful request returns the HTTP 200 OK status code with a JSON response body that shows billing plan details
    resource function get plans/[string planId]() returns plan|error {
        return {
            name: "Basic Plan",
            id: planId, // Return the same plan ID that was requested
            status: "ACTIVE",
            "product_id": "PROD-1234567890",
            "billing_cycles": [
                {
                    sequence: 1,
                    tenure_type: "REGULAR",
                    total_cycles: 0,
                    frequency: {interval_unit: "MONTH", interval_count: 1},
                    pricing_scheme: {fixed_price: {currency_code: "USD", value: "10.00"}}
                }
            ],
            "payment_preferences": {
                auto_bill_outstanding: true,
                setup_fee: {currency_code: "USD", value: "0.00"},
                setup_fee_failure_action: "CANCEL",
                payment_failure_threshold: 3
            },
            "create_time": "2025-06-16T10:53:00Z",
            links: [{href: string `/v1/billing/plans/${planId}`, rel: "self", method: "GET"}]
        };
    }

    # Update plan by ID
    # + planId - The ID of the plan to update
    # + payload - The plan request payload
    # + return - A successful request returns the HTTP `204 No Content` status code with no JSON response body 
    resource function patch plans/[string planId](@http:Payload patch_request payload) returns http:Ok|error? {
        log:printInfo("Mock service received patch request for plan ID: " + planId);
        log:printInfo("Patch payload: " + payload.toString());
        return {};
    }

    # Deactivate plan
    #
    # + id - The ID of the subscription
    # + return - A successful request returns the HTTP `204 No Content` status code with no JSON response body 
    resource function post plans/[string id]/deactivate() returns http:Ok|error {
        log:printInfo("Mock service received deactivate request for plan ID: " + id);
        return {};
    }

    # Activate plan
    #
    # + id - The ID of the subscription
    # + return - A successful request returns the HTTP `204 No Content` status code with no JSON response body 
    resource function post plans/[string id]/activate() returns http:Ok|error {
        log:printInfo("Mock service received activate request for plan ID: " + id);
        return {};
    }

    # Update pricing
    #
    # + id - The ID of the subscription
    # + payload - The request payload containing the pricing schemes to update
    # + return - A successful request returns the HTTP `204 No Content` status code with no JSON response body 
    resource function post plans/[string id]/update\-pricing\-schemes(@http:Payload update_pricing_schemes_list_request payload) returns http:Ok|error {
        log:printInfo("Mock service received update pricing request for plan ID: " + id);
        log:printInfo("Update pricing payload: " + payload.toString());
        return {};
    }

    # # Mock service for testing billing Subscriptions API
    #

    # create a new subscription
    # + payload - The subscription request payload
    # + return - A successful request returns the HTTP `200 OK` status code and a JSON response body that shows subscription details. 
    resource function post subscriptions(@http:Payload subscription_request_post payload) returns subscription|error {
        return <subscription>
            {
            id: "I-1234567890",
            status: "APPROVAL_PENDING",
            plan_id: payload.plan_id,
            start_time: payload.start_time,
            shipping_amount: payload.shipping_amount,
            create_time: "2025-06-16T10:53:00Z",
            update_time: "2025-06-16T10:53:00Z",
            links: [
                {
                    href: "/v1/billing/subscriptions/I-1234567890",
                    rel: "self",
                    method: "GET"
                }
            ]
        }
        ;
    }

    # get subscription by ID
    #
    # + id - The ID of the subscription to retrieve
    # + return - A successful request returns the HTTP `200 OK` status code and a JSON response body that shows subscription details. 
    resource function get subscriptions/[string id]() returns subscription|error {
        return {
            id: id,
            status: "ACTIVE",
            plan_id: "P-1234567890",
            start_time: "2025-06-16T10:53:00Z",
            shipping_amount: {currency_code: "USD", value: "0.00"},
            create_time: "2025-06-16T10:53:00Z",
            update_time: "2025-06-16T10:53:00Z",
            links: [
                {
                    href: string `/v1/billing/subscriptions/${id}`,
                    rel: "self",
                    method: "GET"
                }
            ]
        };

    };

    # update subscription
    #
    # + id - The ID of the subscription to update
    # + payload - The request payload containing the subscription details to update
    # + return - A successful request returns the HTTP `204 No Content` status code with no JSON response body 
    resource function patch subscriptions/[string id](@http:Payload patch_request payload) returns http:Ok|error? {
        log:printInfo("Mock service received update request for subscription ID: " + id);
        log:printInfo("Update payload: " + payload.toString());
        return {};
    }

    # Revise plan or quantity of subscription
    #
    # + id - The ID of the subscription.
    # + payload - Headers to be sent with the request 
    # + return - A successful request returns the HTTP `200 OK` status code and a JSON response body that shows subscription details. 
    resource function post subscriptions/[string id]/revise(@http:Payload subscription_revise_request payload) returns subscription_revise_response|error {
        log:printInfo("Mock service received revise request for subscription ID: " + id);
        log:printInfo("Revise payload: " + payload.toString());
        return {
            plan_id: payload.plan_id,
            shipping_amount: payload.shipping_amount,
            links: [
                {
                    href: string `/v1/billing/subscriptions/${id}`,
                    rel: "self",
                    method: "GET"
                }
            ]
        };
    }

    # Suspend subscription
    #
    # + id - The ID of the subscription.
    # + payload - Headers to be sent with the request
    # + return - A successful request returns the HTTP `204 No Content` status code with no JSON response body. 
    resource function post subscriptions/[string id]/suspend(@http:Payload subscription_suspend_request payload) returns http:Ok|error {
        log:printInfo("Mock service received suspend request for subscription ID: " + id);
        log:printInfo("Reason for suspension: " + payload.reason.toString());
        return {};
    }

    # Activate subscription
    #
    # + id - The ID of the subscription.
    # + payload - Headers to be sent with the request
    # + return - A successful request returns the HTTP `204 No Content` status code with no JSON response body. 
    resource function post subscriptions/[string id]/activate(@http:Payload subscription_activate_request payload) returns http:Ok|error {
        log:printInfo("Mock service received activate request for subscription ID: " + id);
        log:printInfo("Reason for activation: " + payload.reason.toString());
        return {};
    }

    # Cancel subscription
    #
    # + id - The ID of the subscription.
    # + payload - Headers to be sent with the request
    # + return - A successful request returns the HTTP `204 No Content` status code with no JSON response body. 
    resource function post subscriptions/[string id]/cancel(@http:Payload subscription_cancel_request payload) returns http:Ok|error {
        log:printInfo("Mock service received cancel request for subscription ID: " + id);
        log:printInfo("Reason for cancellation: " + payload.reason.toString());
        return {};
    }
};

function init() returns error? {
    if isLiveServer {
        log:printInfo("Skipping mock server initialization as the tests are running on live server");
        return;
    }
    log:printInfo("Initiating mock server");
    check httpListener.attach(mockService, "/v1/billing");
    check httpListener.'start();
}
