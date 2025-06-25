// Advanced production-ready AKS cluster with multiple node pools
// This example demonstrates a highly available production cluster with multiple specialized node pools,
// advanced networking, and extensive security settings

resource advancedAksCluster 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: 'prodAksCluster'
  location: 'eastus2'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aksIdentity': {}
    }
  }
  sku: {
    name: 'Standard'
    tier: 'Paid'
  }
  properties: {
    kubernetesVersion: '1.29.0'
    dnsPrefix: 'prodaksdns'
    enableRBAC: true
    disableLocalAccounts: true
    nodeResourceGroup: 'mc_aksResourceGroup_prodAksCluster'
    
    // Multiple node pools for different workload types
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: 3
        vmSize: 'Standard_D4s_v3'
        osType: 'Linux'
        mode: 'System'
        availabilityZones: [
          '1', '2', '3'
        ]
        enableAutoScaling: true
        minCount: 3
        maxCount: 5
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        maxPods: 110
        vnetSubnetID: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/aksVnet/subnets/systemNodePool'
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
      }
      {
        name: 'userpool1'
        count: 3
        vmSize: 'Standard_D8s_v3'
        osType: 'Linux'
        mode: 'User'
        availabilityZones: [
          '1', '2', '3'
        ]
        enableAutoScaling: true
        minCount: 3
        maxCount: 10
        osDiskSizeGB: 256
        osDiskType: 'Managed'
        maxPods: 110
        vnetSubnetID: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/aksVnet/subnets/userNodePool1'
        nodeLabels: {
          workloadType: 'general'
          environment: 'prod'
        }
      }
      {
        name: 'gpupool'
        count: 2
        vmSize: 'Standard_NC6s_v3'
        osType: 'Linux'
        mode: 'User'
        availabilityZones: [
          '1', '2'
        ]
        enableAutoScaling: true
        minCount: 0
        maxCount: 4
        osDiskSizeGB: 256
        osDiskType: 'Managed'
        maxPods: 50
        vnetSubnetID: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/aksVnet/subnets/gpuNodePool'
        nodeLabels: {
          workloadType: 'gpu'
          accelerator: 'nvidia'
        }
        nodeTaints: [
          'gpu=true:NoSchedule'
        ]
      }
    ]
    
    // Advanced networking configuration
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'calico'
      loadBalancerSku: 'standard'
      outboundType: 'userDefinedRouting'
      serviceCidr: '172.16.0.0/16'
      dnsServiceIP: '172.16.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
    }
    
    // Private cluster configuration
    apiServerAccessProfile: {
      enablePrivateCluster: true
      privateDNSZone: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Network/privateDnsZones/privatelink.eastus2.azmk8s.io'
      enablePrivateClusterPublicFQDN: false
    }
    
    // AAD integration
    aadProfile: {
      managed: true
      enableAzureRBAC: true
      adminGroupObjectIDs: [
        '11111111-1111-1111-1111-111111111111'
        '22222222-2222-2222-2222-222222222222'
      ]
    }
    
    // Add-on profiles
    addonProfiles: {
      azurePolicy: {
        enabled: true
      }
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/aksLogs'
        }
      }
      ingressApplicationGateway: {
        enabled: true
        config: {
          applicationGatewayId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Network/applicationGateways/aksAppGateway'
        }
      }
      openServiceMesh: {
        enabled: true
      }
      aciConnectorLinux: {
        enabled: false
      }
    }
    
    // Security profile with defender
    securityProfile: {
      defender: {
        logAnalyticsWorkspaceResourceId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/aksLogs'
        securityMonitoring: {
          enabled: true
        }
      }
    }
    
    // Auto upgrade profile
    autoUpgradeProfile: {
      upgradeChannel: 'stable'
    }
    
    // Linux profile for SSH access
    linuxProfile: {
      adminUsername: 'aksadmin'
      ssh: {
        publicKeys: [
          {
            keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD...redacted...KeyData'
          }
        ]
      }
    }
    
    windowsProfile: {
      adminUsername: 'aksadmin'
      adminPassword: 'P@ssw0rd1234!'
      enableCSIProxy: true
    }
  }
  
  tags: {
    environment: 'production'
    criticality: 'high'
    dataClassification: 'confidential'
    costCenter: 'IT-123456'
    owner: 'platform-team'
  }
}

output clusterFqdn string = advancedAksCluster.properties.fqdn
