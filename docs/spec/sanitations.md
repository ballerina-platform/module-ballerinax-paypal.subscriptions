_Author_: @RNViththagan \
_Created_: 2025/06/13 \
_Updated_: 2025/06/20 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from PayPal Subscriptions. The OpenAPI specification is obtained from [PayPal REST API Specifications](https://github.com/paypal/paypal-rest-api-specifications/blob/main/openapi/billing_subscriptions_v1.json). These changes are implemented after flattening the OpenAPI specification to enhance usability and address language limitations in the Ballerina OpenAPI tool.

## Sanitization Steps

Following the latest Ballerina connector guidelines, apply these changes **after flattening the OpenAPI specification and without aligning the spec**:

### 1. Update `servers` URLs to include `/v1/billing`

**Before:**
```json
"servers" : [ {
    "url" : "https://api-m.sandbox.paypal.com",
    "description" : "PayPal Sandbox Environment"
  }, {
    "url" : "https://api-m.paypal.com",
    "description" : "PayPal Live Environment"
  } ],
```

**After:**
```json
"servers" : [ {
    "url" : "https://api-m.sandbox.paypal.com/v1/billing",
    "description" : "PayPal Sandbox Environment"
  }, {
    "url" : "https://api-m.paypal.com/v1/billing",
    "description" : "PayPal Live Environment"
  } ],
```

### 2. Remove `/v1/billing` from all path keys

**Before:**
```json
"paths" : {
  "/v1/billing/plans" : {
    // ...existing code...
  },
  "/v1/billing/subscriptions" : {
    // ...existing code...
  }
}
```

**After:**
```json
"paths" : {
  "/plans" : {
    // ...existing code...
  },
  "/subscriptions" : {
    // ...existing code...
  }
}
```

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.yaml --mode client -o ballerina
```

Note: The license year is hardcoded to 2025, change if necessary.