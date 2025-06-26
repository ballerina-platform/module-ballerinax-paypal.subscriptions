import ballerina/io;
import ballerinax/paypal.subscriptions as paypal;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string productId = ?;

final paypal:Client paypal = check new paypal:Client({auth: {clientId, clientSecret}});

public function main() returns error? {
    // Create a subscription plan
    paypal:PlanRequestPOST planPayload = {
        product_id: productId,
        name: "Basic Monthly Plan",
        description: "Monthly subscription for premium access",
        status: "ACTIVE",
        billing_cycles: [
            {
                frequency: {
                    interval_unit: "MONTH",
                    interval_count: 1
                },
                tenure_type: "REGULAR",
                sequence: 1,
                total_cycles: 12,
                pricing_scheme: {
                    fixed_price: {
                        value: "10.00",
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
    io:println("Created Plan ID: ", createdPlan.id);

    // List all plans
    paypal:PlanCollection planList = check paypal->/plans();
    io:println("Available Plans:");
    foreach var plan in planList.plans ?: [] {
        io:println("- Plan ID: ", plan.id, ", Name: ", plan.name);
    }
}
