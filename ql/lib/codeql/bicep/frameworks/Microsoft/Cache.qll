private import bicep
private import codeql.bicep.Concepts

module Cache {
  abstract class CacheResource extends Resource { }

  /**
   * Represents an Azure Cache for Redis resource.
   */
  class RedisCacheResource extends CacheResource, Resource {
    /**
     * Constructs a RedisCacheResource for Microsoft.Cache/Redis resources.
     */
    RedisCacheResource() { this.getResourceType().regexpMatch("^Microsoft.Cache/Redis@.*") }

    /**
     * Returns the properties object for the Redis cache resource.
     */
    CacheProperties::Properties getProperties() { result = this.getProperty("properties") }

    CacheProperties::RedisConfiguration getRedisConfiguration() {
      result = this.getProperties().getProperty("redisConfiguration")
    }

    /**
     * Returns the SKU of the Redis cache.
     */
    Sku getSku() { result = this.getProperty("sku") }

    /**
     * Returns the Redis version.
     */
    string redisVersion() {
      result = this.getProperties().getProperty("redisVersion").(StringLiteral).getValue()
    }

    /**
     * Returns true if non-SSL port is enabled.
     */
    boolean enableNonSslPort() {
      result = this.getProperties().getProperty("enableNonSslPort").(Boolean).getBool()
    }

    /**
     * Returns the publicNetworkAccess property, if present.
     */
    string publicNetworkAccess() {
      result = this.getProperties().getProperty("publicNetworkAccess").(StringLiteral).getValue()
    }

    /**
     * Returns a string representation of the Redis cache resource.
     */
    override string toString() { result = "RedisCacheResource" }
  }

  /**
   * Represents a public Azure Cache for Redis resource (public network access enabled).
   */
  class PublicRedisCacheResource extends PublicResource {
    private RedisCacheResource redisCache;

    /**
     * Constructs a PublicRedisCacheResource if the Redis cache has public network access enabled.
     */
    PublicRedisCacheResource() {
      redisCache.publicNetworkAccess() = "Enabled" and
      this = redisCache
    }

    /**
     * Returns the property that indicates public access for the Redis cache resource.
     */
    override Expr getPublicAccessProperty() {
      result = redisCache.getProperties().getProperty("publicNetworkAccess")
    }
  }

  module CacheProperties {
    /**
     * Represents the properties object for a Redis cache resource.
     */
    class Properties extends Object {
      private RedisCacheResource redisCache;

      /**
       * Constructs a Properties object for the given Redis cache resource.
       */
      Properties() { this = redisCache.getProperty("properties") }

      /**
       * Returns the parent RedisCacheResource.
       */
      RedisCacheResource getRedisCacheResource() { result = redisCache }

      string toString() { result = "CacheProperties" }
    }

    // redisConfiguration: {
    //   aad-enabled: 'string'
    //   aof-backup-enabled: 'string'
    //   aof-storage-connection-string-0: 'string'
    //   aof-storage-connection-string-1: 'string'
    //   authnotrequired: 'string'
    //   maxfragmentationmemory-reserved: 'string'
    //   maxmemory-delta: 'string'
    //   maxmemory-policy: 'string'
    //   maxmemory-reserved: 'string'
    //   notify-keyspace-events: 'string'
    //   preferred-data-persistence-auth-method: 'string'
    //   rdb-backup-enabled: 'string'
    //   rdb-backup-frequency: 'string'
    //   rdb-backup-max-snapshot-count: 'string'
    //   rdb-storage-connection-string: 'string'
    //   storage-subscription-id: 'string'
    // }
    class RedisConfiguration extends Object {
      private Properties properties;

      /**
       * Constructs a RedisConfiguration object for the given properties.
       */
      RedisConfiguration() { this = properties.getProperty("redisConfiguration") }

      /**
       * Returns the 'aad-enabled' property as a StringLiteral, if present.
       */
      StringLiteral getAadEnabled() { result = this.getProperty("aad-enabled") }

      /** Returns the 'aad-enabled' property as a string, if present. */
      string aadEnabled() { result = this.getAadEnabled().getValue() }

      /**
       * Returns the 'aof-backup-enabled' property as a StringLiteral, if present.
       */
      StringLiteral getAofBackupEnabled() { result = this.getProperty("aof-backup-enabled") }

      string aofBackupEnabled() { result = this.getAofBackupEnabled().getValue() }

      StringLiteral getAofStorageConnectionString0() {
        result = this.getProperty("aof-storage-connection-string-0")
      }

      string aofStorageConnectionString0() {
        result = this.getAofStorageConnectionString0().getValue()
      }

      StringLiteral getAofStorageConnectionString1() {
        result = this.getProperty("aof-storage-connection-string-1")
      }

      string aofStorageConnectionString1() {
        result = this.getAofStorageConnectionString1().getValue()
      }

      StringLiteral getAuthNotRequired() { result = this.getProperty("authnotrequired") }

      string authNotRequired() { result = this.getAuthNotRequired().getValue() }

      StringLiteral getMaxFragmentationMemoryReserved() {
        result = this.getProperty("maxfragmentationmemory-reserved")
      }

      string maxFragmentationMemoryReserved() {
        result = this.getMaxFragmentationMemoryReserved().getValue()
      }

      StringLiteral getMaxMemoryDelta() { result = this.getProperty("maxmemory-delta") }

      string maxMemoryDelta() { result = this.getMaxMemoryDelta().getValue() }

      StringLiteral getMaxMemoryPolicy() { result = this.getProperty("maxmemory-policy") }

      string maxMemoryPolicy() { result = this.getMaxMemoryPolicy().getValue() }

      StringLiteral getMaxMemoryReserved() { result = this.getProperty("maxmemory-reserved") }

      string maxMemoryReserved() { result = this.getMaxMemoryReserved().getValue() }

      StringLiteral getNotifyKeyspaceEvents() {
        result = this.getProperty("notify-keyspace-events")
      }

      string notifyKeyspaceEvents() { result = this.getNotifyKeyspaceEvents().getValue() }

      StringLiteral getPreferredDataPersistenceAuthMethod() {
        result = this.getProperty("preferred-data-persistence-auth-method")
      }

      string preferredDataPersistenceAuthMethod() {
        result = this.getPreferredDataPersistenceAuthMethod().getValue()
      }

      StringLiteral getRdbBackupEnabled() { result = this.getProperty("rdb-backup-enabled") }

      string rdbBackupEnabled() { result = this.getRdbBackupEnabled().getValue() }

      StringLiteral getRdbBackupFrequency() { result = this.getProperty("rdb-backup-frequency") }

      string rdbBackupFrequency() { result = this.getRdbBackupFrequency().getValue() }

      StringLiteral getRdbBackupMaxSnapshotCount() {
        result = this.getProperty("rdb-backup-max-snapshot-count")
      }

      string rdbBackupMaxSnapshotCount() { result = this.getRdbBackupMaxSnapshotCount().getValue() }

      StringLiteral getRdbStorageConnectionString() {
        result = this.getProperty("rdb-storage-connection-string")
      }

      string rdbStorageConnectionString() {
        result = this.getRdbStorageConnectionString().getValue()
      }

      StringLiteral getStorageSubscriptionId() {
        result = this.getProperty("storage-subscription-id")
      }

      string storageSubscriptionId() { result = this.getStorageSubscriptionId().getValue() }

      string toString() { result = "RedisConfiguration" }
    }
  }
}
