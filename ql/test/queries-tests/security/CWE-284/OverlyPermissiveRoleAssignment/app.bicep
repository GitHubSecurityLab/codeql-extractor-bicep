// Test cases for overly permissive role assignments

@description('Service principal object ID')
param spObjectId string

@description('User object ID for testing')
param userObjectId string

@description('Role definition ID parameter for secure pattern')
@allowed([
  'ba92f5b4-2d11-453d-a403-e96b0029c9fe' // Storage Blob Data Reader
])
param restrictedRoleDefinitionId string = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

// VULNERABLE PATTERN 1: Contributor role at subscription scope
resource vulnerableSubContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, spObjectId, 'contributor-assignment')
  scope: subscription()
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
    principalId: spObjectId
    principalType: 'ServicePrincipal'
  }
}

// VULNERABLE PATTERN 2: Owner role at subscription scope
resource vulnerableSubOwner 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, userObjectId, 'owner-assignment')
  scope: subscription()
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635') // Owner
    principalId: userObjectId
    principalType: 'User'
  }
}

// VULNERABLE PATTERN 3: Contributor role at resource group scope
resource vulnerableRgContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, spObjectId, 'rg-contributor')
  scope: resourceGroup()
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
    principalId: spObjectId
    principalType: 'ServicePrincipal'
  }
}

// VULNERABLE PATTERN 4: User Access Administrator role at resource group scope
resource vulnerableRgUserAccessAdmin 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userObjectId, 'rg-user-access-admin')
  scope: resourceGroup()
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9') // User Access Administrator
    principalId: userObjectId
    principalType: 'User'
  }
}

// SECURE PATTERN 1: Least privilege role at resource scope
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: 'securestorage${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: { name: 'Standard_LRS' }
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

resource secureStorageRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccount.id, spObjectId, 'storage-blob-reader')
  scope: storageAccount
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe') // Storage Blob Data Reader
    principalId: spObjectId
    principalType: 'ServicePrincipal'
  }
}

// SECURE PATTERN 2: Using parameter-restricted role at resource scope
resource anotherStorageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: 'securestorage2${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: { name: 'Standard_LRS' }
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

resource secureParameterizedRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(anotherStorageAccount.id, spObjectId, 'parameterized-role')
  scope: anotherStorageAccount
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', restrictedRoleDefinitionId)
    principalId: spObjectId
    principalType: 'ServicePrincipal'
  }
}

// SECURE PATTERN 3: Less privileged built-in role at subscription scope (acceptable for monitoring)
resource secureMonitoringRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, spObjectId, 'monitoring-reader')
  scope: subscription()
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05') // Monitoring Reader
    principalId: spObjectId
    principalType: 'ServicePrincipal'
  }
}

// SECURE PATTERN 4: Custom role with limited permissions at resource group scope
resource customRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(resourceGroup().id, 'custom-limited-role')
  scope: resourceGroup()
  properties: {
    roleName: 'Custom Limited Role'
    description: 'Custom role with limited permissions'
    permissions: [
      {
        actions: [
          'Microsoft.Resources/subscriptions/resourceGroups/read'
          'Microsoft.Storage/storageAccounts/read'
        ]
        notActions: []
      }
    ]
    assignableScopes: [
      resourceGroup().id
    ]
  }
}

resource secureCustomRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, spObjectId, 'custom-role-assignment')
  scope: resourceGroup()
  properties: {
    roleDefinitionId: customRole.id
    principalId: spObjectId
    principalType: 'ServicePrincipal'
  }
}