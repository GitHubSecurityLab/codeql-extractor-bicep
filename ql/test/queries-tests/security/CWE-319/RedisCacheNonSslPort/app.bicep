// This file contains test cases for Redis Cache non-SSL port issues

// GOOD: Redis Cache with SSL-only access
resource secureRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'secure-redis'
  location: 'westus'
  properties: {
    enableNonSslPort: false // SSL-only (secure)
    minimumTlsVersion: '1.2'
  }
}

// BAD: Redis Cache with non-SSL port enabled
resource insecureRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'insecure-redis'
  location: 'westus'
  properties: {
    enableNonSslPort: true // Allows unencrypted connections (insecure)
  }
}

// BAD: Redis Cache with default non-SSL port enabled explicitly
resource explicitDefaultRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'explicit-default-redis'
  location: 'westus'
  properties: {
    enableNonSslPort: true // Explicitly enabled (insecure)
  }
}
