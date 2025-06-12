// Example Bicep file with AKS security issues for CodeQL testing
resource insecureAks 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: 'aks-insecure-public'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.25.6' // Outdated version
    dnsPrefix: 'aks-public'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
        enableAutoScaling: false // No autoscaling
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: false // Public API server
    }
    addonProfiles: {
      kubeDashboard: {
        enabled: true // Insecure: dashboard enabled
      }
    }
  }
}

resource secureAks 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: 'aks-secure-private'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.28.3' // Supported version
    dnsPrefix: 'aks-private'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
        enableAutoScaling: true
        minCount: 1
        maxCount: 5
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: true // Private API server
    }
    addonProfiles: {
      kubeDashboard: {
        enabled: false // Secure: dashboard disabled
      }
    }
  }
}
