# Weak TLS Version

This query detects Azure resources that are configured to use weak or deprecated TLS versions, such as TLS 1.0 or TLS 1.1. Using outdated TLS versions exposes services to known vulnerabilities and increases the risk of data breaches or man-in-the-middle attacks. It is a security best practice to require the latest supported TLS version (such as TLS 1.2 or higher) for all resources.

## Bad Example: Weak TLS Version Configured

```bicep
resource db 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'weaktlsdb'
  location: 'eastus'
  properties: {
    minimalTlsVersion: '1.0' // BAD: Weak TLS version
  }
}
```

## Good Example: Strong TLS Version Configured

```bicep
resource db 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'securetlsdb'
  location: 'eastus'
  properties: {
    minimalTlsVersion: '1.2' // GOOD: Strong TLS version
  }
}
```