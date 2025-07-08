# Web App with unrestricted public access

Azure Web Apps with unrestricted public network access are potentially vulnerable to attacks from the internet. For sensitive applications, restricting network access by using Virtual Network integration or by disabling public network access provides an additional layer of security.

## Recommendation

Restrict public network access to your Azure Web App by either:

1. Integrating with Azure Virtual Network:
```bicep
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'myWebApp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: subnet.id  // Add VNet integration
  }
}
```

2. Or by explicitly disabling public network access (for critical applications):
```bicep
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'myWebApp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    publicNetworkAccess: 'Disabled'  // Disable public network access
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
    serverFarmId: appServicePlan.id
    // No network restrictions - accessible from anywhere
  }
}
```

### Secure configuration

```bicep
resource secureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'secureApp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    publicNetworkAccess: 'Disabled'
    virtualNetworkSubnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', 'myVNet', 'mySubnet')
  }
}
```

## References
* [Azure App Service networking features](https://learn.microsoft.com/en-us/azure/app-service/networking-features)
* [Configure regional VNet integration](https://learn.microsoft.com/en-us/azure/app-service/configure-vnet-integration-enable)
* [CWE-284: Improper Access Control](https://cwe.mitre.org/data/definitions/284.html)
