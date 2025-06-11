resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: 'mykeyvault'
  location: 'eastus'
  properties: {
    tenantId: '00000000-0000-0000-0000-000000000000'
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: [
      {
        tenantId: '00000000-0000-0000-0000-000000000000'
        objectId: '11111111-1111-1111-1111-111111111111'
        permissions: {
          keys: [ 'get', 'list' ]
          secrets: [ 'get' ]
          certificates: []
        }
      },
      {
        tenantId: '00000000-0000-0000-0000-000000000000'
        objectId: '22222222-2222-2222-2222-222222222222'
        permissions: {
          keys: [ 'get' ]
          secrets: [ 'get', 'set' ]
          certificates: [ 'get' ]
        }
      }
    ]
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    enablePurgeProtection: true
    publicNetworkAccess: 'Disabled' // Recommended: restrict public access
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '203.0.113.0/24'
        }
      ]
      virtualNetworkRules: [
        {
          id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myrg/providers/Microsoft.Network/virtualNetworks/myvnet/subnets/mysubnet'
        }
      ]
    }
  }
}