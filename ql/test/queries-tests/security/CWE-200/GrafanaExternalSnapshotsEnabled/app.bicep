// Test file for GrafanaExternalSnapshotsEnabled.ql
// Contains examples of secure and insecure configurations

// TEST CASE: Insecure - Grafana with external snapshots enabled
// This should be detected by the query
resource insecureGrafanaSnapshots 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'insecure-grafana-snapshots'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      snapshots: {
        externalEnabled: true  // ALERT: External snapshots are enabled
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with external snapshots disabled
// This should NOT be detected by the query
resource secureGrafanaSnapshots 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-snapshots'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      snapshots: {
        externalEnabled: false  // Secure: External snapshots are disabled
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with default snapshot settings (property omitted)
// This should NOT be detected by the query (assuming default is false)
resource defaultGrafanaSnapshots 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'default-grafana-snapshots'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      // snapshots property omitted
    }
  }
  sku: {
    name: 'Standard'
  }
}
