
// Secure
resource db 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'securetlsdb'
  location: 'eastus'
  properties: {
    sslEnforcement: 'Enabled'   // GOOD: Enforced
  }
}

// Bad
resource db 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'publicdbserver'
  location: 'eastus'
  properties: {
    version: '12.0'
    publicNetworkAccess: 'Enabled' // BAD: Database is publicly accessible
    minimalTlsVersion: '1.0' // BAD: Weak TLS version
    sslEnforcement: 'Disabled' // BAD: SSL enforcement is disabled
  }
}
