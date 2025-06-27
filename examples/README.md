# Examples

The `ballerinax/paypal.subscriptions` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions/tree/main/examples), covering use cases like creating and listing subscription plans, and monitoring and managing subscription status.

1. [Create and list plans](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions/tree/main/examples/create-and-list-plans/create-and-list-plans.md) - Create a subscription plan and list all available plans for subscription-based services.
2. [Monitor and manage subscription status](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions/tree/main/examples/monitor-and-manage-subscription/monitor-and-manage-subscription.md) - Retrieve a subscription's status and suspend or reactivate it based on its current state.

## Prerequisites

1. Generate PayPal credentials to authenticate the connector as described in the [Setup guide](https://central.ballerina.io/ballerinax/paypal.subscriptions/latest#setup-guide).
2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    clientId = "<your_client_id>"
    clientSecret = "<your_client_secret>"
    productId = "<your_product_id>"  # Required for create-and-list-plans
    subscriptionId = "<your_subscription_id>"  # Required for monitor-and-manage-subscription
    ```

## Running an Example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
