// This is a test file for the WebAppAlwaysOnDisabled query
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

// Insecure: Web App without Always On enabled (Default)
resource webAppWithoutAlwaysOn 'Microsoft.Web/sites@2022-03-01' = {
  name: 'webapp-without-alwayson'
  location: location
  kind: 'app' // Specifies it's a regular web app
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      // Always On is not explicitly set, defaults to false
    }
  }
}

// Insecure: Web App with Always On explicitly disabled
resource webAppWithAlwaysOnDisabled 'Microsoft.Web/sites@2022-03-01' = {
  name: 'webapp-with-alwayson-disabled'
  location: location
  kind: 'app' // Specifies it's a regular web app
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      alwaysOn: false // Explicitly disabled
    }
  }
}

// Secure: Web App with Always On enabled
resource webAppWithAlwaysOn 'Microsoft.Web/sites@2022-03-01' = {
  name: 'webapp-with-alwayson'
  location: location
  kind: 'app' // Specifies it's a regular web app
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      alwaysOn: true // Explicitly enabled
    }
  }
}

// Function App without Always On (should not be flagged)
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'function-app-without-alwayson'
  location: location
  kind: 'functionapp' // Specifies it's a function app
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      // Always On not set for function app is acceptable
    }
  }
}
