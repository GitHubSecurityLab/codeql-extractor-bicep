# Redis Cache with non-SSL port enabled

Redis Cache instances with non-SSL port enabled allow unencrypted communication, which may expose sensitive data in transit. This security vulnerability falls under [CWE-319: Cleartext Transmission of Sensitive Information](https://cwe.mitre.org/data/definitions/319.html).

## Problem Description

When a Redis Cache resource is configured with `enableNonSslPort` set to `true`, clients can connect to the cache without TLS encryption. This presents several security risks:

1. Data transmitted between client applications and the Redis Cache can be intercepted by network attackers
2. Sensitive information like cache keys and values may be exposed
3. The cache becomes vulnerable to man-in-the-middle attacks

## Recommendation

Always disable the non-SSL port by setting `enableNonSslPort` to `false` (or omitting the property to use the default value of `false`). This ensures that all client connections to the Redis Cache use TLS encryption.

## Example

### Insecure configuration (non-SSL port enabled):

```bicep
resource insecureRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'insecure-redis'
  location: location
  properties: {
    enableNonSslPort: true // Insecure: Allows unencrypted connections
    // other configuration
  }
}
```

### Secure configuration (non-SSL port disabled):

```bicep
resource secureRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'secure-redis'
  location: location
  properties: {
    enableNonSslPort: false // Secure: Only allows SSL/TLS encrypted connections
    // other configuration
  }
}
```

## References

* [Azure Cache for Redis documentation - Configure SSL port](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-configure#ssl-port)
* [Microsoft security best practices for Azure Cache for Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/security-baseline)
