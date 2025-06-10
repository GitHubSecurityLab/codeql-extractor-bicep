// Azure SQL Database
resource sqlDb 'Microsoft.Sql/servers@2022-02-01' = {
  name: 'sqlserver1'
  location: 'eastus'
  properties: {
    administratorLogin: 'adminuser'
    administratorLoginPassword: 'P@ssw0rd!'
  }
}

// Azure Cosmos DB
resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'cosmosdb1'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
  }
}

// Azure Database for PostgreSQL
resource postgresqlDb 'Microsoft.DBforPostgreSQL/servers@2022-01-20' = {
  name: 'pgserver1'
  location: 'eastus'
  properties: {
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'P@ssw0rd!'
    version: '11'
  }
}

// Azure Database for MySQL
resource mysqlDb 'Microsoft.DBforMySQL/servers@2022-01-20' = {
  name: 'mysqlserver1'
  location: 'eastus'
  properties: {
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'P@ssw0rd!'
    version: '5.7'
  }
}

// Azure Database for MariaDB
resource mariadbDb 'Microsoft.DBforMariaDB/servers@2018-06-01' = {
  name: 'mariadbserver1'
  location: 'eastus'
  properties: {
    administratorLogin: 'mariadbadmin'
    administratorLoginPassword: 'P@ssw0rd!'
    version: '10.2'
  }
}

// Azure Data Lake Store Gen1
resource datalakeStore 'Microsoft.DataLakeStore/accounts@2016-11-01' = {
  name: 'datalakestore1'
  location: 'eastus'
  properties: {}
}

// Azure Cache for Redis
resource redisCache 'Microsoft.Cache/Redis@2023-04-01' = {
  name: 'rediscache1'
  location: 'eastus'
  properties: {
    sku: {
      name: 'Basic'
      family: 'C'
      capacity: 0
    }
  }
}

// Azure Data Explorer (Kusto)
resource kustoCluster 'Microsoft.Kusto/Clusters@2023-05-02' = {
  name: 'kustocluster1'
  location: 'eastus'
  properties: {
    sku: {
      name: 'Standard_D13_v2'
      capacity: 2
    }
  }
}

// Azure Arc-enabled SQL Managed Instance
resource arcSqlMi 'Microsoft.AzureArcData/sqlManagedInstances@2022-03-01-preview' = {
  name: 'arcsqlmi1'
  location: 'eastus'
  properties: {
    administratorLogin: 'arcadmin'
    administratorLoginPassword: 'P@ssw0rd!'
  }
}
