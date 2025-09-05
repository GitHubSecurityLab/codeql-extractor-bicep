/**
 * Provides classes for working with Microsoft.Cache resources.
 */
private import bicep
private import codeql.bicep.Concepts

module Cache {
  abstract class CacheResource extends AzureResource { }

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

    /**
     * Returns the Redis configuration object.
     */
    CacheProperties::RedisConfiguration getRedisConfiguration() {
      result = this.getProperties().getRedisConfiguration()
    }

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

      /**
       * Returns the redisConfiguration object, if present.
       */
      RedisConfiguration getRedisConfiguration() {
        result = this.getProperty("redisConfiguration")
      }

      /**
       * Returns the disableAccessKeyAuthentication property as a Boolean, if present.
       */
      Boolean getDisableAccessKeyAuthentication() { 
        result = this.getProperty("disableAccessKeyAuthentication")
      }

      /**
       * Returns the disableAccessKeyAuthentication property as a boolean, if present.
       */
      boolean disableAccessKeyAuthentication() {
        result = this.getDisableAccessKeyAuthentication().getBool()
      }

      /**
       * Returns true if the disableAccessKeyAuthentication property is defined.
       */
      predicate hasDisableAccessKeyAuthentication() {
        exists(this.getDisableAccessKeyAuthentication())
      }

      /**
       * Returns the enableNonSslPort property as a Boolean, if present.
       */
      Boolean getEnableNonSslPort() { result = this.getProperty("enableNonSslPort") }

      /**
       * Returns the enableNonSslPort property as a boolean, if present.
       */
      boolean enableNonSslPort() { result = this.getEnableNonSslPort().getBool() }

      /**
       * Returns true if the enableNonSslPort property is defined.
       */
      predicate hasEnableNonSslPort() { exists(this.getEnableNonSslPort()) }

      /**
       * Returns the minimumTlsVersion property as a StringLiteral, if present.
       */
      StringLiteral getMinimumTlsVersion() { result = this.getProperty("minimumTlsVersion") }

      /**
       * Returns the minimumTlsVersion property as a string, if present.
       */
      string minimumTlsVersion() { result = this.getMinimumTlsVersion().getValue() }

      /**
       * Returns true if the minimumTlsVersion property is defined.
       */
      predicate hasMinimumTlsVersion() { exists(this.getMinimumTlsVersion()) }

      /**
       * Returns the publicNetworkAccess property as a StringLiteral, if present.
       */
      StringLiteral getPublicNetworkAccess() { result = this.getProperty("publicNetworkAccess") }

      /**
       * Returns the publicNetworkAccess property as a string, if present.
       */
      string publicNetworkAccess() { result = this.getPublicNetworkAccess().getValue() }

      /**
       * Returns true if the publicNetworkAccess property is defined.
       */
      predicate hasPublicNetworkAccess() { exists(this.getPublicNetworkAccess()) }

      /**
       * Returns the redisVersion property as a StringLiteral, if present.
       */
      StringLiteral getRedisVersion() { result = this.getProperty("redisVersion") }

      /**
       * Returns the redisVersion property as a string, if present.
       */
      string redisVersion() { result = this.getRedisVersion().getValue() }

      /**
       * Returns true if the redisVersion property is defined.
       */
      predicate hasRedisVersion() { exists(this.getRedisVersion()) }

      /**
       * Returns the replicasPerMaster property as a NumberLiteral, if present.
       */
      Number getReplicasPerMaster() { result = this.getProperty("replicasPerMaster") }

      /**
       * Returns the replicasPerMaster property as an int, if present.
       */
      int replicasPerMaster() { result = this.getReplicasPerMaster().getValue() }

      /**
       * Returns true if the replicasPerMaster property is defined.
       */
      predicate hasReplicasPerMaster() { exists(this.getReplicasPerMaster()) }

      /**
       * Returns the replicasPerPrimary property as a NumberLiteral, if present.
       */
      Number getReplicasPerPrimary() { result = this.getProperty("replicasPerPrimary") }

