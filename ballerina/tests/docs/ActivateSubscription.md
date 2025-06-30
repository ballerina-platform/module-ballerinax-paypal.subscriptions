# Activating a Subscription for Live Tests

The `live_active_subscription_tests` group in `tests.bal` requires an active subscription. After running `testCreateSubscription`, the subscription is created with an `APPROVAL_PENDING` status. This document outlines the steps to manually activate the subscription in the PayPal sandbox environment using a sandbox Personal account.

## Steps to Activate a Subscription

1. **Run `testCreateSubscription`**:
   - Execute the tests with the `live_tests` group to create a subscription:
     ```bash
     cd tests
     ./gradlew clean test -Pgroups=live_tests
     ```
   - The `testCreateSubscription` test logs a response similar to:
     ```json
     {
         "status": "APPROVAL_PENDING",
         "id": "I-HNYLYUT5MXYH",
         "plan_id": "P-3TF105611V904005MNBRB3ZQ",
         "links": [
             {
                 "href": "https://www.sandbox.paypal.com/webapps/billing/subscriptions?ba_token=BA-90P424234M577033X",
                 "rel": "approve",
                 "method": "GET"
             },
             ...
         ]
     }
     ```
   - Copy the `href` URL with `rel: "approve"` (e.g., `https://www.sandbox.paypal.com/webapps/billing/subscriptions?ba_token=BA-90P424234M577033X`).

2. **Obtain Sandbox Personal Account Credentials**:
   - Log in to the [PayPal Developer Dashboard](https://developer.paypal.com/dashboard).
   - Navigate to "Sandbox Accounts" under "Testing Tools".
     ![Sandbox Accounts](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-paypal.subscriptions/main/ballerina/tests/docs/resources/sandbox-accounts.png)
   - Locate your Personal account (e.g., `xxxx@personal.example.com`).
   - Click "View/Edit Account" to see the credentials (email and password).
     ![Personal Account Credentials](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-paypal.subscriptions/main/ballerina/tests/docs/resources/personal-account-credentials.png)

3. **Activate the Subscription in the Browser**:
   - Open the `approve` URL in a browser.
   - You'll be redirected to a PayPal login page.
     ![PayPal Login Page](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-paypal.subscriptions/main/ballerina/tests/docs/resources/paypal-login-page.png)
   - Log in using the sandbox Personal account credentials (e.g., `xxxx@personal.example.com` and password).
   - On the "Choose a way to pay" page, select a payment method and click "Continue".
     ![Choose Payment Method](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-paypal.subscriptions/main/ballerina/tests/docs/resources/choose-payment-method.png)
   - Click "Agree and Subscribe" to activate the subscription.
     > **Note**: No real funds are used, as this is a sandbox environment.
   - You'll be redirected to an example page (e.g., `https://example.com/return`).
     ![Example Domain Page](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-paypal.subscriptions/main/ballerina/tests/docs/resources/example-domain-page.png)
   - This confirms the subscription is activated (status changes to `ACTIVE`).

4. **Update `Config.toml`**:
   - Set the `testActivatedSubscriptionId` to the subscription ID from the response (e.g., `I-HNYLYUT5MXYH`):
     ```toml
     testActivatedSubscriptionId = "I-HNYLYUT5MXYH"
     ```

5. **Run `live_active_subscription_tests`**:
   - Execute the tests for the `live_active_subscription_tests` group:
     ```bash
     cd tests
     ./gradlew clean test -Pgroups=live_active_subscription_tests
     ```

## Notes
- For issues with activation, verify the `approve` URL and credentials in the PayPal Developer Dashboard.
- Screenshots are stored in `docs/resources/` for reference.
