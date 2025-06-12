// Example Bicep file for an Azure Kubernetes Service (AKS) cluster with custom node pool and settings
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: 'myAksCluster'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.29.0'
    dnsPrefix: 'myaksdns'
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
        enableAutoScaling: true
        minCount: 1
        maxCount: 5
      }
      {
        name: 'nodepool2'
        count: 2
        vmSize: 'Standard_DS3_v2'
        osType: 'Linux'
        mode: 'User'
        enableAutoScaling: false
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
      networkPolicy: 'azure'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: false
      authorizedIpRanges: [
        '203.0.113.0/24'
        '198.51.100.0/24'
      ]
    }
    addonProfiles: {
      kubeDashboard: {
        enabled: false
      }
      azurePolicy: {
        enabled: true
      }
    }
    identity: {
      type: 'SystemAssigned'
    }
    linuxProfile: {
      adminUsername: 'azureuser'
      ssh: {
        publicKeys: [
          {
            keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD...generatedkey... user@host'
          }
        ]
      }
    }
    sku: {
      name: 'Basic'
      tier: 'Free'
    }
    tags: {
      environment: 'dev'
      owner: 'team-aks'
    }
  }
}
