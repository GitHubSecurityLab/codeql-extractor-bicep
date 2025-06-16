// Test file for GrafanaExcessiveEditorPermissions.ql
// Contains examples of secure and insecure configurations

// TEST CASE: Insecure - Grafana with excessive editor permissions
// This should be detected by the query
resource insecureGrafanaEditors 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'insecure-grafana-editors'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        editorsCanAdmin: true  // ALERT: Excessive permissions for editors
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with proper editor permissions (explicitly set to false)
// This should NOT be detected by the query
resource secureGrafanaEditors 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-editors'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        editorsCanAdmin: false  // Secure: Editors cannot administrate
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with default editor permissions (property omitted)
// This should NOT be detected by the query (assuming default is false)
resource defaultGrafanaEditors 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'default-grafana-editors'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        // editorsCanAdmin property is omitted, should default to false
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Complex - Grafana with both viewer and editor permission settings
// The editorsCanAdmin=true should be detected by the query
resource complexGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'complex-grafana-permissions'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        editorsCanAdmin: true   // ALERT: Excessive permissions for editors
        viewersCanEdit: false   // This is secure, but the resource should still be flagged
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}
