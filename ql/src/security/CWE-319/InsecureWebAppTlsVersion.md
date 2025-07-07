# Insecure TLS version in Web App

Using an insecure TLS version (TLS 1.0 or TLS 1.1) in an Azure Web App may lead to security vulnerabilities. These older TLS versions have known security weaknesses that can be exploited by attackers.

## Recommendation

Configure Web Apps to use at least TLS 1.2 by setting the `minTlsVersion` property to "1.2".

## Example

Insecure configuration:

```bicep
resource webApp 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp'
  properties: {
    siteConfig: {
      minTlsVersion: '1.1'
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
      minTlsVersion: '1.2'
    }
  }
}
```

## References

* [Azure Web App Security Best Practices](https://learn.microsoft.com/en-us/azure/app-service/security-recommendations)
* [Transport Layer Security (TLS) - Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/configure-ssl-bindings#enforce-tls-versions)
* [Common Weakness Enumeration: CWE-319](https://cwe.mitre.org/data/definitions/319.html)
