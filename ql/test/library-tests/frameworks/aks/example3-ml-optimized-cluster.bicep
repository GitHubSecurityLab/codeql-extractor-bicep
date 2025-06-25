// Specialized AKS cluster optimized for machine learning workloads
// This example demonstrates a hybrid cluster configured for AI/ML workloads with specialized storage,
// auto-scaling, and GPU support for training and inference

resource mlAksCluster 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: 'mlAksCluster'
  location: 'westus2'
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Standard'
    tier: 'Paid'
  }
  properties: {
    kubernetesVersion: '1.29.0'
    dnsPrefix: 'mlaksdns'
    enableRBAC: true
    
    // Multiple specialized node pools for ML workloads
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
        maxPods: 110
      }
      {
        // CPU-optimized node pool for data preprocessing and inference
        name: 'cpupool'
        count: 2
        vmSize: 'Standard_D32s_v3'
        osType: 'Linux'
        mode: 'User'
        availabilityZones: [
          '1', '2'
        ]
        enableAutoScaling: true
        minCount: 2
        maxCount: 20
        osDiskSizeGB: 256
        nodeLabels: {
          workloadType: 'ml-cpu'
          usage: 'preprocessing'
        }
      }
      {
        // GPU node pool for model training
        name: 'trainpool'
        count: 2
        vmSize: 'Standard_NC24rs_v3'  // GPU-optimized VM
        osType: 'Linux'
        mode: 'User'
        availabilityZones: [
          '1', '2'
        ]
        enableAutoScaling: true
        minCount: 0  // Scale to zero when not in use
        maxCount: 10
        osDiskSizeGB: 512
        nodeLabels: {
          workloadType: 'ml-gpu'
          usage: 'training'
          accelerator: 'nvidia'
          'nvidia.com/gpu': 'present'
        }
        nodeTaints: [
          'nvidia.com/gpu=present:NoSchedule'
        ]
      }
      {
        // Specialized pool for inference with GPUs
        name: 'inferencepool'
        count: 2
        vmSize: 'Standard_NC6s_v3'
        osType: 'Linux'
        mode: 'User'
        enableAutoScaling: true
        minCount: 1
        maxCount: 5
        osDiskSizeGB: 256
        nodeLabels: {
          workloadType: 'ml-inference'
          usage: 'serving'
          accelerator: 'nvidia'
        }
      }
    ]
    
    // Network configuration
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
    }
    
    // Auto-scaler profile optimized for batch workloads
    autoScalerProfile: {
      scanInterval: '30s'
      scaleDownDelayAfterAdd: '15m'
      scaleDownDelayAfterDelete: '15s'
      scaleDownDelayAfterFailure: '3m'
      scaleDownUnneededTime: '15m'
      scaleDownUnreadyTime: '15m'
      maxEmptyBulkDelete: '10' // Delete up to 10 unused nodes at once
      expander: 'least-waste' // Optimized for resource utilization
    }
    
    // Storage profile for ML data persistence
    storageProfile: {
      diskCSIDriver: {
        enabled: true
      }
      fileCSIDriver: {
        enabled: true
      }
      snapshotController: {
        enabled: true
      }
      blobCSIDriver: {
        enabled: true
      }
    }
    
    // Add-on profiles for ML workloads
    addonProfiles: {
      azurePolicy: {
        enabled: true
      }
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/mlResourceGroup/providers/Microsoft.OperationalInsights/workspaces/mlAksLogs'
        }
      }
      openServiceMesh: {
        enabled: true
      }
    }
    
    // Workload auto-scaler profile for handling burst compute needs
    workloadAutoScalerProfile: {
      keda: {
        enabled: true
      }
      verticalPodAutoscaler: {
        enabled: true
      }
    }
    
    // Linux profile
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
    
    // Security profile with defender for ML data protection
    securityProfile: {
      defender: {
        logAnalyticsWorkspaceResourceId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/mlResourceGroup/providers/Microsoft.OperationalInsights/workspaces/mlAksLogs'
        securityMonitoring: {
          enabled: true
        }
      }
    }
    
    // OIDC issuer profile for ML workflow automation
    oidcIssuerProfile: {
      enabled: true
    }
  }
  
  tags: {
    environment: 'ml-training'
    department: 'data-science'
    costCenter: 'ML-789012'
    owner: 'ml-platform-team'
    criticalWorkload: 'true'
  }
}

// Outputs
output clusterFqdn string = mlAksCluster.properties.fqdn
output oidcIssuerUrl string = mlAksCluster.properties.oidcIssuerProfile.issuerURL