      /**
       * Returns the replicasPerPrimary property as an int, if present.
       */
      int replicasPerPrimary() { result = this.getReplicasPerPrimary().getValue() }

      /**
       * Returns true if the replicasPerPrimary property is defined.
       */
      predicate hasReplicasPerPrimary() { exists(this.getReplicasPerPrimary()) }

      /**
       * Returns the shardCount property as a NumberLiteral, if present.
       */
      Number getShardCount() { result = this.getProperty("shardCount") }

      /**
       * Returns the shardCount property as an int, if present.
       */
      int shardCount() { result = this.getShardCount().getValue() }

      /**
       * Returns true if the shardCount property is defined.
       */
      predicate hasShardCount() { exists(this.getShardCount()) }

      /**
       * Returns the sku property as an Object, if present.
       */
      Object getSku() { result = this.getProperty("sku") }

      /**
       * Returns true if the sku property is defined.
       */
      predicate hasSku() { exists(this.getSku()) }

      /**
       * Returns the staticIP property as a StringLiteral, if present.
       */
      StringLiteral getStaticIP() { result = this.getProperty("staticIP") }

      /**
       * Returns the staticIP property as a string, if present.
       */
      string staticIP() { result = this.getStaticIP().getValue() }

      /**
       * Returns true if the staticIP property is defined.
       */
      predicate hasStaticIP() { exists(this.getStaticIP()) }

      /**
       * Returns the subnetId property as a StringLiteral, if present.
       */
      StringLiteral getSubnetId() { result = this.getProperty("subnetId") }

      /**
       * Returns the subnetId property as a string, if present.
       */
      string subnetId() { result = this.getSubnetId().getValue() }

      /**
       * Returns true if the subnetId property is defined.
       */
      predicate hasSubnetId() { exists(this.getSubnetId()) }

      /**
       * Returns the tenantSettings property as an Object, if present.
       */
      Object getTenantSettings() { result = this.getProperty("tenantSettings") }

      /**
       * Returns true if the tenantSettings property is defined.
       */
      predicate hasTenantSettings() { exists(this.getTenantSettings()) }

      /**
       * Returns the updateChannel property as a StringLiteral, if present.
       */
      StringLiteral getUpdateChannel() { result = this.getProperty("updateChannel") }

      /**
       * Returns the updateChannel property as a string, if present.
       */
      string updateChannel() { result = this.getUpdateChannel().getValue() }

      /**
       * Returns true if the updateChannel property is defined.
       */
      predicate hasUpdateChannel() { exists(this.getUpdateChannel()) }

      /**
       * Returns the zonalAllocationPolicy property as a StringLiteral, if present.
       */
      StringLiteral getZonalAllocationPolicy() { result = this.getProperty("zonalAllocationPolicy") }

      /**
       * Returns the zonalAllocationPolicy property as a string, if present.
       */
      string zonalAllocationPolicy() { result = this.getZonalAllocationPolicy().getValue() }

      /**
       * Returns true if the zonalAllocationPolicy property is defined.
       */
      predicate hasZonalAllocationPolicy() { exists(this.getZonalAllocationPolicy()) }

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
      
      /** Returns true if the 'aad-enabled' property is defined. */
      predicate hasAadEnabled() { exists(this.getAadEnabled()) }

      /** Returns the 'aof-backup-enabled' property as a StringLiteral, if present. */
      StringLiteral getAofBackupEnabled() { result = this.getProperty("aof-backup-enabled") }

      /** Returns the 'aof-backup-enabled' property as a string, if present. */
      string aofBackupEnabled() { result = this.getAofBackupEnabled().getValue() }
      
      /** Returns true if the 'aof-backup-enabled' property is defined. */
      predicate hasAofBackupEnabled() { exists(this.getAofBackupEnabled()) }

      /** Returns the 'aof-storage-connection-string-0' property as a StringLiteral, if present. */
      StringLiteral getAofStorageConnectionString0() {
        result = this.getProperty("aof-storage-connection-string-0")
      }

