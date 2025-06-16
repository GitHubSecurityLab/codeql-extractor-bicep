# Redis Cache with unsafe memory policy

Redis Cache instances configured with certain memory policies may delete data unexpectedly when memory limits are reached, potentially causing application failures and data loss. This issue is related to [CWE-400: Uncontrolled Resource Consumption](https://cwe.mitre.org/data/definitions/400.html).

## Problem Description

Redis uses memory policies (maxmemory-policy) to determine how to handle new data when memory limits are reached. Some policies automatically evict existing data, which can cause:

1. Unexpected data loss during peak loads
2. Application errors when cached data is suddenly unavailable
3. Inconsistent application behavior dependent on cache state
4. Hard-to-diagnose production issues

The following memory policies are potentially unsafe for production environments:
- `allkeys-lru` - Removes least recently used keys regardless of TTL
- `allkeys-random` - Removes random keys regardless of TTL
- `volatile-lru` - Removes least recently used keys with TTL set
- `volatile-random` - Removes random keys with TTL set
- `volatile-ttl` - Removes keys with shortest TTL

## Recommendation

For most production workloads, use the `noeviction` memory policy, which prevents key eviction and returns errors when the memory limit is reached. This provides predictable behavior and allows applications to handle memory limits gracefully.

If eviction policies are necessary, make sure your application is designed to handle potential key evictions and ensure that sufficient memory is allocated to reduce eviction frequency.

## Example

### Potentially problematic configuration (automatic eviction):

```bicep
resource redisWithEviction 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'redis-with-eviction'
  location: location
  properties: {
    redisConfiguration: {
      'maxmemory-policy': 'allkeys-lru' // Potentially unsafe: will delete keys automatically
    }
    // other configuration
  }
}
```

### Safer configuration (no eviction):

```bicep
resource redisWithNoEviction 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'redis-no-eviction'
  location: location
  properties: {
    redisConfiguration: {
      'maxmemory-policy': 'noeviction' // Safer: returns errors instead of deleting data
    }
    // other configuration
  }
}
```

## References

* [Redis memory optimization](https://redis.io/docs/management/optimization/memory-optimization/)
* [Azure Cache for Redis maxmemory-policy](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-configure#maxmemory-policy)
* [Redis Eviction Policies](https://redis.io/docs/reference/eviction/)
