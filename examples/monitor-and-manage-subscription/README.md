## Monitor and Manage Subscription Status

This use case demonstrates how the PayPal Subscriptions API can be used to monitor a subscription's status and manage it by suspending or reactivating it. It is useful for applications that need to handle customer subscription status changes, such as pausing a subscription due to payment issues or reactivating it upon resolution, in scenarios like SaaS or subscription-based services.

## Prerequisites

### 1. Set up PayPal Developer account

Refer to the [Setup Guide](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions#setup-guide) to obtain necessary credentials (`clientId`, `clientSecret`) and create a subscription to get a `subscriptionId`.

### 2. Configuration

Create a `Config.toml` file in the example's root directory and provide your PayPal credentials and subscription ID as follows:

```toml
clientId = "<your_client_id>"
clientSecret = "<your_client_secret>"
subscriptionId = "<your_subscription_id>"
```

## Run the Example

Execute the following command to run the example:

```bash
bal run
```