      /** Returns the 'aof-storage-connection-string-0' property as a string, if present. */
      string aofStorageConnectionString0() {
        result = this.getAofStorageConnectionString0().getValue()
      }
      
      /** Returns true if the 'aof-storage-connection-string-0' property is defined. */
      predicate hasAofStorageConnectionString0() { exists(this.getAofStorageConnectionString0()) }

      /** Returns the 'aof-storage-connection-string-1' property as a StringLiteral, if present. */
      StringLiteral getAofStorageConnectionString1() {
        result = this.getProperty("aof-storage-connection-string-1")
      }

      /** Returns the 'aof-storage-connection-string-1' property as a string, if present. */
      string aofStorageConnectionString1() {
        result = this.getAofStorageConnectionString1().getValue()
      }

      /** Returns true if the 'aof-storage-connection-string-1' property is defined. */
      predicate hasAofStorageConnectionString1() { exists(this.getAofStorageConnectionString1()) }

      /** Returns the 'authnotrequired' property as a StringLiteral, if present. */
      StringLiteral getAuthNotRequired() { result = this.getProperty("authnotrequired") }

      /** Returns the 'authnotrequired' property as a string, if present. */
      string authNotRequired() { result = this.getAuthNotRequired().getValue() }

      /** Returns true if the 'authnotrequired' property is defined. */
      predicate hasAuthNotRequired() { exists(this.getAuthNotRequired()) }

      /** Returns the 'maxfragmentationmemory-reserved' property as a StringLiteral, if present. */
      StringLiteral getMaxFragmentationMemoryReserved() {
        result = this.getProperty("maxfragmentationmemory-reserved")
      }

      /** Returns the 'maxfragmentationmemory-reserved' property as a string, if present. */
      string maxFragmentationMemoryReserved() {
        result = this.getMaxFragmentationMemoryReserved().getValue()
      }

      /** Returns true if the 'maxfragmentationmemory-reserved' property is defined. */
      predicate hasMaxFragmentationMemoryReserved() { exists(this.getMaxFragmentationMemoryReserved()) }

      /** Returns the 'maxmemory-delta' property as a StringLiteral, if present. */
      StringLiteral getMaxMemoryDelta() { result = this.getProperty("maxmemory-delta") }

      /** Returns the 'maxmemory-delta' property as a string, if present. */
      string maxMemoryDelta() { result = this.getMaxMemoryDelta().getValue() }

      /** Returns true if the 'maxmemory-delta' property is defined. */
      predicate hasMaxMemoryDelta() { exists(this.getMaxMemoryDelta()) }

      /** Returns the 'maxmemory-policy' property as a StringLiteral, if present. */
      StringLiteral getMaxMemoryPolicy() { result = this.getProperty("maxmemory-policy") }

      /** Returns the 'maxmemory-policy' property as a string, if present. */
      string maxMemoryPolicy() { result = this.getMaxMemoryPolicy().getValue() }

      /** Returns true if the 'maxmemory-policy' property is defined. */
      predicate hasMaxMemoryPolicy() { exists(this.getMaxMemoryPolicy()) }

      /** Returns the 'maxmemory-reserved' property as a StringLiteral, if present. */
      StringLiteral getMaxMemoryReserved() { result = this.getProperty("maxmemory-reserved") }

      /** Returns the 'maxmemory-reserved' property as a string, if present. */
      string maxMemoryReserved() { result = this.getMaxMemoryReserved().getValue() }

      /** Returns true if the 'maxmemory-reserved' property is defined. */
      predicate hasMaxMemoryReserved() { exists(this.getMaxMemoryReserved()) }

      /** Returns the 'notify-keyspace-events' property as a StringLiteral, if present. */
      StringLiteral getNotifyKeyspaceEvents() {
        result = this.getProperty("notify-keyspace-events")
      }

