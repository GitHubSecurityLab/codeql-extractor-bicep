// This is a test file for the SitesWithoutHttpsOnly query
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

// Insecure: Web App without HTTPS Only
resource insecureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'insecure-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      ftpsState: 'AllAllowed'  // Insecure: allows non-secure FTP
    }
    httpsOnly: false  // Explicitly insecure: allows HTTP
  }
}

// Secure: Web App with HTTPS Only enabled
resource secureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'secure-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      ftpsState: 'FtpsOnly'  // Secure: only allows FTPS
    }
    httpsOnly: true  // Secure: enforces HTTPS
  }
}

// Insecure: Web App with missing httpsOnly property
resource missingHttpsOnlyWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'missing-httpsonly-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      ftpsState: 'AllAllowed'  // Insecure: allows non-secure FTP
    }
    // httpsOnly is not specified - defaults to false in Azure
  }
}
