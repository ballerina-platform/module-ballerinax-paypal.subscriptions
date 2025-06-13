_Author_: @RNViththagan \
_Created_: 2025/06/13 \
_Updated_: 2025/06/13 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from PayPal Subscriptions. The OpenAPI specification is obtained from [PayPal REST API Specifications](https://github.com/paypal/paypal-rest-api-specifications/blob/main/openapi/billing_subscriptions_v1.json). These changes are implemented after flattening and aligning the OpenAPI specification to enhance usability and address language limitations in the Ballerina OpenAPI tool.

1. **Renamed schema `Schema'400` to `BadRequest`**:
   - **Original**: `Schema'400`
   - **Updated**: `BadRequest`
   - **Action**: Updated `$ref` values directly referencing this schema (e.g., `"$ref": "#/components/schemas/Schema'400"` to `"$ref": "#/components/schemas/BadRequest"`).
   - **Reason**: The original schema name contained a single quote, which does not comply with the regular expression `^[a-zA-Z0-9\.\-_]+$`. Renaming improves compatibility with the Ballerina OpenAPI tool.

2. **Renamed schema `Schema'401` to `Unauthorized`**:
   - **Original**: `Schema'401`
   - **Updated**: `Unauthorized`
   - **Action**: Updated `$ref` values directly referencing this schema (e.g., `"$ref": "#/components/schemas/Schema'401"` to `"$ref": "#/components/schemas/Unauthorized"`).
   - **Reason**: The original schema name contained a single quote, which does not comply with the regular expression `^[a-zA-Z0-9\.\-_]+$`. Renaming ensures compliance and clarity.

3. **Renamed schema `Schema'403` to `Forbidden`**:
   - **Original**: `Schema'403`
   - **Updated**: `Forbidden`
   - **Action**: Updated `$ref` values directly referencing this schema (e.g., `"$ref": "#/components/schemas/Schema'403"` to `"$ref": "#/components/schemas/Forbidden"`).
   - **Reason**: The original schema name contained a single quote, which does not comply with the regular expression `^[a-zA-Z0-9\.\-_]+$`. Renaming enhances compatibility.

4. **Renamed schema `Schema'404` to `NotFound`**:
   - **Original**: `Schema'404`
   - **Updated**: `NotFound`
   - **Action**: Updated `$ref` values directly referencing this schema (e.g., `"$ref": "#/components/schemas/Schema'404"` to `"$ref": "#/components/schemas/NotFound"`).
   - **Reason**: The original schema name contained a single quote, which does not comply with the regular expression `^[a-zA-Z0-9\.\-_]+$`. Renaming improves usability and compliance.

5. **Renamed schema `Schema'422` to `UnprocessableEntity`**:
   - **Original**: `Schema'422`
   - **Updated**: `UnprocessableEntity`
   - **Action**: Updated `$ref` values directly referencing this schema (e.g., `"$ref": "#/components/schemas/Schema'422"` to `"$ref": "#/components/schemas/UnprocessableEntity"`).
   - **Reason**: The original schema name contained a single quote, which does not comply with the regular expression `^[a-zA-Z0-9\.\-_]+$`. Renaming ensures compliance and clarity.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.yaml --mode client -o ballerina
```

Note: The license year is hardcoded to 2025, change if necessary.