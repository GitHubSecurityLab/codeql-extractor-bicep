// Basic AKS cluster with essential settings
// This example showcases a basic AKS cluster with a single system node pool
// Great for development environments or simple workloads

resource basicAksCluster 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: 'basicAksCluster'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.29.0'
    dnsPrefix: 'basicaksdns'
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: 2
        vmSize: 'Standard_D2_v3'
        osType: 'Linux'
        mode: 'System'
        enableAutoScaling: false
      }
    ]
    networkProfile: {
      networkPlugin: 'kubenet'
      loadBalancerSku: 'standard'
    }
    addonProfiles: {
      azurePolicy: {
        enabled: true
      }
    }
    identity: {
      type: 'SystemAssigned'
    }
    sku: {
      name: 'Basic'
      tier: 'Free'
    }
    enableRBAC: true
  }
  tags: {
    environment: 'dev'
    tier: 'basic'
  }
}

// Output the cluster's FQDN
output clusterFqdn string = basicAksCluster.properties.fqdn