      /** Returns the 'notify-keyspace-events' property as a string, if present. */
      string notifyKeyspaceEvents() { result = this.getNotifyKeyspaceEvents().getValue() }

      /** Returns true if the 'notify-keyspace-events' property is defined. */
      predicate hasNotifyKeyspaceEvents() { exists(this.getNotifyKeyspaceEvents()) }

      /** Returns the 'preferred-data-persistence-auth-method' property as a StringLiteral, if present. */
      StringLiteral getPreferredDataPersistenceAuthMethod() {
        result = this.getProperty("preferred-data-persistence-auth-method")
      }

      /** Returns the 'preferred-data-persistence-auth-method' property as a string, if present. */
      string preferredDataPersistenceAuthMethod() {
        result = this.getPreferredDataPersistenceAuthMethod().getValue()
      }

      /** Returns true if the 'preferred-data-persistence-auth-method' property is defined. */
      predicate hasPreferredDataPersistenceAuthMethod() { exists(this.getPreferredDataPersistenceAuthMethod()) }

      /** Returns the 'rdb-backup-enabled' property as a StringLiteral, if present. */
      StringLiteral getRdbBackupEnabled() { result = this.getProperty("rdb-backup-enabled") }

      /** Returns the 'rdb-backup-enabled' property as a string, if present. */
      string rdbBackupEnabled() { result = this.getRdbBackupEnabled().getValue() }

      /** Returns true if the 'rdb-backup-enabled' property is defined. */
      predicate hasRdbBackupEnabled() { exists(this.getRdbBackupEnabled()) }

      /** Returns the 'rdb-backup-frequency' property as a StringLiteral, if present. */
      StringLiteral getRdbBackupFrequency() { result = this.getProperty("rdb-backup-frequency") }

      /** Returns the 'rdb-backup-frequency' property as a string, if present. */
      string rdbBackupFrequency() { result = this.getRdbBackupFrequency().getValue() }

      /** Returns true if the 'rdb-backup-frequency' property is defined. */
      predicate hasRdbBackupFrequency() { exists(this.getRdbBackupFrequency()) }

      /** Returns the 'rdb-backup-max-snapshot-count' property as a StringLiteral, if present. */
      StringLiteral getRdbBackupMaxSnapshotCount() {
        result = this.getProperty("rdb-backup-max-snapshot-count")
      }

      /** Returns the 'rdb-backup-max-snapshot-count' property as a string, if present. */
      string rdbBackupMaxSnapshotCount() { result = this.getRdbBackupMaxSnapshotCount().getValue() }

      /** Returns true if the 'rdb-backup-max-snapshot-count' property is defined. */
      predicate hasRdbBackupMaxSnapshotCount() { exists(this.getRdbBackupMaxSnapshotCount()) }

      /** Returns the 'rdb-storage-connection-string' property as a StringLiteral, if present. */
      StringLiteral getRdbStorageConnectionString() {
        result = this.getProperty("rdb-storage-connection-string")
      }

      /** Returns the 'rdb-storage-connection-string' property as a string, if present. */
      string rdbStorageConnectionString() {
        result = this.getRdbStorageConnectionString().getValue()
      }

      /** Returns true if the 'rdb-storage-connection-string' property is defined. */
      predicate hasRdbStorageConnectionString() { exists(this.getRdbStorageConnectionString()) }

      /** Returns the 'storage-subscription-id' property as a StringLiteral, if present. */
      StringLiteral getStorageSubscriptionId() {
        result = this.getProperty("storage-subscription-id")
      }

      /** Returns the 'storage-subscription-id' property as a string, if present. */
      string storageSubscriptionId() { result = this.getStorageSubscriptionId().getValue() }

      /** Returns true if the 'storage-subscription-id' property is defined. */
      predicate hasStorageSubscriptionId() { exists(this.getStorageSubscriptionId()) }

      /**
       * Returns a string representation of the RedisConfiguration object.
       */
      override string toString() { result = "RedisConfiguration" }
    }
  }
}
