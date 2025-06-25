# AKS cluster with RBAC disabled

Azure Kubernetes Service (AKS) clusters should have Role-Based Access Control (RBAC) enabled to properly restrict access to cluster resources based on user roles and permissions.

## Problem statement

When RBAC is disabled in AKS, anyone with access to the cluster can potentially perform any action on any resource within the cluster. This creates a significant security vulnerability as there's no fine-grained access control to protect sensitive operations.

## Recommendation

Always enable RBAC for AKS clusters by setting `enableRBAC` to `true` in your Bicep template:

```bicep
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'secureAksCluster'
  location: location
  properties: {
    // Other properties...
    enableRBAC: true
    // Other properties...
  }
}
```

## Example

### Insecure configuration (RBAC disabled)

```bicep
resource aksClusterInsecure 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterInsecure'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    enableRBAC: false // Insecure: RBAC is disabled
    // Other properties...
  }
}
```

### Secure configuration (RBAC enabled)

```bicep
resource aksClusterSecure 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterSecure'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    enableRBAC: true // Secure: RBAC is enabled
    // Other properties...
  }
}
```

## References

* [Azure Kubernetes Service RBAC](https://learn.microsoft.com/en-us/azure/aks/concepts-identity#kubernetes-rbac)
* [Security best practices for AKS](https://learn.microsoft.com/en-us/azure/aks/security-best-practices)
