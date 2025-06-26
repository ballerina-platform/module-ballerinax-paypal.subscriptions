## Create and List Subscription Plans

This use case demonstrates how the PayPal Subscriptions API can be used to create a new subscription plan and list all available plans. It showcases the ability to define billing plans for services and retrieve plan details, which is useful for applications managing subscription-based offerings, such as SaaS platforms.

## Prerequisites

### 1. Set up PayPal Developer account

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