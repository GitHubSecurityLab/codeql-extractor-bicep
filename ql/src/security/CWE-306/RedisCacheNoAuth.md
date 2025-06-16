# Redis Cache with authentication disabled

Redis Cache instances configured with authentication disabled allow anyone with network access to connect to the cache and perform operations without credentials. This serious security vulnerability falls under [CWE-306: Missing Authentication for Critical Function](https://cwe.mitre.org/data/definitions/306.html).

## Problem Description

When the `authnotrequired` property in the Redis configuration is set to `true`, the Redis cache does not require authentication. This critical security flaw:

1. Allows any client with network access to connect without credentials
2. Exposes all data stored in the cache to unauthorized access
3. Enables attackers to modify or delete cache data
4. Significantly increases the risk of data breach or service disruption

This issue is especially dangerous when combined with public network access.

## Recommendation

Always enable authentication for Redis Cache by ensuring the `authnotrequired` property is not set to `true` in the Redis configuration. The default setting requires authentication, which is the secure configuration.

When authentication is enabled, use strong, unique access keys and follow the principle of least privilege when distributing these keys.

## Example

### Insecure configuration (authentication disabled):

```bicep
resource insecureRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'insecure-redis'
  location: location
  properties: {
    redisConfiguration: {
      'authnotrequired': 'true' // Insecure: No authentication required
    }
    // other configuration
  }
}
```

### Secure configuration (authentication enabled):

```bicep
resource secureRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'secure-redis'
  location: location
  properties: {
    // No 'authnotrequired' property, or explicitly set to 'false'
    redisConfiguration: {
      'authnotrequired': 'false' // Secure: Authentication required
    }
    // other configuration
  }
}
```

## References

* [Redis AUTH command and security](https://redis.io/docs/manual/security/)
* [Azure Cache for Redis security](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview#security)
* [Azure Cache for Redis best practices](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-best-practices)
