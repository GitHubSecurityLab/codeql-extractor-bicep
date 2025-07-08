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
  }
  // Missing httpsOnly property or set to false
}

// Insecure: Web App with HTTPS Only explicitly set to false
resource explicitlyInsecureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'explicitly-insecure-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
  httpsOnly: false  // Explicitly insecure: allows HTTP
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
  }
  httpsOnly: true  // Secure: enforces HTTPS
}

// Secure: Web App with HTTPS Only, client certs, and VNet integration
resource highlySecureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'highly-secure-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: '/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Network/virtualNetworks/{vnet}/subnets/{subnet}'
    clientCertEnabled: true
    clientCertMode: 'Required'
    publicNetworkAccess: 'Disabled'
    siteConfig: {
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      remoteDebuggingEnabled: false
      alwaysOn: true
    }
  }
  httpsOnly: true
}

// Insecure: Web App with remote debugging enabled
resource debuggableWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'debuggable-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      remoteDebuggingEnabled: true  // Insecure: enables remote debugging
      remoteDebuggingVersion: 'VS2019'
    }
  }
  httpsOnly: true
}
