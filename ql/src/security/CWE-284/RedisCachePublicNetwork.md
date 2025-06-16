# Redis Cache with public network access enabled

Redis Cache instances with public network access enabled are directly exposed to the internet, creating a potential attack surface for malicious actors. This security issue falls under [CWE-284: Improper Access Control](https://cwe.mitre.org/data/definitions/284.html).

## Problem Description

When an Azure Cache for Redis resource has the `publicNetworkAccess` property set to `Enabled`, the cache can be accessed from any public IP address, subject only to authentication controls. This configuration:

1. Increases the attack surface of your Redis cache
2. Leaves the cache vulnerable to brute force attacks
3. May violate security compliance requirements for sensitive environments
4. Increases the risk of data exfiltration if other security controls fail

## Recommendation

Unless specifically required by application architecture, Redis Cache resources should have public network access disabled by setting `publicNetworkAccess` to `Disabled`. Instead, use:

- Private endpoints and Azure Private Link to access your cache over a private IP address
- Virtual network service endpoints to limit access to specific virtual networks
- Firewall rules to restrict access to specific IP ranges when public access is necessary

## Example

### Insecure configuration (public network access enabled):

```bicep
resource insecureRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'insecure-redis'
  location: location
  properties: {
    publicNetworkAccess: 'Enabled' // Insecure: Exposes cache to the internet
    // other configuration
  }
}
```

### Secure configuration (public network access disabled with private endpoint):

```bicep
resource secureRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'secure-redis'
  location: location
  properties: {
    publicNetworkAccess: 'Disabled' // Secure: No public internet access
    // other configuration
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: 'redis-private-endpoint'
  location: location
  properties: {
    subnet: {
      id: subnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'redis-private-link'
        properties: {
          privateLinkServiceId: secureRedisCache.id
          groupIds: [
            'redisCache'
          ]
        }
      }
    ]
  }
}
```

## References

* [Azure Cache for Redis with Azure Private Link](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-private-link)
* [Configure virtual network support for Azure Cache for Redis](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-premium-vnet)
* [Azure Security Baseline for Azure Cache for Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/security-baseline)
