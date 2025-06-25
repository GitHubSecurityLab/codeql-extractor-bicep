// Test file for AKS security queries

// ==== AKS RBAC Tests ====

// GOOD: AKS cluster with RBAC enabled
resource aksClusterRbacGood 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterRbacGood'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsgood'
    enableRBAC: true // Secure configuration with RBAC enabled
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// BAD: AKS cluster with RBAC disabled
resource aksClusterRbacBad 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = { // $ExpectedResult=AKS cluster has RBAC disabled, which can lead to unauthorized access to the cluster.
  name: 'aksClusterRbacBad'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsbad'
    enableRBAC: false // Insecure configuration with RBAC disabled
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// ==== AKS Public Network Access Tests ====

// GOOD: AKS cluster with public network access disabled and private cluster enabled
resource aksClusterNetworkGood 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterNetworkGood'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsnetgood'
    enableRBAC: true
    publicNetworkAccess: 'Disabled' // Secure: Public network access is disabled
    apiServerAccessProfile: {
      enablePrivateCluster: true // Secure: Private cluster is enabled
    }
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// BAD: AKS cluster with public network access explicitly enabled
resource aksClusterNetworkBad1 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = { // $ExpectedResult=AKS cluster has public network access enabled, which can expose the cluster to unauthorized access.
  name: 'aksClusterNetworkBad1'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsnetbad1'
    enableRBAC: true
    publicNetworkAccess: 'Enabled' // Insecure: Public network access is explicitly enabled
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// BAD: AKS cluster with default public network access (not specified)
resource aksClusterNetworkBad2 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = { // $ExpectedResult=AKS cluster has public network access enabled, which can expose the cluster to unauthorized access.
  name: 'aksClusterNetworkBad2'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsnetbad2'
    enableRBAC: true
    // publicNetworkAccess defaults to 'Enabled' when not specified
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// ==== AKS Node Auto-Scaling Tests ====

// GOOD: AKS cluster with node auto-scaling enabled
resource aksClusterAutoScalingGood 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterAutoScalingGood'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsasgood'
    enableRBAC: true
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
  }
}

// BAD: AKS cluster with node auto-scaling explicitly disabled
resource aksClusterAutoScalingBad1 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterAutoScalingBad1'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsasbad1'
    enableRBAC: true
    agentPoolProfiles: [
      { // $ExpectedResult=AKS agent pool 'agentpool' has auto-scaling disabled, which may lead to resource constraints during high load.
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        enableAutoScaling: false // Inefficient: Auto-scaling is explicitly disabled
      }
    ]
  }
}

// BAD: AKS cluster with node auto-scaling not specified (defaults to disabled)
resource aksClusterAutoScalingBad2 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterAutoScalingBad2'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsasbad2'
    enableRBAC: true
    agentPoolProfiles: [
      { // $ExpectedResult=AKS agent pool 'agentpool' has auto-scaling disabled, which may lead to resource constraints during high load.
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        // enableAutoScaling defaults to false when not specified
      }
    ]
  }
}

// ==== AKS Local Accounts Tests ====

// GOOD: AKS cluster with local accounts disabled and AAD integration
resource aksClusterLocalAccountsGood 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterLocalAccountsGood'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnslagood'
    enableRBAC: true
    disableLocalAccounts: true // Secure: Local accounts are disabled
    aadProfile: {
      managed: true
      enableAzureRBAC: true
    }
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// BAD: AKS cluster with local accounts explicitly enabled
resource aksClusterLocalAccountsBad1 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = { // $ExpectedResult=AKS cluster has local accounts enabled, which can lead to weaker authentication controls compared to Azure AD-backed authentication.
  name: 'aksClusterLocalAccountsBad1'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnslabad1'
    enableRBAC: true
    disableLocalAccounts: false // Insecure: Local accounts are explicitly enabled
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// BAD: AKS cluster with local accounts not specified (defaults to enabled)
resource aksClusterLocalAccountsBad2 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = { // $ExpectedResult=AKS cluster has local accounts enabled, which can lead to weaker authentication controls compared to Azure AD-backed authentication.
  name: 'aksClusterLocalAccountsBad2'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnslabad2'
    enableRBAC: true
    // disableLocalAccounts defaults to false when not specified
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// ==== AKS Network Policy Tests ====

// GOOD: AKS cluster with Azure network policy
resource aksClusterNetworkPolicyGood1 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterNetworkPolicyGood1'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsnpgood1'
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure' // Secure: Azure Network Policy
    }
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// GOOD: AKS cluster with Calico network policy
resource aksClusterNetworkPolicyGood2 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterNetworkPolicyGood2'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsnpgood2'
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'calico' // Secure: Calico Network Policy
    }
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// BAD: AKS cluster with network policy explicitly set to none
resource aksClusterNetworkPolicyBad1 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = { // $ExpectedResult=AKS cluster is configured with an insecure or missing network policy, which may allow unwanted pod-to-pod communication.
  name: 'aksClusterNetworkPolicyBad1'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsnpbad1'
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'none' // Insecure: Network policy explicitly set to none
    }
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// BAD: AKS cluster with missing network policy
resource aksClusterNetworkPolicyBad2 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = { // $ExpectedResult=AKS cluster is configured with an insecure or missing network policy, which may allow unwanted pod-to-pod communication.
  name: 'aksClusterNetworkPolicyBad2'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsnpbad2'
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'azure'
      // Missing networkPolicy (defaults to none)
    }
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// ==== AKS Disk Encryption Tests ====

// First, create a disk encryption set resource
resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2022-07-02' = {
  name: 'myDiskEncryptionSet'
  location: 'eastus'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    activeKey: {
      keyUrl: 'https://mykeyvault.vault.azure.net/keys/mykey/1234567890abcdef1234567890abcdef'
    }
  }
}

// GOOD: AKS cluster with disk encryption
resource aksClusterDiskEncryptionGood 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterDiskEncryptionGood'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsdegood'
    enableRBAC: true
    diskEncryptionSetID: diskEncryptionSet.id // Secure: Using disk encryption
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}

// BAD: AKS cluster without disk encryption
resource aksClusterDiskEncryptionBad 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = { // $ExpectedResult=AKS cluster is configured without disk encryption, which can expose sensitive data at rest.
  name: 'aksClusterDiskEncryptionBad'
  location: 'eastus'
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdnsdebad'
    enableRBAC: true
    // Missing diskEncryptionSetID
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
  }
}
