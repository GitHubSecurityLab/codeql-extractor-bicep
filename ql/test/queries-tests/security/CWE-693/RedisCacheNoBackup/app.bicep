// This file contains test cases for Redis Cache backup configuration issues

// GOOD: Redis Cache with RDB backup enabled
resource rdbBackupRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'rdb-backup-redis'
  location: 'westus'
  properties: {
    sku: {
      name: 'Premium' // Premium SKU required for backups
      family: 'P'
      capacity: 1
    }
    redisConfiguration: {
      'rdb-backup-enabled': 'true'
      'rdb-backup-frequency': '60'
      'rdb-storage-connection-string': 'DefaultEndpointsProtocol=https;AccountName=testaccount;AccountKey=${storageKey}'
    }
  }
}

// GOOD: Redis Cache with AOF backup enabled
resource aofBackupRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'aof-backup-redis'
  location: 'westus'
  properties: {
    sku: {
      name: 'Premium' // Premium SKU required for backups
      family: 'P'
      capacity: 1
    }
    redisConfiguration: {
      'aof-backup-enabled': 'true'
      'aof-storage-connection-string-0': 'DefaultEndpointsProtocol=https;AccountName=testaccount;AccountKey=${storageKey}'
    }
  }
}

// GOOD: Redis Cache with both backup types enabled
resource bothBackupRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'both-backup-redis'
  location: 'westus'
  properties: {
    sku: {
      name: 'Premium' // Premium SKU required for backups
      family: 'P'
      capacity: 1
    }
    redisConfiguration: {
      'rdb-backup-enabled': 'true'
      'rdb-backup-frequency': '60'
      'rdb-storage-connection-string': 'DefaultEndpointsProtocol=https;AccountName=testaccount;AccountKey=${storageKey}'
      'aof-backup-enabled': 'true'
      'aof-storage-connection-string-0': 'DefaultEndpointsProtocol=https;AccountName=testaccount;AccountKey=${storageKey}'
    }
  }
}

// BAD: Redis Cache without any backup enabled (Premium tier)
resource noBackupRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'nobackup-redis'
  location: 'westus'
  properties: {
    sku: {
      name: 'Premium'
      family: 'P'
      capacity: 1
    }
    // No backup configuration
  }
}

// BAD: Redis Cache with explicitly disabled backups
resource disabledBackupRedisCache 'Microsoft.Cache/Redis@2020-06-01' = {
  name: 'disabled-backup-redis'
  location: 'westus'
  properties: {
    sku: {
      name: 'Premium'
      family: 'P'
      capacity: 1
    }
    redisConfiguration: {
      'rdb-backup-enabled': 'false'
      'aof-backup-enabled': 'false'
    }
  }
}
