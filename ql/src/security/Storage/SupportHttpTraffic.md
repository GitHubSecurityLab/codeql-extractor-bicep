# Support for HTTP traffic

## Overview

Using HTTP for Azure Storage Accounts is insecure because HTTP transmits data in plaintext, making it vulnerable to interception and eavesdropping by malicious actors. This lack of encryption can expose sensitive information, such as authentication tokens, account keys, or data being transferred, to potential attacks like man-in-the-middle (MITM). Enforcing HTTPS ensures that data is encrypted in transit, providing a secure communication channel and protecting against unauthorized access or data breaches.

## Enforcing HTTPS

To enforce HTTPS for Azure Storage Accounts, you can either set the `supportsHttpsTrafficOnly` property to `true` in the Bicep template.

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  // ...
  properties: {
    supportsHttpsTrafficOnly: true
    // ...
  }
}
```
