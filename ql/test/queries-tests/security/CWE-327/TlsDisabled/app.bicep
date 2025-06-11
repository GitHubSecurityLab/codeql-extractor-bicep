// Bicep sample with TLS disabled for testing
// Case 1: enableNonSslPort not set (should be secure)
resource redis1 'Microsoft.Cache/Redis@2021-06-01' = {
  name: 'redis1'
  location: 'eastus'
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

// Case 2: enableNonSslPort enabled (TLS disabled, should trigger)
resource redis2 'Microsoft.Cache/Redis@2021-06-01' = {
  name: 'redis2'
  location: 'eastus'
  properties: {
    enableNonSslPort: true
    publicNetworkAccess: 'Enabled'
  }
}

// Case 3: enableNonSslPort disabled (TLS enforced, should be secure)
resource redis3 'Microsoft.Cache/Redis@2021-06-01' = {
  name: 'redis3'
  location: 'eastus'
  properties: {
    enableNonSslPort: false
    publicNetworkAccess: 'Enabled'
  }
}
