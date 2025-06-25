_Author_: @RNViththagan \
_Created_: 2025/06/13 \
_Updated_: 2025/06/25 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from PayPal Subscriptions. The OpenAPI specification is obtained from the [PayPal REST API Specifications](https://github.com/paypal/paypal-rest-api-specifications/blob/main/openapi/billing_subscriptions_v1.json). These changes are implemented after flattening and aligning the OpenAPI specification to enhance the overall usability and readability of the generated client.

1. **Renamed schemas with non-compliant names**:
   - **Original**: `Schema'400`, `Schema'401`, `Schema'403`, `Schema'404`, `Schema'422`
   - **Updated**: `BadRequest`, `Unauthorized`, `Forbidden`, `NotFound`, `UnprocessableEntity`
   - **Action**: Updated `$ref` values directly referencing these schemas (e.g., `"$ref": "#/components/schemas/Schema'404"` to `"$ref": "#/components/schemas/NotFound"`).
   - **Reason**: The original schema names contained single quotes, which do not comply with the regular expression `^[a-zA-Z0-9\.\-_]+$`. Renaming ensures compliance and clarity for the Ballerina OpenAPI tool.

2. **Update `tokenUrl` to absolute URL**:
   - **Original**: `/v1/oauth2/token`
   - **Updated**: `https://api-m.sandbox.paypal.com/v1/oauth2/token`
   - **Reason**: Prevents the relative path from being appended to the server URL, avoiding an invalid token endpoint in the OAuth2 client credentials flow.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client -o ballerina
```
