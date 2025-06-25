# AKS cluster with node auto-scaling disabled

Azure Kubernetes Service (AKS) clusters should have node auto-scaling enabled to efficiently handle varying workloads and prevent resource constraints during high load periods.

## Problem statement

When node auto-scaling is disabled in AKS agent pools, the cluster cannot automatically adjust the number of nodes based on resource demands. This can lead to:

1. Resource constraints during high traffic periods, potentially causing service disruptions
2. Inefficient resource utilization during low traffic periods, resulting in unnecessary costs
3. Manual intervention required to scale the cluster, which may lead to delayed responses to changing workloads

## Recommendation

Enable auto-scaling for AKS agent pools by setting `enableAutoScaling` to `true` and configuring appropriate minimum and maximum node counts:

```bicep
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'efficientAksCluster'
  location: location
  properties: {
    // Other properties...
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        enableAutoScaling: true
        minCount: 1
        maxCount: 5
      }
    ]
    // Other properties...
  }
}
```

## Example

### Inefficient configuration (Auto-scaling disabled)

```bicep
resource aksClusterInefficient 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterInefficient'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        enableAutoScaling: false // Inefficient: Auto-scaling is disabled
      }
    ]
    // Other properties...
  }
}
```

### Efficient configuration (Auto-scaling enabled)

```bicep
resource aksClusterEfficient 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterEfficient'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        enableAutoScaling: true // Efficient: Auto-scaling is enabled
        minCount: 1
        maxCount: 5
      }
    ]
    // Other properties...
  }
}
```

## References

* [Cluster autoscaler in AKS](https://learn.microsoft.com/en-us/azure/aks/concepts-scale#cluster-autoscaler)
* [Best practices for cluster autoscaler in AKS](https://learn.microsoft.com/en-us/azure/aks/cluster-autoscaler#best-practices-for-the-cluster-autoscaler)
