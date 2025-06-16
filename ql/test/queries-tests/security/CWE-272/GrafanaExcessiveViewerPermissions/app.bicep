// Test file for GrafanaExcessiveViewerPermissions.ql
// Contains examples of secure and insecure configurations

// TEST CASE: Insecure - Grafana with excessive viewer permissions
// This should be detected by the query
resource insecureGrafanaViewers 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'insecure-grafana-viewers'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        viewersCanEdit: true  // ALERT: Excessive permissions for viewers
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with proper viewer permissions (explicitly set to false)
// This should NOT be detected by the query
resource secureGrafanaViewers 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-viewers'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        viewersCanEdit: false  // Secure: Viewers cannot edit dashboards
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with default viewer permissions (property omitted)
// This should NOT be detected by the query (assuming default is false)
resource defaultGrafanaViewers 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'default-grafana-viewers'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        // viewersCanEdit property is omitted, should default to false
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}
