// Test file for GrafanaMissingZoneRedundancy.ql
// Contains examples of secure and insecure configurations

// TEST CASE: Insecure - Grafana with zone redundancy explicitly disabled
// This should be detected by the query
resource insecureGrafanaNoZoneRedundancy1 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'insecure-grafana-no-zone-redundancy-1'
  location: 'eastus'
  properties: {
    zoneRedundancy: 'Disabled'  // ALERT: Zone redundancy explicitly disabled
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Insecure - Grafana without zone redundancy setting
// This should be detected by the query (missing setting)
resource insecureGrafanaNoZoneRedundancy2 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'insecure-grafana-no-zone-redundancy-2'
  location: 'westeurope'
  properties: {
    // No zone redundancy setting
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with zone redundancy enabled
// This should NOT be detected by the query
resource secureGrafanaZoneRedundancy 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-zone-redundancy'
  location: 'centralus'
  properties: {
    zoneRedundancy: 'Enabled'  // Secure: Zone redundancy is enabled
  }
  sku: {
    name: 'Standard'
  }
}
