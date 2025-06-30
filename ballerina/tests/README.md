# Running Tests

## Prerequisites

To run the tests for this PayPal Subscriptions Ballerina connector, you need:
- A PayPal developer account with sandbox credentials (Client ID and Client Secret). See the [Setup Guide](../README.md#setup-guide) in the main `README.md` for instructions.
- (Optional) An activated subscription ID for `live_active_subscription_tests`. See [docs/ActivateSubscription.md](docs/ActivateSubscription.md) for activation steps.

For more information on obtaining credentials, refer to the [PayPal Developer Documentation](https://developer.paypal.com/api/rest/).
## Test Environments

There are two test environments for running the PayPal Subscriptions connector tests:

| Test Group                        | Environment                                           |
|-----------------------------------|-------------------------------------------------------|
| `mock_tests`                      | Mock server for PayPal Subscriptions API (Default)   |
| `live_tests`                      | PayPal Sandbox API                                    |
| `live_active_subscription_tests`  | PayPal Sandbox API (requires active subscription ID) |

You can run tests in either environment. Each group has its own compatible set of tests.

## Running Tests in the Mock Server

To execute tests on the mock server, ensure that the `isLiveServer` configuration is set to `false` or is unset.

You can configure this variable in the `Config.toml` file in the `tests` directory or set it as an environment variable.

### Configure the `Config.toml` file

Create a `Config.toml` file in the `tests` directory with the following content:

```toml
isLiveServer = false
clientId = "DUMMY_CLIENT_ID"
clientSecret = "DUMMY_CLIENT_SECRET"
```

Then, run the following command to run the tests:

```bash
./gradlew clean test
```

## Running Tests Against PayPal Sandbox API

### Configure the `Config.toml` file

Create a `Config.toml` file in the `tests` directory and add your PayPal sandbox credentials:

```toml
isLiveServer = true
clientId = "<your-paypal-sandbox-client-id>"
clientSecret = "<your-paypal-sandbox-client-secret>"
# Optional: For some tests, you may need an activated subscription ID
testActivatedSubscriptionId = "<your-activated-subscription-id>"
```

Then, run the following command to run the tests:

```bash
./gradlew clean test
```

## Running Specific Groups or Test Cases

To run only certain test groups or individual test cases, pass the `-Pgroups` property:

```bash
./gradlew clean test -Pgroups=<comma-separated-groups-or-test-cases>
```

For example, to run only the mock tests:

```bash
./gradlew clean test -Pgroups=mock_tests
```

For `live_active_subscription_tests`, obtain an activated subscription ID by following [docs/ActivateSubscription.md](docs/ActivateSubscription.md).

## Notes

- The `live_active_subscription_tests` group includes tests like `testUpdateSubscription`, `testReviseSubscription`, `testSuspendSubscription`, `testActivateSubscription`, and `testCancelSubscription`, requiring an active subscription.
- Screenshots for setup and activation are in `docs/resources/`.
- For issues, verify configurations and credentials in the PayPal Developer Dashboard.
