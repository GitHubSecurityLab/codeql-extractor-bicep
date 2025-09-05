// Examples of for loops in Bicep

// Parameters for the examples
param location string = resourceGroup().location
param storageCount int = 3
param environmentNames array = [
  'dev'
  'test'
  'prod'
]
param resourceConfigs object = {
  small: {
    sku: 'Standard_LRS'
    kind: 'StorageV2'
  }
  medium: {
    sku: 'Standard_GRS'
    kind: 'StorageV2'
  }
  large: {
    sku: 'Premium_LRS'
    kind: 'BlockBlobStorage'
  }
}

// Example 1: For loop with an integer index (range)
// Creates multiple storage accounts with indexed names
resource storageAccounts 'Microsoft.Storage/storageAccounts@2023-05-01' = [for i in range(0, storageCount): {
  name: 'store${i}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: {
    index: '${i}'
    purpose: 'Example 1'
  }
}]

// Example 2: For loop with array elements
// Creates resources with names from an array
resource appServicePlans 'Microsoft.Web/serverfarms@2022-03-01' = [for envName in environmentNames: {
  name: 'plan-${envName}'
  location: location
  sku: {
    name: envName == 'prod' ? 'P1v2' : 'B1'
    tier: envName == 'prod' ? 'PremiumV2' : 'Basic'
  }
  tags: {
    environment: envName
    purpose: 'Example 2'
  }
}]

// Example 3: For loop with array and index
// Creates resources using both the array element and index
resource appServices 'Microsoft.Web/sites@2022-03-01' = [for (envName, i) in environmentNames: {
  name: 'app-${envName}-${i}'
  location: location
  properties: {
    serverFarmId: appServicePlans[i].id
  }
  tags: {
    environment: envName
    index: '${i}'
    purpose: 'Example 3'
  }
}]

// Example 4: For loop with object/dictionary
// Iterates over object properties using items()
resource configuredStorageAccounts 'Microsoft.Storage/storageAccounts@2023-05-01' = [for config in items(resourceConfigs): {
  name: 'store${config.key}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: config.value.sku
  }
  kind: config.value.kind
  tags: {
    size: config.key
    purpose: 'Example 4'
  }
}]

// Example 5: For loop with condition
// Creates resources conditionally
resource conditionalNetworkSecurityGroups 'Microsoft.Network/networkSecurityGroups@2023-11-01' = [for (envName, i) in environmentNames: if (envName != 'dev') {
  name: 'nsg-${envName}'
  location: location
  tags: {
    environment: envName
    index: '${i}'
    purpose: 'Example 5'
  }
}]

// Example 6: For loop in an object property
// Using a for loop within an object definition
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-main'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [for (envName, i) in environmentNames: {
      name: 'subnet-${envName}'
      properties: {
        addressPrefix: '10.0.${i}.0/24'
        networkSecurityGroup: envName != 'dev' ? {
          id: conditionalNetworkSecurityGroups[i - (environmentNames[0] == 'dev' ? 1 : 0)].id
        } : null
      }
    }]
  }
  tags: {
    purpose: 'Example 6'
  }
}

// Example 7: Batch size decorator for serial deployment
@batchSize(1)
resource batchedDeployment 'Microsoft.Storage/storageAccounts@2023-05-01' = [for i in range(0, storageCount): {
  name: 'batch${i}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: {
    index: '${i}'
    purpose: 'Example 7'
  }
}]

// Outputs using for loops
output storageAccountIds array = [for i in range(0, storageCount): {
  name: storageAccounts[i].name
  id: storageAccounts[i].id
}]

output appServiceUrls array = [for (envName, i) in environmentNames: {
  environment: envName
  url: 'https://${appServices[i].properties.defaultHostName}'
}]
