import ballerina/http;
import ballerina/log;

configurable boolean isLiveServer = ?;

listener http:Listener httpListener = new (9090);

http:Service mockService = service object {

    # List plans
    #
    # + return - A successful request returns the HTTP 200 OK status code with a JSON response body that lists billing plans
    resource function get plans() returns PlanCollection|error {
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
    #
    # + payload - The plan request payload
    # + return - A successful request returns the HTTP 200 OK status code with a JSON response body that shows billing plan details
    resource function post plans(@http:Payload PlanRequestPOST payload) returns Plan|error {
        return {
            name: payload.name,
            id: "P-1234567890",
            status: payload.status,
            productId: payload.productId,
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
