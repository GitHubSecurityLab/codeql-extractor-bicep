// This file contains test cases for Redis Cache memory policy issues

// GOOD: Redis Cache with safe memory policy (noeviction)
resource safeMemoryPolicyRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'safe-memory-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      'maxmemory-policy': 'noeviction' // Safe: returns errors instead of deleting data
    }
  }
}

// BAD: Redis Cache with unsafe memory policy (allkeys-lru)
resource unsafeMemoryPolicy1RedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'unsafe-memory-1-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      'maxmemory-policy': 'allkeys-lru' // Unsafe: can delete any keys
    }
  }
}

// BAD: Redis Cache with unsafe memory policy (allkeys-random)
resource unsafeMemoryPolicy2RedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'unsafe-memory-2-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      'maxmemory-policy': 'allkeys-random' // Unsafe: can delete random keys
    }
  }
}

// BAD: Redis Cache with unsafe memory policy (volatile-lru)
resource unsafeMemoryPolicy3RedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'unsafe-memory-3-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      'maxmemory-policy': 'volatile-lru' // Unsafe: can delete keys with TTL
    }
  }
}

// BAD: Redis Cache with unsafe memory policy (volatile-random)
resource unsafeMemoryPolicy4RedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'unsafe-memory-4-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      'maxmemory-policy': 'volatile-random' // Unsafe: can delete random keys with TTL
    }
  }
}

// BAD: Redis Cache with unsafe memory policy (volatile-ttl)
resource unsafeMemoryPolicy5RedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'unsafe-memory-5-redis'
  location: 'westus'
  properties: {
    redisConfiguration: {
      'maxmemory-policy': 'volatile-ttl' // Unsafe: can delete keys with shortest TTL
    }
  }
}
