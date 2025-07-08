# Web App without Client Certificate requirement

Azure Web Apps that handle sensitive operations should consider requiring client certificates for mutual TLS authentication. Client certificates provide an additional layer of security by ensuring that only authenticated clients with valid certificates can access the application.

## Recommendation

For applications handling sensitive information or operations, enable and require client certificates:

```bicep
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'mySecureWebApp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    clientCertEnabled: true
    clientCertMode: 'Required'  // Enforce client certificate validation
  }
  httpsOnly: true
}
```

## Example

### Incomplete configuration

```bicep
resource webAppWithIncompleteConfig 'Microsoft.Web/sites@2022-03-01' = {
  name: 'myWebApp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    // Client certificates are enabled but not required
    clientCertEnabled: true
    // Missing clientCertMode: 'Required'
  }
  httpsOnly: true
}
```

### Secure configuration

```bicep
resource secureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'mySecureWebApp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    clientCertEnabled: true
    clientCertMode: 'Required'  // Certificates are required
  }
  httpsOnly: true
}
```

## References
* [Configure TLS mutual authentication for Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/app-service-web-configure-tls-mutual-auth)
* [Microsoft.Web/sites resource type](https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites)
* [CWE-295: Improper Certificate Validation](https://cwe.mitre.org/data/definitions/295.html)
