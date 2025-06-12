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

  class RedisCacheTlsDisabled extends RedisCacheResource, Cryptography::TlsDisabled {
    override boolean isTlsDisabled() {
      exists(boolean tlsPortDisabled | tlsPortDisabled = this.enableNonSslPort() |
        tlsPortDisabled = true and
        result = false
        or
        tlsPortDisabled = false and
        result = true
      )
    }
  }

  module CacheProperties {
    /**
     * Represents the properties object for a Redis cache resource.
     */
    class Properties extends ResourceProperties {
      private RedisCacheResource redisCache;

      /**
       * Constructs a Properties object for the given Redis cache resource.
       */
      Properties() { this = redisCache.getProperty("properties") }

      /**
       * Returns the parent RedisCacheResource.
       */
      RedisCacheResource getRedisCacheResource() { result = redisCache }

      override string toString() { result = "CacheProperties[" + redisCache.getName() + "]" }
    }

    /**
     * Represents the redisConfiguration object for Azure Cache for Redis.
     * Provides accessors for all supported redisConfiguration properties.
     */
    class RedisConfiguration extends Object {
      private Properties properties;

      /**
       * Constructs a RedisConfiguration object for the given properties.
       */
      RedisConfiguration() { this = properties.getProperty("redisConfiguration") }

      /** Returns the 'aad-enabled' property as a StringLiteral, if present. */
      StringLiteral getAadEnabled() { result = this.getProperty("aad-enabled") }

      /** Returns the 'aad-enabled' property as a string, if present. */
      string aadEnabled() { result = this.getAadEnabled().getValue() }

      /** Returns the 'aof-backup-enabled' property as a StringLiteral, if present. */
      StringLiteral getAofBackupEnabled() { result = this.getProperty("aof-backup-enabled") }

      /** Returns the 'aof-backup-enabled' property as a string, if present. */
      string aofBackupEnabled() { result = this.getAofBackupEnabled().getValue() }

      /** Returns the 'aof-storage-connection-string-0' property as a StringLiteral, if present. */
      StringLiteral getAofStorageConnectionString0() {
        result = this.getProperty("aof-storage-connection-string-0")
      }

      /** Returns the 'aof-storage-connection-string-0' property as a string, if present. */
      string aofStorageConnectionString0() {
        result = this.getAofStorageConnectionString0().getValue()
      }

      /** Returns the 'aof-storage-connection-string-1' property as a StringLiteral, if present. */
      StringLiteral getAofStorageConnectionString1() {
        result = this.getProperty("aof-storage-connection-string-1")
      }

      /** Returns the 'aof-storage-connection-string-1' property as a string, if present. */
      string aofStorageConnectionString1() {
        result = this.getAofStorageConnectionString1().getValue()
      }

      /** Returns the 'authnotrequired' property as a StringLiteral, if present. */
      StringLiteral getAuthNotRequired() { result = this.getProperty("authnotrequired") }

      /** Returns the 'authnotrequired' property as a string, if present. */
      string authNotRequired() { result = this.getAuthNotRequired().getValue() }

      /** Returns the 'maxfragmentationmemory-reserved' property as a StringLiteral, if present. */
      StringLiteral getMaxFragmentationMemoryReserved() {
        result = this.getProperty("maxfragmentationmemory-reserved")
      }

      /** Returns the 'maxfragmentationmemory-reserved' property as a string, if present. */
      string maxFragmentationMemoryReserved() {
        result = this.getMaxFragmentationMemoryReserved().getValue()
      }

      /** Returns the 'maxmemory-delta' property as a StringLiteral, if present. */
      StringLiteral getMaxMemoryDelta() { result = this.getProperty("maxmemory-delta") }

      /** Returns the 'maxmemory-delta' property as a string, if present. */
      string maxMemoryDelta() { result = this.getMaxMemoryDelta().getValue() }

      /** Returns the 'maxmemory-policy' property as a StringLiteral, if present. */
      StringLiteral getMaxMemoryPolicy() { result = this.getProperty("maxmemory-policy") }

      /** Returns the 'maxmemory-policy' property as a string, if present. */
      string maxMemoryPolicy() { result = this.getMaxMemoryPolicy().getValue() }

      /** Returns the 'maxmemory-reserved' property as a StringLiteral, if present. */
      StringLiteral getMaxMemoryReserved() { result = this.getProperty("maxmemory-reserved") }

      /** Returns the 'maxmemory-reserved' property as a string, if present. */
      string maxMemoryReserved() { result = this.getMaxMemoryReserved().getValue() }

      /** Returns the 'notify-keyspace-events' property as a StringLiteral, if present. */
      StringLiteral getNotifyKeyspaceEvents() {
        result = this.getProperty("notify-keyspace-events")
      }

      /** Returns the 'notify-keyspace-events' property as a string, if present. */
      string notifyKeyspaceEvents() { result = this.getNotifyKeyspaceEvents().getValue() }

      /** Returns the 'preferred-data-persistence-auth-method' property as a StringLiteral, if present. */
      StringLiteral getPreferredDataPersistenceAuthMethod() {
        result = this.getProperty("preferred-data-persistence-auth-method")
      }

      /** Returns the 'preferred-data-persistence-auth-method' property as a string, if present. */
      string preferredDataPersistenceAuthMethod() {
        result = this.getPreferredDataPersistenceAuthMethod().getValue()
      }

      /** Returns the 'rdb-backup-enabled' property as a StringLiteral, if present. */
      StringLiteral getRdbBackupEnabled() { result = this.getProperty("rdb-backup-enabled") }

      /** Returns the 'rdb-backup-enabled' property as a string, if present. */
      string rdbBackupEnabled() { result = this.getRdbBackupEnabled().getValue() }

      /** Returns the 'rdb-backup-frequency' property as a StringLiteral, if present. */
      StringLiteral getRdbBackupFrequency() { result = this.getProperty("rdb-backup-frequency") }

      /** Returns the 'rdb-backup-frequency' property as a string, if present. */
      string rdbBackupFrequency() { result = this.getRdbBackupFrequency().getValue() }

      /** Returns the 'rdb-backup-max-snapshot-count' property as a StringLiteral, if present. */
      StringLiteral getRdbBackupMaxSnapshotCount() {
        result = this.getProperty("rdb-backup-max-snapshot-count")
      }

      /** Returns the 'rdb-backup-max-snapshot-count' property as a string, if present. */
      string rdbBackupMaxSnapshotCount() { result = this.getRdbBackupMaxSnapshotCount().getValue() }

      /** Returns the 'rdb-storage-connection-string' property as a StringLiteral, if present. */
      StringLiteral getRdbStorageConnectionString() {
        result = this.getProperty("rdb-storage-connection-string")
      }

      /** Returns the 'rdb-storage-connection-string' property as a string, if present. */
      string rdbStorageConnectionString() {
        result = this.getRdbStorageConnectionString().getValue()
      }

      /** Returns the 'storage-subscription-id' property as a StringLiteral, if present. */
      StringLiteral getStorageSubscriptionId() {
        result = this.getProperty("storage-subscription-id")
      }

      /** Returns the 'storage-subscription-id' property as a string, if present. */
      string storageSubscriptionId() { result = this.getStorageSubscriptionId().getValue() }

      /**
       * Returns a string representation of the RedisConfiguration object.
       */
      string toString() { result = "RedisConfiguration" }
    }
  }
}
