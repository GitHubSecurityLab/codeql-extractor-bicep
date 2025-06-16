// Test file for GrafanaApiKeyEnabled.ql
// Contains examples of secure and insecure configurations

// TEST CASE: Insecure - Grafana with API key feature enabled
// This should be detected by the query
resource insecureGrafanaApiKey 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'insecure-grafana-apikey'
  location: 'eastus'
  properties: {
    apiKey: 'Enabled'  // ALERT: API key feature is enabled
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with API key feature disabled
// This should NOT be detected by the query
resource secureGrafanaApiKey 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-apikey'
  location: 'westeurope'
  properties: {
    apiKey: 'Disabled'  // Secure: API key feature is disabled
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana without explicit API key setting
// This should NOT be detected by the query (assuming default is secure)
resource defaultGrafanaApiKey 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'default-grafana-apikey'
  location: 'centralus'
  properties: {
    // No explicit API key setting
  }
  sku: {
    name: 'Standard'
  }
}
