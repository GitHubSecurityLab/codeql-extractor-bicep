# Insecure FTPS state in Web App

Using insecure FTP or allowing both FTP and FTPS in Azure Web Apps can expose sensitive credentials and data. FTP (File Transfer Protocol) transmits data and credentials in plaintext, which can be intercepted by attackers through network sniffing.

## Recommendation

Use secure file transfer by setting the `ftpsState` property to `FtpsOnly` to enforce FTPS (FTP Secure), which encrypts the connection. If file transfer is not needed, consider setting it to `Disabled`.

## Example

Insecure configurations:

```bicep
// Allows both FTP and FTPS
resource webApp1 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp1'
  properties: {
    siteConfig: {
      ftpsState: 'AllAllowed'
    }
  }
}

// Only allows insecure FTP
resource webApp2 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp2'
  properties: {
    siteConfig: {
      ftpsState: 'FtpOnly'
    }
  }
}
```

Secure configurations:

```bicep
// Only allows secure FTPS
resource webApp3 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp3'
  properties: {
    siteConfig: {
      ftpsState: 'FtpsOnly'
    }
  }
}

// Disables both FTP and FTPS
resource webApp4 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp4'
  properties: {
    siteConfig: {
      ftpsState: 'Disabled'
    }
  }
}
```

## References

* [Azure Web App Security Best Practices](https://learn.microsoft.com/en-us/azure/app-service/security-recommendations)
* [FTP/S connection settings for Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/configure-ftp-deploy)
* [Common Weakness Enumeration: CWE-319](https://cwe.mitre.org/data/definitions/319.html)
