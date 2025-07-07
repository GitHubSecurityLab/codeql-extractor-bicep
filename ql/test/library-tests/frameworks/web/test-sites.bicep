// This is a test file for Microsoft.Web/sites resources

param location string = 'eastus'
param appServicePlanName string = 'test-asp'
param webAppName string = 'test-webapp'
param functionAppName string = 'test-function-app'

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
}

// Web App (App Service)
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    clientCertEnabled: true
    clientCertMode: 'Required'
    virtualNetworkSubnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.Network/virtualNetworks/MyVnet/subnets/MySubnet'
    siteConfig: {
      alwaysOn: true
      http20Enabled: true
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      ipSecurityRestrictions: [
        {
          ipAddress: '192.168.1.0/24'
          action: 'Allow'
          priority: 100
          name: 'Allow internal network'
        }
        {
          ipAddress: '10.0.0.0/16'
          action: 'Deny'
          priority: 200
          name: 'Block private network'
        }
      ]
      ipSecurityRestrictionsDefaultAction: 'Deny'
      appSettings: [
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~16'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: '00000000-0000-0000-0000-000000000000'
        }
      ]
      connectionStrings: [
        {
          name: 'MyDbConnection'
          connectionString: 'Data Source=myserver;Initial Catalog=mydb;User ID=myuser;Password=mypassword;'
          type: 'SQLAzure'
        }
      ]
      linuxFxVersion: 'NODE|16-lts'
    }
  }
}

// Function App
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned,UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity': {}
    }
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      use32BitWorkerProcess: false
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=mystorageaccount;EndpointSuffix=core.windows.net;AccountKey=mykey=='
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
      ]
    }
  }
}
