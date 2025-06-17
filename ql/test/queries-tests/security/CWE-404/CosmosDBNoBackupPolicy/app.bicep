// Test cases for CosmosDB backup policy detection

// TEST CASE: Vulnerable - CosmosDB without backup policy
resource vulnerableCosmosDB_NoBackupPolicy 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'vulnerable-cosmosdb-no-policy'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
    // No backup policy configured - should be detected
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
  }
}

// TEST CASE: Vulnerable - CosmosDB with minimal configuration
resource vulnerableCosmosDB_Minimal 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'vulnerable-cosmosdb-minimal'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
    // No backup policy - should be detected
  }
}

// TEST CASE: Secure - CosmosDB with continuous backup policy
resource secureCosmosDB_Continuous 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'secure-cosmosdb-continuous'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
    backupPolicy: {
      type: 'Continuous'  // Should NOT be detected
    }
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
  }
}

// TEST CASE: Secure - CosmosDB with periodic backup policy
resource secureCosmosDB_Periodic 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'secure-cosmosdb-periodic'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
    backupPolicy: {
      type: 'Periodic'  // Should NOT be detected
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 720
        backupStorageRedundancy: 'Geo'
      }
    }
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
  }
}

// TEST CASE: Secure - CosmosDB with multi-region configuration and backup policy
resource secureCosmosDB_MultiRegion 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'secure-cosmosdb-multiregion'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
    enableMultipleWriteLocations: true
    backupPolicy: {
      type: 'Continuous'  // Should NOT be detected
    }
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
