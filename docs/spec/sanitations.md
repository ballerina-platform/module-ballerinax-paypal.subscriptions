_Author_: @RNViththagan \
_Created_: 2025/06/13 \
_Updated_: 2025/06/20 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from PayPal Subscriptions. The OpenAPI specification is obtained from [PayPal REST API Specifications](https://github.com/paypal/paypal-rest-api-specifications/blob/main/openapi/billing_subscriptions_v1.json). These changes are implemented after flattening the OpenAPI specification to enhance usability and address language limitations in the Ballerina OpenAPI tool.

## Sanitization Steps

Following the latest Ballerina connector guidelines, apply these changes **after flattening the OpenAPI specification and without aligning the spec**:

### 1. Change the `url` property of the servers object

- **Original:** `https://api-m.sandbox.paypal.com`
- **Updated:** `https://api-m.sandbox.paypal.com/v1/billing`
- **Reason:** This change ensures that all API paths are relative to the versioned base URL (`/v1/billing`), which improves the consistency and usability of the APIs.

### 2. Update API Paths

- **Original:** Paths included the version prefix in each endpoint (e.g., `/v1/billing/plans`).
- **Updated:** Paths are modified to remove the version prefix from the endpoints, as it is now included in the base URL. For example:
    - **Original:** `/v1/billing/plans`
    - **Updated:** `/plans`
- **Reason:** This modification simplifies the API paths, making them shorter and more readable. It also centralizes the versioning to the base URL, which is a common best practice.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

> Note: The flattened OpenAPI specification must be used for Ballerina client generation to prevent type-inclusion [issue](https://github.com/ballerina-platform/ballerina-lang/issues/38535#issuecomment-2973521948) in the generated types.

```bash
bal openapi -i docs/spec/openapi.json --mode client -o ballerina
```
