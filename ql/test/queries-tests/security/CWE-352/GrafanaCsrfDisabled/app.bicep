// Test file for GrafanaCsrfDisabled.ql
// Contains examples of secure and insecure configurations

// TEST CASE: Insecure - Grafana with CSRF protection explicitly disabled
// This should be detected by the query
resource insecureGrafanaCsrf 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'insecure-grafana-csrf'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      security: {
        csrfAlwaysCheck: false  // ALERT: CSRF protection explicitly disabled
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with CSRF protection explicitly enabled
// This should NOT be detected by the query
resource secureGrafanaCsrf 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-csrf'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      security: {
        csrfAlwaysCheck: true  // Secure: CSRF protection always enabled
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with no explicit security configuration (defaults)
// This should NOT be detected by the query
resource defaultGrafanaCsrf 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'default-grafana-security'
  location: 'eastus'
  properties: {
    // No explicit security configuration - using Grafana defaults
    grafanaConfigurations: {
      // Security block omitted
    }
  }
  sku: {
    name: 'Standard'
  }
}
