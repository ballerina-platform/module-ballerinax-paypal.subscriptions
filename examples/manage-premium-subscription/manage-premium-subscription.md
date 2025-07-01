## Manage Premium Subscription

This example demonstrates how to use the PayPal Subscriptions API to create a subscription plan, enroll a customer in a subscription, and retrieve subscription details. It simulates a real-world SaaS platform managing a "Premium Membership" with a trial period, suitable for applications handling subscription-based services like streaming or software platforms.

## Prerequisites

### 1. Set up PayPal Developer Account

Refer to the [Setup Guide](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions#setup-guide) to obtain necessary credentials (`clientId`, `clientSecret`) and create a product to get a `productId`.

### 2. Configuration

Create a `Config.toml` file in the example's root directory and provide your PayPal credentials and product ID as follows:

```toml
clientId = "<your_client_id>"
clientSecret = "<your_client_secret>"
productId = "<your_product_id>"
```

## Run the Example

Execute the following command to run the example:

```bash
bal run
```
