// Test cases for database SSL enforcement detection

// TEST CASE: Vulnerable - PostgreSQL with SSL enforcement disabled
resource vulnerablePostgreSQL_NoSSL 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'vulnerable-postgresql-no-ssl'
  location: 'eastus'
  properties: {
    sslEnforcement: 'Disabled'  // Should be detected
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
  }
}

// TEST CASE: Vulnerable - MySQL with SSL enforcement disabled
resource vulnerableMySQL_NoSSL 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'vulnerable-mysql-no-ssl'
  location: 'eastus'
  properties: {
    sslEnforcement: 'Disabled'  // Should be detected
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'Password123!'
  }
}

// TEST CASE: Vulnerable - MariaDB with SSL enforcement disabled
resource vulnerableMariaDB_NoSSL 'Microsoft.DBforMariaDB/servers@2018-06-01' = {
  name: 'vulnerable-mariadb-no-ssl'
  location: 'eastus'
  properties: {
    sslEnforcement: 'Disabled'  // Should be detected
    administratorLogin: 'mariaadmin'
    administratorLoginPassword: 'Password123!'
  }
}

// TEST CASE: Secure - PostgreSQL with SSL enforcement enabled
resource securePostgreSQL_WithSSL 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'secure-postgresql-with-ssl'
  location: 'eastus'
  properties: {
    sslEnforcement: 'Enabled'   // Should NOT be detected
    minimalTlsVersion: '1.2'
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
  }
}

// TEST CASE: Secure - MySQL with SSL enforcement enabled
resource secureMySQL_WithSSL 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'secure-mysql-with-ssl'
  location: 'eastus'
  properties: {
    sslEnforcement: 'Enabled'   // Should NOT be detected
    minimalTlsVersion: 'TLS1_2'
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'Password123!'
  }
}

// TEST CASE: Secure - Database without explicit SSL enforcement (uses defaults)
resource defaultSSLDatabase 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'default-ssl-database'
  location: 'eastus'
  properties: {
    // sslEnforcement not specified - should NOT be detected (depends on default)
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
  }
}

// TEST CASE: Note - SQL Server typically doesn't have sslEnforcement property
// CosmosDB also doesn't have this property, so they won't be detected
