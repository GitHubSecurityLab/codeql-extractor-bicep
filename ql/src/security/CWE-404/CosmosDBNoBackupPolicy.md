# CosmosDB without backup policy

CosmosDB accounts without a properly configured backup policy may lose data permanently in case of accidental deletion, corruption, or other data loss scenarios. This data protection issue falls under [CWE-404: Improper Resource Shutdown or Release](https://cwe.mitre.org/data/definitions/404.html).

## Problem Description

When a CosmosDB account lacks a backup policy configuration, it relies on default settings that may not meet your business requirements:

1. **Inadequate Protection**: Default backup settings may not provide sufficient protection for critical data
2. **Limited Recovery Options**: Without proper backup configuration, recovery options may be severely limited
3. **Compliance Gaps**: Many regulations require explicit backup and data retention policies
4. **Business Risk**: Accidental data deletion or corruption could result in permanent data loss

Key backup policy considerations include:
- **Backup Type**: Periodic vs. continuous backup modes
- **Retention Period**: How long backups are retained
- **Backup Interval**: How frequently backups are taken
- **Storage Redundancy**: Geographic distribution of backup data

## Recommendation

Always configure an explicit backup policy for CosmosDB accounts based on your data protection requirements:

1. **Continuous Backup**: For point-in-time recovery capabilities (recommended for critical data)
2. **Periodic Backup**: For cost-effective backup with scheduled intervals
3. **Appropriate Retention**: Set retention periods based on business and compliance needs
4. **Storage Redundancy**: Use geo-redundant storage for critical data

## Example

### Insecure configuration (no backup policy):

```bicep
resource insecureCosmosDB 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'insecure-cosmosdb'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
    // No backup policy configured - relies on defaults
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
  }
}
```

### Secure configuration (explicit backup policy):

```bicep
resource secureCosmosDBContinuous 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'secure-cosmosdb-continuous'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
    backupPolicy: {
      type: 'Continuous'  // Secure: Continuous backup for point-in-time recovery
    }
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
  }
}

resource secureCosmosDBPeriodic 'Microsoft.DocumentDB/databaseAccounts@2022-03-15' = {
  name: 'secure-cosmosdb-periodic'
  location: 'eastus'
  properties: {
    databaseAccountOfferType: 'Standard'
    backupPolicy: {
      type: 'Periodic'  // Secure: Periodic backup with explicit configuration
      periodicModeProperties: {
        backupIntervalInMinutes: 240       // Backup every 4 hours
        backupRetentionIntervalInHours: 720 // Retain for 30 days
        backupStorageRedundancy: 'Geo'     // Geographic redundancy
      }
    }
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
  }
}
```

## References

- [CWE-404: Improper Resource Shutdown or Release](https://cwe.mitre.org/data/definitions/404.html)
- [Azure Cosmos DB backup and restore](https://docs.microsoft.com/en-us/azure/cosmos-db/online-backup-and-restore)
- [Azure Cosmos DB continuous backup](https://docs.microsoft.com/en-us/azure/cosmos-db/continuous-backup-restore-introduction)
- [Azure Cosmos DB periodic backup](https://docs.microsoft.com/en-us/azure/cosmos-db/periodic-backup-restore-introduction)
