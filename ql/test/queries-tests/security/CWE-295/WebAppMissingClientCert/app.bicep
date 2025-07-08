// This is a test file for the WebAppMissingClientCert query
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

// Insecure: Web App with HTTPS-Only but no client cert configuration
// This should be flagged by the query
resource insecureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'insecure-webapp-no-clientcert'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true // HTTPS is enabled but no client cert
    // No client cert configuration
  }
}

// Insecure: Web App with HTTPS-Only and client cert enabled but not required
// This should be flagged by the query
resource partiallySecureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'partially-secure-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    clientCertEnabled: true
    httpsOnly: true
    // clientCertMode not set to Required
  }
}

// Insecure: Web App with explicit non-Required client cert mode
// This should be flagged by the query
resource explicitlyOptionalWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'explicitly-optional-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    clientCertEnabled: true
    clientCertMode: 'Optional' // Explicitly not required
    httpsOnly: true
  }
}

// Secure: Web App with HTTPS-Only and required client cert
// This should NOT be flagged by the query
resource secureWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'secure-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    clientCertEnabled: true
    clientCertMode: 'Required' // Client cert is required
    httpsOnly: true
  }
}

// Web App without HTTPS-Only
// This should NOT be flagged by the query (since we only check apps with HTTPS enabled)
resource httpWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'http-webapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    // No client cert configuration
  }
  // No httpsOnly setting
}
