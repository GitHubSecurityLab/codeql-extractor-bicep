# Redis Cache without AAD authentication

Redis Cache instances that don't use Azure Active Directory (AAD) authentication rely solely on access keys, which can lead to weaker security controls. This issue is related to [CWE-798: Use of Hard-coded Credentials](https://cwe.mitre.org/data/definitions/798.html), as access keys are often stored in configuration files or application code.

## Problem Description

By default, Azure Cache for Redis uses access keys for authentication. While functional, this approach has several security limitations:

1. Access keys don't provide fine-grained access control
2. Keys are often embedded in application code or configuration
3. Key rotation is manual and can be disruptive
4. No integration with central identity management
5. No support for modern authentication practices (MFA, conditional access)

## Recommendation

Enable Azure Active Directory (AAD) authentication for Redis Cache by setting the `aad-enabled` property to `true` in the Redis configuration. AAD authentication provides:

- Integration with Azure's central identity management
- Role-based access control (RBAC) for granular permissions
- Support for modern authentication features like MFA
- Auditing and monitoring capabilities
- Simplified key management

## Example

### Basic configuration (access key authentication only):

```bicep
resource redisWithoutAAD 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'redis-without-aad'
  location: location
  properties: {
    // No AAD authentication configured, relies on access keys only
  }
}
```

### Improved security configuration (AAD authentication enabled):

```bicep
resource redisWithAAD 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'redis-with-aad'
  location: location
  properties: {
    redisConfiguration: {
      'aad-enabled': 'true'
    }
  }
}

// Role assignment for accessing the Redis cache
resource redisRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(redisWithAAD.id, principalId, 'Redis-Cache-Contributor')
  scope: redisWithAAD
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'e0f68234-74aa-48ed-b826-c38b57376e17') // Redis Cache Contributor
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
```

## References

* [Azure Cache for Redis with Azure Active Directory authentication](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-azure-active-directory-for-authentication)
* [Azure RBAC for Redis Cache](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-azure-role-based-access-control)
* [Security best practices for Azure Cache for Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/security-baseline)
