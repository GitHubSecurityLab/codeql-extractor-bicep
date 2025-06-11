# TLS Disabled

Disabling TLS (Transport Layer Security) exposes resources to unencrypted network traffic, making them vulnerable to interception and attacks. Always ensure TLS is enabled for all network-accessible resources.

## Bad Example
The following Bicep resource has `enableNonSslPort` set to `true`, which disables TLS and allows unencrypted connections:

```bicep
resource redis 'Microsoft.Cache/Redis@2021-06-01' = {
  name: 'myredis'
  location: 'eastus'
  properties: {
    enableNonSslPort: true
    publicNetworkAccess: 'Enabled'
  }
}
```

## Good Example
The following Bicep resources either do not set `enableNonSslPort` (defaulting to secure) or explicitly set it to `false`, ensuring TLS is enforced:

```bicep
// TLS enforced by default (property not set)
resource redis1 'Microsoft.Cache/Redis@2021-06-01' = {
  name: 'redis1'
  location: 'eastus'
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

// TLS explicitly enforced
resource redis2 'Microsoft.Cache/Redis@2021-06-01' = {
  name: 'redis2'
  location: 'eastus'
  properties: {
    enableNonSslPort: false
    publicNetworkAccess: 'Enabled'
  }
}
```

## Recommendation
Always leave `enableNonSslPort` unset or set it to `false` to ensure all connections are encrypted using TLS.