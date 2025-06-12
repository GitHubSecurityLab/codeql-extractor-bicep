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
