# Web App without HTTPS-only setting

Azure Web Apps should have the HTTPS-only setting enabled to enforce secure communications. When the HTTPS-only flag is not set, the web app can accept connections over unencrypted HTTP, potentially exposing sensitive information.

## Recommendation

Enable the HTTPS-only setting for all Azure Web Apps to ensure that all traffic is redirected to HTTPS.

In Bicep files, set the `httpsOnly` property to `true`:

```bicep
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'myWebApp'
  location: location
  properties: {
    // other properties
  }
  // Enable HTTPS-only mode
  httpsOnly: true
}
```

## Example

### Insecure configuration

```bicep
resource insecureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'insecureApp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
  // HTTPS-only is not set, defaulting to false
}
```

### Secure configuration

```bicep
resource secureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'secureApp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
  // HTTPS-only is explicitly enabled
  httpsOnly: true
}
```

## References
* [Azure App Service secure settings](https://learn.microsoft.com/en-us/azure/app-service/overview-security#https-and-certificates)
* [Microsoft.Web/sites resource type](https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites)
* [CWE-319: Cleartext Transmission of Sensitive Information](https://cwe.mitre.org/data/definitions/319.html)
