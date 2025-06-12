private import bicep
private import codeql.bicep.Concepts

module Databases {
  /**
   * Base class for all database resources in Azure.
   * Provides common properties and methods for Azure database resources.
   */
  abstract class DatabaseResource extends Resource {
    /**
     * Returns the type of the database resource (e.g., sql, postgresql, etc).
     */
    abstract string databaseType();

    /**
     * Returns a string representation of the database resource.
     */
    override string toString() { result = "DatabaseResource[" + this.databaseType() + "]" }

    /**
     * Returns the properties object for the database resource.
     */
    DatabaseProperties::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Returns the version property as a StringLiteral, if present.
     */
    StringLiteral getVersion() {
      result = this.getProperties().getProperty("version")
    }

    /**
     * Returns the version property of the database resource, if present.
     */
    string version() {
      result = this.getVersion().getValue()
    }

    /**
     * Returns the publicNetworkAccess property as a StringLiteral, if present.
     */
    StringLiteral getPublicNetworkAccess() {
      result = this.getProperties().getProperty("publicNetworkAccess")
    }

    /**
     * Returns the value of the publicNetworkAccess property, if present.
     */
    string publicNetworkAccess() {
      result = this.getPublicNetworkAccess().getValue()
    }

    /**
     * Returns the sslEnforcement property as a StringLiteral, if present.
     */
    StringLiteral getSslEnforcement() {
      result = this.getProperties().getProperty("sslEnforcement")
    }

    /**
     * Returns the sslEnforcement property of the database resource, if present.
     */
    string sslEnforcement() {
      result = this.getSslEnforcement().getValue()
    }

    /**
     * Returns the infrastructureEncryption property of the database resource, if present.
     */
    string infrastructureEncryption() {
      result = this.getProperties().getProperty("infrastructureEncryption").(StringLiteral).getValue()
    }

    /**
     * Returns the minimalTlsVersion property as a StringLiteral, if present.
     */
    StringLiteral getMinimalTlsVersion() {
      result = this.getProperties().getProperty("minimalTlsVersion")
    }

    /**
     * Returns the minimalTlsVersion property of the database resource, if present.
     */
    string minimalTlsVersion() {
      result = this.getMinimalTlsVersion().getValue()
    }

    /**
     * Returns the storage profile for the database resource, if present.
     */
    DatabaseProperties::StorageProfile getStorageProfile() {
      result = this.getProperties().getProperty("storageProfile")
    }
  }

  /**
   * Represents an Azure SQL Database or Managed Instance resource.
   */
  class SqlServers extends DatabaseResource, Resource {
    /**
     * Constructs an instance for Azure SQL Database/Managed Instance resources.
     */
    SqlServers() { this.getResourceType().regexpMatch("^Microsoft.Sql/servers@.*") }

    /**
     * Returns the type of the database resource ("sql").
     */
    override string databaseType() { result = "sql" }
  }

  /**
   * Represents an Azure Cosmos DB account resource.
   */
  class CosmosDBAccounts extends DatabaseResource, Resource {
    /**
     * Constructs an instance for Azure Cosmos DB account resources.
     */
    CosmosDBAccounts() {
      this.getResourceType().regexpMatch("^Microsoft.DocumentDB/databaseAccounts@.*")
    }

    /**
     * Returns the type of the database resource ("cosmosdb").
     */
    override string databaseType() { result = "cosmosdb" }

    /**
     * Returns the databaseAccountOfferType property of the Cosmos DB account.
     */
    string databaseAccountOfferType() {
      result =
        this.getProperties().getProperty("databaseAccountOfferType").(StringLiteral).getValue()
    }

    /**
     * Returns true if multiple write locations are enabled for the Cosmos DB account.
     */
    boolean isEnableMultipleWriteLocations() {
      result = this.getProperties().getProperty("enableMultipleWriteLocations").(Boolean).getBool()
    }

    /**
     * Returns the backup policy for the Cosmos DB account.
     */
    DatabaseProperties::BackupPolicy getBackupPolicy() {
      result = this.getProperties().getProperty("backupPolicy")
    }
  }

  /**
   * Represents an Azure Database for PostgreSQL server resource.
   */
  class PostgreSQLServers extends DatabaseResource, Resource {
    /**
     * Constructs an instance for Azure Database for PostgreSQL server resources.
     */
    PostgreSQLServers() {
      this.getResourceType().regexpMatch("^Microsoft.DBforPostgreSQL/servers@.*")
    }

    /**
     * Returns the type of the database resource ("postgresql").
     */
    override string databaseType() { result = "postgresql" }
  }

  /**
   * Represents an Azure Database for MySQL server resource.
   */
  class MySQLServers extends DatabaseResource, Resource {
    /**
     * Constructs an instance for Azure Database for MySQL server resources.
     */
    MySQLServers() { this.getResourceType().regexpMatch("^Microsoft.DBforMySQL/servers@.*") }

    /**
     * Returns the type of the database resource ("mysql").
     */
    override string databaseType() { result = "mysql" }
  }

  /**
   * Represents an Azure Database for MariaDB server resource.
   */
  class MariaDBServers extends DatabaseResource, Resource {
    /**
     * Constructs an instance for Azure Database for MariaDB server resources.
     */
    MariaDBServers() { this.getResourceType().regexpMatch("^Microsoft.DBforMariaDB/servers@.*") }

