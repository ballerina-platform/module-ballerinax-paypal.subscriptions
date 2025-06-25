_Author_: @RNViththagan \
_Created_: 2025/06/13 \
_Updated_: 2025/06/25 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from PayPal Subscriptions. The OpenAPI specification is obtained from the [PayPal REST API Specifications](https://github.com/paypal/paypal-rest-api-specifications/blob/main/openapi/billing_subscriptions_v1.json). These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

## 1. Update OAuth2 token URL to relative URL

**Location**: `components.securitySchemes.Oauth2.flows.clientCredentials.tokenUrl`

**Original**: `"tokenUrl": "/v1/oauth2/token"`

**Sanitized**: `"tokenUrl": "https://api-m.sandbox.paypal.com/v1/oauth2/token"`

```diff
- "tokenUrl": "/v1/oauth2/token"
+ "tokenUrl": "https://api-m.sandbox.paypal.com/v1/oauth2/token"
```

**Reason**: The relative path does not resolve correctly against the OAuth2 endpoint.

## 2. Replace `Schema'<Code>` keys with related status codes

**Original**: `Schema'400`, `Schema'401`, `Schema'403`, `Schema'404`, `Schema'422`

**Sanitized**: `BadRequest`, `Unauthorized`, `Forbidden`, `NotFound`, `UnprocessableEntity`

**Action**: Updated `$ref` values directly referencing these schemas (e.g., `"$ref": "#/components/schemas/Schema'404"` to `"$ref": "#/components/schemas/NotFound"`).

**Reason**: JSON keys with apostrophes (e.g., `Schema'404`) are invalid and break schema parsing; using plain, descriptive identifiers (e.g., `NotFound`) ensures valid JSON Schema and prevents generator errors. See GitHub issue [#8011](https://github.com/ballerina-platform/ballerina-library/issues/8011) for details.

## 3. Avoid JSON data annotations due to lang bug

**Original**:

```json
"x-ballerina-name": "billingCycleSequence"
```

**Sanitized**:

```json
"x-ballerina-name-ignore": "billingCycleSequence"
```

```diff
- "x-ballerina-name": "billingCycleSequence"
+ "x-ballerina-name-ignore": "billingCycleSequence"
```

**Reason**: Due to issue [#38535](https://github.com/ballerina-platform/ballerina-lang/issues/38535), the data binding fails for the fields which have JSON data name annotations. The above change will avoid adding these annotations to the fields.

## OpenAPI CLI command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client -o ballerina
```
