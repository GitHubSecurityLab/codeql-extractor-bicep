# AKS cluster with local accounts enabled

Azure Kubernetes Service (AKS) clusters should have local Kubernetes accounts disabled in favor of Azure Active Directory (Azure AD) integration for stronger authentication controls.

## Problem statement

When local accounts are enabled in AKS clusters:

1. Authentication relies on locally stored credentials rather than centralized Azure AD identities
2. User access management is more manual and error-prone
3. Central audit and monitoring of access is more difficult
4. Advanced security features like Conditional Access policies cannot be applied

## Recommendation

Disable local accounts in AKS clusters by setting `disableLocalAccounts` to `true` and configure Azure AD integration:

```bicep
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'secureAksCluster'
  location: location
  properties: {
    // Other properties...
    disableLocalAccounts: true
    aadProfile: {
      managed: true
      enableAzureRBAC: true
    }
    // Other properties...
  }
}
```

## Example

### Insecure configuration (Local accounts enabled)

```bicep
resource aksClusterInsecure 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterInsecure'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    disableLocalAccounts: false // Insecure: Local accounts are explicitly enabled
    // Or omitting disableLocalAccounts entirely (defaults to false)
    // Other properties...
  }
}
```

### Secure configuration (Local accounts disabled)

```bicep
resource aksClusterSecure 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterSecure'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    disableLocalAccounts: true // Secure: Local accounts are disabled
    aadProfile: {
      managed: true
      enableAzureRBAC: true
    }
    // Other properties...
  }
}
```

## References

* [Use Azure AD with AKS](https://learn.microsoft.com/en-us/azure/aks/managed-aad)
* [AKS best practices for authentication and authorization](https://learn.microsoft.com/en-us/azure/aks/operator-best-practices-identity)
