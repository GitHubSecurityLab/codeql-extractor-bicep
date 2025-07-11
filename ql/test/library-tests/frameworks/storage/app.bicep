// Example 1: Standard general-purpose v2 storage account with default settings
resource storageAccount1 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'examplestorage1'
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {}
}

// Example 2: Storage account with advanced security and network rules
resource storageAccount2 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'examplestorage2'
  location: 'westeurope'
  sku: {
    name: 'Standard_GRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '203.0.113.0/24'
        }
      ]
    }
    supportsHttpsTrafficOnly: true
  }
}

// Example 3: Blob storage account with hierarchical namespace (Data Lake Storage Gen2)
resource storageAccount3 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'examplestorage3'
  location: 'centralus'
  sku: {
    name: 'Standard_RAGRS'
  }
  kind: 'BlobStorage'
  properties: {
    accessTier: 'Hot'
    isHnsEnabled: true
  }
}

// Example 4: Storage account with Microsoft-managed keys (default encryption)
resource storageAccount4 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'examplestorage4'
  location: 'eastus2'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    encryption: {
      keySource: 'Microsoft.Storage'
    }
  }
}

// Example 5: Storage account with customer-managed keys from Key Vault
resource storageAccount5 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'examplestorage5'
  location: 'uksouth'
  sku: {
    name: 'Standard_GRS'
  }
  kind: 'StorageV2'
  properties: {
    encryption: {
      keySource: 'Microsoft.Keyvault'
      keyvaultproperties: {
        keyname: 'my-key'
        keyvaulturi: 'https://myvault.vault.azure.net/'
        keyversion: '1234567890abcdef'
      }
    }
  }
}

// Example 6: Storage account with per-service encryption and infrastructure encryption
resource storageAccount6 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'examplestorage6'
  location: 'australiaeast'
  sku: {
    name: 'Standard_ZRS'
  }
  kind: 'StorageV2'
  properties: {
    encryption: {
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: true
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Service'
        }
        queue: {
          enabled: false
          keyType: 'Account'
        }
        table: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
  }
}

// Example 1: Managed disk with Standard_LRS
resource disk1 'Microsoft.Compute/disks@2022-07-02' = {
  name: 'exampledisk1'
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 128
    osType: 'Windows'
  }
}

// Example 2: Premium SSD disk with zone and encryption
resource disk2 'Microsoft.Compute/disks@2022-07-02' = {
  name: 'exampledisk2'
  location: 'westeurope'
  zones: ['1']
  sku: {
    name: 'Premium_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 256
    encryption: {
      type: 'EncryptionAtRestWithPlatformKey'
    }
  }
}

// Example 3: Disk pool with two attached disks
resource diskPool 'Microsoft.StoragePool/diskPools@2021-08-01' = {
  name: 'examplediskpool'
  location: 'centralus'
  sku: {
    name: 'Basic'
  }
  properties: {
    subnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myrg/providers/Microsoft.Network/virtualNetworks/myvnet/subnets/mysubnet'
    disks: [
      {
        id: disk1.id
      }
      {
        id: disk2.id
      }
    ]
    availabilityZones: ['1']
  }
}
