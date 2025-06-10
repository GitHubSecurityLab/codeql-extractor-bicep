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

    override string toString() {
      result = "DatabaseResource[" + this.databaseType() + "]"
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
}
