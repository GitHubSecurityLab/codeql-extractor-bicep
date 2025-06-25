# AKS cluster with insecure network policy

Azure Kubernetes Service (AKS) clusters should be configured with a secure network policy to limit pod-to-pod communication and reduce the attack surface within the cluster.

## Problem statement

When an AKS cluster is configured without a network policy or with the policy set to `'none'`, pods can communicate with each other without restrictions, which:

1. Violates the principle of least privilege
2. Increases the risk of lateral movement in case of a breach
3. Makes it difficult to enforce network segmentation within the cluster
4. Allows potential attackers to move freely within the network once they gain access to a pod

## Recommendation

Configure your AKS cluster with a secure network policy such as `'azure'` (Azure Network Policy) or `'calico'` (Calico Network Policy):

```bicep
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'secureAksCluster'
  location: location
  properties: {
    // Other properties...
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure' // Or 'calico'
      // Other network settings...
    }
    // Other properties...
  }
}
```

## Example

### Insecure configuration (Missing or none network policy)

```bicep
resource aksClusterInsecure1 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterInsecure1'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    networkProfile: {
      networkPlugin: 'azure'
      // Missing networkPolicy (defaults to none)
    }
    // Other properties...
  }
}

resource aksClusterInsecure2 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterInsecure2'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'none' // Explicitly set to none (insecure)
    }
    // Other properties...
  }
}
```

### Secure configuration (Azure or Calico network policy)

```bicep
resource aksClusterSecure1 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterSecure1'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure' // Secure: Azure Network Policy
    }
    // Other properties...
  }
}

resource aksClusterSecure2 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterSecure2'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'calico' // Secure: Calico Network Policy
    }
    // Other properties...
  }
}
```

## References

* [Network policies for AKS](https://learn.microsoft.com/en-us/azure/aks/use-network-policies)
* [Azure Network Policy vs Calico Network Policy](https://learn.microsoft.com/en-us/azure/aks/concepts-network#azure-network-policy-vs-calico-network-policy)
* [Secure pod traffic with network policies in AKS](https://learn.microsoft.com/en-us/azure/aks/use-network-policies)
