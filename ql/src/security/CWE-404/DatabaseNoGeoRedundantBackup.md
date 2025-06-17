# Database without geo-redundant backup

Database resources without geo-redundant backup enabled may lose data permanently in case of regional disasters or data center outages. This availability and data protection issue falls under [CWE-404: Improper Resource Shutdown or Release](https://cwe.mitre.org/data/definitions/404.html).

## Problem Description

When `geoRedundantBackup` is disabled or not configured, database backups are stored only in the same region as the primary database. This creates several risks:

1. **Single Point of Failure**: Regional disasters (natural disasters, infrastructure failures) could result in complete data loss
2. **Extended Downtime**: Recovery may take significantly longer without geographically distributed backups
3. **Compliance Violations**: Many industry regulations require geographically redundant data protection
4. **Business Continuity Risk**: Critical business operations may be severely impacted by data loss

This is particularly critical for:
- Production databases containing business-critical data
- Databases with high availability requirements
- Applications with strict recovery time objectives (RTO) and recovery point objectives (RPO)

## Recommendation

Enable geo-redundant backup by setting `geoRedundantBackup` to `"Enabled"` in the backup configuration. This ensures:

1. **Geographic Distribution**: Backups are replicated to a paired Azure region
2. **Disaster Recovery**: Data can be restored even if the entire primary region becomes unavailable
3. **Compliance**: Meets most regulatory requirements for data protection and business continuity
4. **Peace of Mind**: Provides additional protection for critical business data

Consider the cost implications of geo-redundant storage and balance them against your data protection requirements.

## Example

### Insecure configuration (no geo-redundant backup):

```bicep
resource insecurePostgreSQLServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'insecure-postgresql'
  location: 'eastus'
  properties: {
    administratorLogin: 'pgadmin'
    administratorLoginPassword: password
    backup: {
      // geoRedundantBackup property is missing - uses default (disabled)
      backupRetentionDays: 7
    }
  }
}

resource explicitlyDisabledBackup 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'no-geo-backup-mysql'
  location: 'eastus'
  properties: {
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: password
    backup: {
      geoRedundantBackup: 'Disabled'  // Vulnerable: No geographic redundancy
      backupRetentionDays: 7
    }
  }
}
```

### Secure configuration (geo-redundant backup enabled):

```bicep
resource securePostgreSQLServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'secure-postgresql'
  location: 'eastus'
  properties: {
    administratorLogin: 'pgadmin'
    administratorLoginPassword: password
    backup: {
      geoRedundantBackup: 'Enabled'  // Secure: Geographic backup redundancy
      backupRetentionDays: 35        // Extended retention for critical data
    }
  }
}

resource secureMySQLServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'secure-mysql'
  location: 'eastus'
  properties: {
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: password
    backup: {
      geoRedundantBackup: 'Enabled'  // Secure: Geographic backup redundancy
      backupRetentionDays: 35
    }
  }
}
```

## References

- [CWE-404: Improper Resource Shutdown or Release](https://cwe.mitre.org/data/definitions/404.html)
- [Azure Database for PostgreSQL backup and restore](https://docs.microsoft.com/en-us/azure/postgresql/concepts-backup)
- [Azure Database for MySQL backup and restore](https://docs.microsoft.com/en-us/azure/mysql/concepts-backup)
- [Azure SQL Database geo-redundant backups](https://docs.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview)
- [Azure business continuity and disaster recovery](https://docs.microsoft.com/en-us/azure/architecture/framework/resiliency/backup-and-recovery)
