// This file contains test cases for Redis Cache authentication issues

// GOOD: Redis Cache with authentication enabled (default)
resource secureAuthRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'secure-auth-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      // No authnotrequired property means authentication is required (secure)
    }
  }
}

// GOOD: Redis Cache with authentication explicitly enabled
resource explicitAuthRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'explicit-auth-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      'authnotrequired': 'false' // Authentication explicitly required (secure)
    }
  }
}

// BAD: Redis Cache with authentication disabled
resource noAuthRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'noauth-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      'authnotrequired': 'true' // Authentication disabled (very insecure)
    }
  }
}
