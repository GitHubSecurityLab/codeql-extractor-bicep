// Cosmos DB Account with default settings
resource cosmosDbDefault 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'cosmosdb-default'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
  }
}

// Cosmos DB Account with geo-redundancy and multi-region write
resource cosmosDbGeo 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'cosmosdb-geo'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
    enableMultipleWriteLocations: true
    locations: [
      {
        locationName: 'eastus'
        failoverPriority: 0
        isZoneRedundant: false
      }
      {
        locationName: 'westus'
        failoverPriority: 1
        isZoneRedundant: true
      }
    ]
  }
}

// Cosmos DB Account with continuous backup
resource cosmosDbContinuousBackup 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'cosmosdb-continuous'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
    backupPolicy: {
      type: 'Continuous'
    }
  }
}

// Cosmos DB Account with periodic backup and custom retention
resource cosmosDbPeriodicBackup 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'cosmosdb-periodic'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 24
      }
    }
  }
}


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

// Azure Database for PostgreSQL with geo-redundant backup and high availability
resource postgresqlDb 'Microsoft.DBforPostgreSQL/servers@2022-01-20' = {
  name: 'pgserver1'
  location: 'eastus'
  properties: {
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'P@ssw0rd!'
    version: '11'
    backup': {
      geoRedundantBackup: 'Enabled'
    }
    highAvailability: {
      mode: 'ZoneRedundant'
    }
  }
}

// Azure Database for MySQL with SSL enforcement and auto-grow
resource mysqlDb 'Microsoft.DBforMySQL/servers@2022-01-20' = {
  name: 'mysqlserver1'
  location: 'eastus'
  properties: {
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'P@ssw0rd!'
    version: '5.7'
    sslEnforcement: 'Enabled'
    storageProfile: {
      storageMB: 51200
      autoGrow: 'Enabled'
    }
  }
}

// Azure Database for MariaDB with backup retention and geo-redundancy
resource mariadbDb 'Microsoft.DBforMariaDB/servers@2018-06-01' = {
  name: 'mariadbserver1'
  location: 'eastus'
  properties: {
    administratorLogin: 'mariadbadmin'
    administratorLoginPassword: 'P@ssw0rd!'
    version: '10.2'
    backupRetentionDays: 14
    geoRedundantBackup: 'Enabled'
  }
}

// Azure Data Lake Store Gen1
resource datalakeStore 'Microsoft.DataLakeStore/accounts@2016-11-01' = {
  name: 'datalakestore1'
  location: 'eastus'
  properties: {}
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
