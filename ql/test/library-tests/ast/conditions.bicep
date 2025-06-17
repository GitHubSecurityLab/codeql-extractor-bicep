param enableStorageAccount bool = false
param storageAccountName string = 'examplestorageacct'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = if (enableStorageAccount) {
  name: storageAccountName
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {}
}