    /**
     * Returns the type of the database resource ("mariadb").
     */
    override string databaseType() { result = "mariadb" }
  }

  /**
   * Represents an Azure Data Lake Store Gen1 account resource.
   */
  class DataLakeStoreAccounts extends DatabaseResource, Resource {
    /**
     * Constructs an instance for Azure Data Lake Store Gen1 account resources.
     */
    DataLakeStoreAccounts() {
      this.getResourceType().regexpMatch("^Microsoft.DataLakeStore/accounts@.*")
    }

    /**
     * Returns the type of the database resource ("datalakestore").
     */
    override string databaseType() { result = "datalakestore" }
  }

  /**
   * Represents an Azure Data Explorer (Kusto) cluster resource.
   */
  class KustoClusters extends DatabaseResource, Resource {
    /**
     * Constructs an instance for Azure Data Explorer (Kusto) cluster resources.
     */
    KustoClusters() { this.getResourceType().regexpMatch("^Microsoft.Kusto/Clusters@.*") }

    /**
     * Returns the type of the database resource ("kusto").
     */
    override string databaseType() { result = "kusto" }
  }

  /**
   * Represents an Azure Arc-enabled SQL Managed Instance resource.
   */
  class ArcSqlManagedInstances extends DatabaseResource, Resource {
    /**
     * Constructs an instance for Azure Arc-enabled SQL Managed Instance resources.
     */
    ArcSqlManagedInstances() {
      this.getResourceType().regexpMatch("^Microsoft.AzureArcData/sqlManagedInstances@.*")
    }

    /**
     * Returns the type of the database resource ("arc-sql-managed-instance").
     */
    override string databaseType() { result = "arc-sql-managed-instance" }
  }

  private class PublicDatabaseResource extends PublicResource {
    private DatabaseResource database;

    /**
     * Constructs a PublicDatabaseResource if the database has public network access enabled.
     */
    PublicDatabaseResource() {
      database.publicNetworkAccess() = "Enabled" and
      this = database
    }

    /**
     * Returns the property that indicates public access for the database resource.
     */
    override Expr getPublicAccessProperty() {
      result = database.getProperties().getProperty("publicNetworkAccess")
    }
  }

  /**
   * Represents a database resource with a weak TLS version configuration.
   */
  private class WeakDatabaseTlsVersion extends Cryptography::WeakTlsVersion instanceof DatabaseResource {
    /**
     * Returns the minimalTlsVersion property as a StringLiteral for weak TLS version detection.
     */
    override StringLiteral getWeakTlsVersionProperty() {
      result = DatabaseResource.super.getProperties().getProperty("minimalTlsVersion")
    }
  }

  module DatabaseProperties {
    /**
     * Represents the properties object for a database resource.
     */
    class Properties extends ResourceProperties {
      private DatabaseResource resource;

      /**
       * Constructs a Properties object for the given resource.
       */
      Properties() { this = resource.getProperty("properties") }

      /**
       * Returns the underlying resource for these properties.
       */
      Resource getResource() { result = resource }

      override string toString() {
        result = "DatabaseProperties[" + resource.databaseType() + "]"
      }
    }

    /**
     * Represents the backup object within database properties.
     */
    class Backup extends Object {
      private Properties properties;

      /**
       * Constructs a Backup object for the given properties.
       */
      Backup() { this = properties.getProperty("backup") }

      /**
       * Returns a string representation of the backup object.
       */
      string toString() { result = "Backup" }

      /**
       * Returns the geoRedundantBackup property of the backup object.
       */
      string geoRedundantBackup() {
        result = this.getProperty("geoRedundantBackup").(StringLiteral).getValue()
      }
    }

    /**
     * Represents the backup policy object within database properties.
     */
    class BackupPolicy extends Object {
      private Properties properties;

      /**
       * Constructs a BackupPolicy object for the given properties.
       */
      BackupPolicy() { this = properties.getProperty("backupPolicy") }

      /**
       * Returns a string representation of the backup policy object.
       */
      string toString() { result = "BackupPolicy" }

      /**
       * Returns the type of the backup policy.
       */
      string getBackupPolicyType() { result = this.getProperty("type").(StringLiteral).getValue() }

      /**
       * Returns the backupRetentionDays property of the backup policy.
       */
      Expr getBackupRetentionDays() { result = this.getProperty("backupRetentionDays") }

      /**
       * Returns the backupStorageRedundancy property of the backup policy.
       */
      Expr getBackupStorageRedundancy() { result = this.getProperty("backupStorageRedundancy") }
    }

    /**
     * Represents the storage profile object within database properties.
     */
    class StorageProfile extends Object {
      private Properties properties;

      /**
       * Constructs a StorageProfile object for the given properties.
       */
      StorageProfile() { this = properties.getProperty("storageProfile") }

      /**
       * Returns a string representation of the storage profile object.
       */
      string toString() { result = "StorageProfile" }

      /**
       * Returns the storageMB property of the storage profile.
       */
      int storageMB() {
        result = this.getProperty("storageMB").(Number).getValue()
      }

      /**
       * Returns the autoGrow property of the storage profile.
       */
      string autoGrow() {
        result = this.getProperty("autoGrow").(StringLiteral).getValue()
      }
    }
  }
}
