// This file contains test cases for Redis Cache AAD authentication issues

// GOOD: Redis Cache with AAD authentication enabled
resource aadRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'aad-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      'aad-enabled': 'true' // AAD authentication enabled (secure)
    }
  }
}

// BAD: Redis Cache without AAD authentication
resource noAadRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'no-aad-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      // No 'aad-enabled' property - using access keys only
    }
  }
}

// BAD: Redis Cache with AAD authentication explicitly disabled
resource disabledAadRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'disabled-aad-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      'aad-enabled': 'false' // AAD authentication explicitly disabled
    }
  }
}
