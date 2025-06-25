# AKS cluster with public network access enabled

Azure Kubernetes Service (AKS) clusters with public network access enabled can be accessed from any public IP address, which may expose the cluster to potential attackers on the internet.

## Problem statement

When public network access is enabled on an AKS cluster (which is the default setting), the Kubernetes API server is accessible from the internet. This increases the attack surface of the cluster and makes it vulnerable to various attacks including brute force attempts, exploitation of known vulnerabilities, and unauthorized access attempts.

## Recommendation

Disable public network access by setting the `publicNetworkAccess` property to `'Disabled'` and enable private cluster access using `apiServerAccessProfile.enablePrivateCluster` set to `true`. This ensures that the Kubernetes API server is only accessible from within your virtual network.

```bicep
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'secureAksCluster'
  location: location
  properties: {
    // Other properties...
    publicNetworkAccess: 'Disabled'
    apiServerAccessProfile: {
      enablePrivateCluster: true
    }
    // Other properties...
  }
}
```

## Example

### Insecure configuration (Public network access enabled)

```bicep
resource aksClusterInsecure 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterInsecure'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    publicNetworkAccess: 'Enabled' // Insecure: Public network access is enabled
    // Default with no apiServerAccessProfile is also insecure
    // Other properties...
  }
}
```

### Secure configuration (Public network access disabled)

```bicep
resource aksClusterSecure 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterSecure'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    publicNetworkAccess: 'Disabled' // Secure: Public network access is disabled
    apiServerAccessProfile: {
      enablePrivateCluster: true // Secure: Private cluster is enabled
    }
    // Other properties...
  }
}
```

## References

* [Azure Kubernetes Service (AKS) network concepts](https://learn.microsoft.com/en-us/azure/aks/concepts-network)
* [Create a private AKS cluster](https://learn.microsoft.com/en-us/azure/aks/private-clusters)
