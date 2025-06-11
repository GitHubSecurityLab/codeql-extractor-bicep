# SSL / TLS not Enforced

This query detects Azure database resources that have SSL/TLS enforcement disabled. Disabling SSL/TLS enforcement can expose sensitive data to interception and man-in-the-middle attacks, as connections to the database may be established without encryption. It is a security best practice to always require SSL/TLS for database connections to ensure data in transit is protected.

## Bad Example: SSL Enforcement Disabled

```bicep
resource db 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'mydbserver'
  location: 'eastus'
  properties: {
    version: '12.0'
    sslEnforcement: 'Disabled' // BAD: SSL enforcement is disabled
  }
}
```

## Good Example: SSL Enforcement Enabled

```bicep
resource db 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'mydbserver'
  location: 'eastus'
  properties: {
    version: '12.0'
    sslEnforcement: 'Enabled' // GOOD: SSL enforcement is enabled
  }
}
```
