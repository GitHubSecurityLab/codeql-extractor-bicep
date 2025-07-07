# Remote debugging enabled in Web App

Enabling remote debugging in production Azure Web Apps is a security risk. Remote debugging allows developers to connect to and debug the web application remotely, which can expose sensitive information and potentially allow unauthorized access to the application.

## Recommendation

Disable remote debugging in production environments. Remote debugging should only be enabled temporarily for development and troubleshooting purposes, and should be disabled once troubleshooting is complete.

## Example

Insecure configuration:

```bicep
resource webApp 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp'
  properties: {
    siteConfig: {
      remoteDebuggingEnabled: true
    }
  }
}
```

Secure configuration:

```bicep
resource webApp 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp'
  properties: {
    siteConfig: {
      remoteDebuggingEnabled: false // or omit this property as it defaults to false
    }
  }
}
```

## References

* [Azure Web App Security Best Practices](https://learn.microsoft.com/en-us/azure/app-service/security-recommendations)
* [Remote debugging in Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/configure-language-dotnet-framework#remote-debugging)
* [Common Weakness Enumeration: CWE-306](https://cwe.mitre.org/data/definitions/306.html)
