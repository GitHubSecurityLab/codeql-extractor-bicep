# Web App with Remote Debugging enabled

Remote debugging should be disabled in production Azure Web Apps. When remote debugging is enabled in a production environment, it can expose sensitive information and potentially allow unauthorized access to your application.

## Recommendation

Disable remote debugging in production environments:

```bicep
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'myWebApp'
  location: location
  properties: {
    siteConfig: {
      // Ensure remote debugging is disabled
      remoteDebuggingEnabled: false
      // or omit the property entirely as it defaults to false
    }
  }
}
```

## Example

### Insecure configuration

```bicep
resource insecureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'insecureApp'
  location: location
  properties: {
    siteConfig: {
      // Remote debugging should never be enabled in production
      remoteDebuggingEnabled: true
      remoteDebuggingVersion: 'VS2019'
    }
  }
}
```

### Secure configuration

```bicep
resource secureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'secureApp'
  location: location
  properties: {
    siteConfig: {
      // Remote debugging is explicitly disabled
      remoteDebuggingEnabled: false
    }
  }
}
```

## References
* [Azure App Service security best practices](https://learn.microsoft.com/en-us/azure/app-service/security-recommendations)
* [Microsoft.Web/sites resource type](https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites)
* [CWE-306: Missing Authentication for Critical Function](https://cwe.mitre.org/data/definitions/306.html)
