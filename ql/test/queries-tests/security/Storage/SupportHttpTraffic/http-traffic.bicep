
param location string = resourceGroup().location
param storageAccountName string = 'httpEnabledStorage'

// Secure
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: [
        {
          ipAddressOrRange: '0.0.0.0/0'
        }
      ]
    }
  }
}

// In-Secure
resource storageAccount2 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: [
        {
          ipAddressOrRange: '0.0.0.0/0'
        }
      ]
    }
  }
}