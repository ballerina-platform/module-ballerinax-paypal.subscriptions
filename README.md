# Ballerina Paypal Subscriptions connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-paypal.subscriptions.svg)](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/paypal.subscriptions.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%paypal.subscriptions)

## Overview

[PayPal](https://www.paypal.com/) is a global online payment platform enabling individuals and businesses to securely send and receive money, process transactions, and access merchant services across multiple currencies.

The `ballerinax/paypal.subscriptions` package provides a Ballerina connector for interacting with the [PayPal Subscriptions API v1](https://developer.paypal.com/docs/api/subscriptions/v1/), allowing you to create, manage, and monitor subscription-based billing plans and subscriptions in your Ballerina applications.

## Setup Guide

To use the PayPal Subscriptions connector, you must have access to a [PayPal Developer account](https://developer.paypal.com/).

### Step 1: Create a Business Account

1. Open the [PayPal Developer Dashboard](https://developer.paypal.com/dashboard).

   ![Sandbox accounts](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-paypal.subscriptions/main/docs/setup/resources/sandbox-accounts.png)

3. Create a Business account.
   > Note: Some PayPal options and features may vary by region or country; check availability before creating an account.

   ![Create business account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-paypal.subscriptions/main/docs/setup/resources/create-account.png)

### Step 2: Create a REST API App

1. Navigate to the "Apps and Credentials" tab and create a new merchant app.
2. Provide a name for the application and select the Business account created earlier.
   ![Create app](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-paypal.subscriptions/main/docs/setup/resources/create-app.png)

### Step 3: Obtain Client ID and Client Secret

1. After creating the app, you will see your **Client ID** and **Client Secret**. Copy and securely store these credentials.

   ![Credentials](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-paypal.subscriptions/main/docs/setup/resources/get-credentials.png)

## Quickstart

To use the `paypal.subscriptions` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the Module

Import the `paypal.subscriptions` module.

```ballerina
import ballerinax/paypal.subscriptions as paypal;
```

### Step 2: Instantiate a New Connector

1. Create a `Config.toml` file and configure the obtained credentials and URLs:
   ```toml
   clientId = "<your-client-id>"
   clientSecret = "<your-client-secret>"

   serviceUrl = "<paypal-service-url>"
   tokenUrl = "<paypal-token-url>"
   ```

2. Create a `paypal:ConnectionConfig` with the credentials and initialize the connector:
   ```ballerina
   configurable string clientId = ?;
   configurable string clientSecret = ?;
   configurable string serviceUrl = ?;
   configurable string tokenUrl = ?;

   final paypal:Client paypal = check new ({
       auth: {
           clientId,
           clientSecret,
           tokenUrl
       }
   }, serviceUrl);
   ```

### Step 3: Invoke a Connector Operation

#### Create a Subscription Plan

```ballerina
public function main() returns error? {
    paypal:PlanRequestPOST plan = {
        product_id: "PROD-1234567890",
        name: "Basic Subscription Plan",
        status: "ACTIVE",
        billing_cycles: [
            {
                frequency: {
                    interval_unit: "MONTH",
                    interval_count: 1
                },
                tenure_type: "REGULAR",
                sequence: 1,
                total_cycles: 0,
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
    paypal:Plan response = check paypal->/plans.post(plan);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `PayPal Subscriptions` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions/tree/main/examples/), covering the following use cases:

1. [**Create and List Plans**](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions/tree/main/examples/create-and-list-plans): Create a subscription plan and list all available plans.
2. [**Monitor and Manage Subscription Status**](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions/tree/main/examples/monitor-and-manage-subscription): Retrieve a subscription’s status and suspend or reactivate it based on its state.
3. [**Manage Premium Subscription**](https://github.com/ballerina-platform/module-ballerinax-paypal.subscriptions/tree/main/examples/manage-premium-subscription): Create a subscription plan, enroll a customer, and retrieve subscription details for a premium membership.


## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

   ```bash
   export packageUser=<Username>
   export packagePAT=<Personal access token>
   ```
### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToLocalCentral=true
   ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information, go to the [`paypal.subscriptions` package](https://central.ballerina.io/ballerinax/paypal.subscriptions/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
