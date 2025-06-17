// Test cases for database geo-redundant backup detection

// TEST CASE: Vulnerable - PostgreSQL without geo-redundant backup (missing property)
resource vulnerablePostgreSQL_NoGeoBackup 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'vulnerable-postgresql-no-geo'
  location: 'eastus'
  properties: {
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
    backup: {
      // geoRedundantBackup property is missing - should be detected
      backupRetentionDays: 7
    }
  }
}

// TEST CASE: Vulnerable - MySQL with geo-redundant backup explicitly disabled
resource vulnerableMySQL_DisabledGeoBackup 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'vulnerable-mysql-disabled-geo'
  location: 'eastus'
  properties: {
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'Password123!'
    backup: {
      geoRedundantBackup: 'Disabled'  // Should be detected
      backupRetentionDays: 7
    }
  }
}

// TEST CASE: Vulnerable - MariaDB without geo-redundant backup
resource vulnerableMariaDB_NoGeoBackup 'Microsoft.DBforMariaDB/servers@2018-06-01' = {
  name: 'vulnerable-mariadb-no-geo'
  location: 'eastus'
  properties: {
    administratorLogin: 'mariaadmin'
    administratorLoginPassword: 'Password123!'
    backup: {
      // geoRedundantBackup property is missing - should be detected
      backupRetentionDays: 14
    }
  }
}

// TEST CASE: Secure - PostgreSQL with geo-redundant backup enabled
resource securePostgreSQL_WithGeoBackup 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'secure-postgresql-with-geo'
  location: 'eastus'
  properties: {
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
    backup: {
      geoRedundantBackup: 'Enabled'  // Should NOT be detected
      backupRetentionDays: 35
    }
  }
}

// TEST CASE: Secure - MySQL with geo-redundant backup enabled
resource secureMySQL_WithGeoBackup 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'secure-mysql-with-geo'
  location: 'eastus'
  properties: {
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'Password123!'
    backup: {
      geoRedundantBackup: 'Enabled'  // Should NOT be detected
      backupRetentionDays: 35
    }
  }
}

// TEST CASE: Not applicable - Database without backup section
// Should not be detected since there's no backup object
resource databaseNoBackupSection 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'database-no-backup-section'
  location: 'eastus'
  properties: {
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
    // No backup section at all - should NOT be detected by this query
  }
}
