# Redis Cache without data backup

Redis Cache instances without backup configuration risk data loss in case of failures or disasters. This issue falls under [CWE-693: Protection Mechanism Failure](https://cwe.mitre.org/data/definitions/693.html), as it represents a failure to protect critical data.

## Problem Description

Azure Cache for Redis offers two types of persistence options:

1. RDB (Redis Database) snapshots - periodic full backups
2. AOF (Append Only File) persistence - continuous logging of write operations

When neither backup method is enabled, the Redis cache becomes vulnerable to data loss from:

- Service outages or crashes
- Accidental data deletion
- Scaling operations
- Service updates or maintenance
- Underlying infrastructure failures

## Recommendation

Enable at least one of the backup methods for Redis Cache:

- **For critical data with low tolerance for data loss**: Enable AOF persistence by setting `aof-backup-enabled` to `true` in the Redis configuration
- **For less critical workloads**: Enable RDB snapshots by setting `rdb-backup-enabled` to `true` in the Redis configuration

For maximum protection, consider enabling both backup methods. Additionally, ensure that proper storage connection strings are provided for the backups.

## Example

### Insecure configuration (no backups enabled):

```bicep
resource redisWithoutBackup 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'redis-no-backup'
  location: location
  properties: {
    sku: {
      name: 'Premium'
      family: 'P'
      capacity: 1
    }
    // No backup configuration provided
  }
}
```

### Secure configuration (RDB backups enabled):

```bicep
resource redisWithRdbBackup 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'redis-with-backup'
  location: location
  properties: {
    sku: {
      name: 'Premium'
      family: 'P'
      capacity: 1
    }
    redisConfiguration: {
      'rdb-backup-enabled': 'true'
      'rdb-backup-frequency': '60'
      'rdb-storage-connection-string': storageAccountConnectionString
    }
  }
}
```

### Alternative secure configuration (AOF backups enabled):

```bicep
resource redisWithAofBackup 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'redis-with-backup'
  location: location
  properties: {
    sku: {
      name: 'Premium'
      family: 'P'
      capacity: 1
    }
    redisConfiguration: {
      'aof-backup-enabled': 'true'
      'aof-storage-connection-string-0': storageAccountConnectionString
    }
  }
}
```

## References

* [Data persistence with Azure Cache for Redis](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-premium-persistence)
* [Disaster recovery and high availability for Azure Cache for Redis](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-disaster-recovery-guidance)
* [Redis persistence documentation](https://redis.io/docs/management/persistence/)
