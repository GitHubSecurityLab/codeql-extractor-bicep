// This is a test file for the WebAppPublicNetworkAccess query
// It contains examples of secure and insecure configurations

param location string = resourceGroup().location

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'app-plan-test'
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
}

// VNet resource
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'test-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'app-subnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
        }
      }
    ]
  }
}

// Insecure: Web App with default public network access (enabled) and no VNet integration
resource insecureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'insecure-public-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    // No public network access restrictions
    // No VNet integration
  }
}

// Insecure: Web App with explicitly enabled public network access and no VNet integration
resource explicitlyInsecureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'explicitly-insecure-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    publicNetworkAccess: 'Enabled' // Explicitly allowing public access
    // No VNet integration
  }
}

// Secure: Web App with VNet integration
resource secureWithVNetWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'secure-vnet-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    // Public network access not explicitly disabled, but has VNet integration
    virtualNetworkSubnetId: '${vnet.id}/subnets/app-subnet'
  }
}

// Secure: Web App with disabled public network access
resource secureNoPublicWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'secure-no-public-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    publicNetworkAccess: 'Disabled' // Explicitly disabling public access
  }
}

// Secure: Web App with VNet integration at the properties level
resource secureWithPropsVNetWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'secure-props-vnet-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: '${vnet.id}/subnets/app-subnet'
  }
}
