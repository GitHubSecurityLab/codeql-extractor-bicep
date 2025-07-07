param location string = resourceGroup().location
param appServicePlanName string = 'myAppServicePlan'
param appServiceName string = 'myAppService'
param staticSiteName string = 'myStaticSite'

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  properties: {
    reserved: true // For Linux
    computeMode: 'Dedicated'
    workerSize: 'Small'
    workerSizeId: 1
    numberOfWorkers: 2
    perSiteScaling: false
    elasticScaleEnabled: true
    zoneRedundant: true
    maximumElasticWorkerCount: 10
  }
}

// App Service with insecure configuration (for testing queries)
resource insecureAppService 'Microsoft.Web/sites@2022-09-01' = {
  name: '${appServiceName}-insecure'
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: false // Insecure setting
    publicNetworkAccess: 'Enabled'
    clientCertEnabled: false
    siteConfig: {
      minTlsVersion: '1.0' // Weak TLS
      remoteDebuggingEnabled: true // Insecure
      ftpsState: 'AllAllowed'
      http20Enabled: false
      alwaysOn: true
    }
  }
}

// App Service with secure configuration
resource secureAppService 'Microsoft.Web/sites@2022-09-01' = {
  name: '${appServiceName}-secure'
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    publicNetworkAccess: 'Disabled'
    clientCertEnabled: true
    clientCertMode: 'Required'
    siteConfig: {
      minTlsVersion: '1.2'
      remoteDebuggingEnabled: false
      ftpsState: 'Disabled'
      http20Enabled: true
      alwaysOn: true
    }
    virtualNetworkSubnetId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet'
  }
}

// Deployment slot for testing
resource testSlot 'Microsoft.Web/sites/slots@2022-09-01' = {
  name: '${secureAppService.name}/staging'
  location: location
  kind: 'app'
  properties: {
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      alwaysOn: true
    }
  }
}

// Static Web App
resource staticSite 'Microsoft.Web/staticSites@2022-09-01' = {
  name: staticSiteName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    repositoryUrl: 'https://github.com/example/repo'
    repositoryToken: 'your-token-here'
    allowConfigFileUpdates: true
    allowPrivateEndpoints: false
  }
}

// Function App (another kind of site)
resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: '${appServiceName}-function'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      alwaysOn: true
    }
  }
}
