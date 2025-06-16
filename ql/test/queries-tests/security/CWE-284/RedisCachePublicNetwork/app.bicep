// This file contains test cases for Redis Cache public network access issues

// GOOD: Redis Cache with private network access only
resource privateRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'private-redis'
  location: 'westus'
  properties: {
    publicNetworkAccess: 'Disabled' // Private access only (secure)
  }
}

// BAD: Redis Cache with public network access enabled
resource publicRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'public-redis'
  location: 'westus'
  properties: {
    publicNetworkAccess: 'Enabled' // Exposes to the internet (insecure)
  }
}

// BAD: Redis Cache with default public network access (implicitly enabled)
resource defaultPublicRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'default-public-redis'
  location: 'westus'
  properties: {
    // publicNetworkAccess defaults to 'Enabled' if not specified
  }
}
