private import bicep

module Databases {
  /**
   * Base class for all database resources in Azure.
   */
  abstract class DatabaseResource extends Resource {
    /**
     * Returns the type of the database resource.
     */
    abstract string databaseType();

    override string toString() { result = "DatabaseResource[" + this.databaseType() + "]" }

    DatabaseProperties::Properties getProperties() { result = this.getProperty("properties") }

    string version() {
      result = this.getProperties().getProperty("version").(StringLiteral).getValue()
    }

    string sslEnforcement() {
      result = this.getProperties().getProperty("sslEnforcement").(StringLiteral).getValue()
    }

    string infrastructureEncryption() {
      result = this.getProperties().getProperty("infrastructureEncryption").(StringLiteral).getValue()
    }

    string minimalTlsVersion() {
      result = this.getProperties().getProperty("minimalTlsVersion").(StringLiteral).getValue()
    }

    DatabaseProperties::StorageProfile getStorageProfile() {
      result = this.getProperties().getProperty("storageProfile")
    }
  }

  /**
   * Azure SQL Database/Managed Instance
   */
  class SqlServers extends DatabaseResource, Resource {
    SqlServers() { this.getResourceType().regexpMatch("^Microsoft.Sql/servers@.*") }

    override string databaseType() { result = "sql" }
  }

  /**
   * Azure Cosmos DB
   */
  class CosmosDBAccounts extends DatabaseResource, Resource {
    CosmosDBAccounts() {
      this.getResourceType().regexpMatch("^Microsoft.DocumentDB/databaseAccounts@.*")
    }

    override string databaseType() { result = "cosmosdb" }

    string databaseAccountOfferType() {
      result =
        this.getProperties().getProperty("databaseAccountOfferType").(StringLiteral).getValue()
    }

    boolean isEnableMultipleWriteLocations() {
      result = this.getProperties().getProperty("enableMultipleWriteLocations").(Boolean).getBool()
    }

    DatabaseProperties::BackupPolicy getBackupPolicy() {
      result = this.getProperties().getProperty("backupPolicy")
    }
  }

  /**
   * Azure Database for PostgreSQL
   */
  class PostgreSQLServers extends DatabaseResource, Resource {
    PostgreSQLServers() {
      this.getResourceType().regexpMatch("^Microsoft.DBforPostgreSQL/servers@.*")
    }

    override string databaseType() { result = "postgresql" }
  }

  /**
   * Azure Database for MySQL
   */
  class MySQLServers extends DatabaseResource, Resource {
    MySQLServers() { this.getResourceType().regexpMatch("^Microsoft.DBforMySQL/servers@.*") }

    override string databaseType() { result = "mysql" }
  }

  /**
   * Azure Database for MariaDB
   */
  class MariaDBServers extends DatabaseResource, Resource {
    MariaDBServers() { this.getResourceType().regexpMatch("^Microsoft.DBforMariaDB/servers@.*") }

    override string databaseType() { result = "mariadb" }
  }

  /**
   * Azure Data Lake Store Gen1
   */
  class DataLakeStoreAccounts extends DatabaseResource, Resource {
    DataLakeStoreAccounts() {
      this.getResourceType().regexpMatch("^Microsoft.DataLakeStore/accounts@.*")
    }

    override string databaseType() { result = "datalakestore" }
  }

  /**
   * Azure Cache for Redis
   */
  class RedisCaches extends DatabaseResource, Resource {
    RedisCaches() { this.getResourceType().regexpMatch("^Microsoft.Cache/Redis@.*") }

    override string databaseType() { result = "redis" }
  }

  /**
   * Azure Data Explorer (Kusto)
   */
  class KustoClusters extends DatabaseResource, Resource {
    KustoClusters() { this.getResourceType().regexpMatch("^Microsoft.Kusto/Clusters@.*") }

    override string databaseType() { result = "kusto" }
  }

  /**
   * Azure Arc-enabled SQL Managed Instance
   */
  class ArcSqlManagedInstances extends DatabaseResource, Resource {
    ArcSqlManagedInstances() {
      this.getResourceType().regexpMatch("^Microsoft.AzureArcData/sqlManagedInstances@.*")
    }

    override string databaseType() { result = "arc-sql-managed-instance" }
  }

  module DatabaseProperties {
    class Properties extends Object {
      private Resource resource;

      Properties() { this = resource.getProperty("properties") }

      Resource getResource() { result = resource }
    }

    class Backup extends Object {
      private Properties properties;

      Backup() { this = properties.getProperty("backup") }

      string toString() { result = "Backup" }

      string geoRedundantBackup() {
        result = this.getProperty("geoRedundantBackup").(StringLiteral).getValue()
      }
    }

    class BackupPolicy extends Object {
      private Properties properties;

      BackupPolicy() { this = properties.getProperty("backupPolicy") }

      string toString() { result = "BackupPolicy" }

      string getBackupPolicyType() { result = this.getProperty("type").(StringLiteral).getValue() }

      Expr getBackupRetentionDays() { result = this.getProperty("backupRetentionDays") }

      Expr getBackupStorageRedundancy() { result = this.getProperty("backupStorageRedundancy") }
    }

    class StorageProfile extends Object {
      private Properties properties;

      StorageProfile() { this = properties.getProperty("storageProfile") }

      string toString() { result = "StorageProfile" }

      int storageMB() {
        result = this.getProperty("storageMB").(Number).getValue()
      }

      string autoGrow() {
        result = this.getProperty("autoGrow").(StringLiteral).getValue()
      }
    }
  }
}
