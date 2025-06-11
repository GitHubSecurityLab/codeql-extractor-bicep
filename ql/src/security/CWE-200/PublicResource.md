# Internal Resource is Public to the Internet

This query detects Azure resources that are inadvertently exposed to the public internet. Publicly accessible resources can be targeted by attackers, leading to data breaches, service disruption, or unauthorized access. It is a security best practice to restrict access to internal resources by using private endpoints, network security groups, or firewalls to limit exposure.

## Bad Example: Publicly Accessible Resource

```bicep
resource storage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'publicstorage'
  location: 'eastus'
  properties: {
    allowBlobPublicAccess: true // BAD: Public access is enabled
  }
}
```

## Good Example: Internal-Only Resource

```bicep
resource storage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'privatestorage'
  location: 'eastus'
  properties: {
    allowBlobPublicAccess: false // GOOD: Public access is disabled
  }
}
```
