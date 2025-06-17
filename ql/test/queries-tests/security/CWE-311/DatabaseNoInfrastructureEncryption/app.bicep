// Test cases for database infrastructure encryption detection

// TEST CASE: Vulnerable - PostgreSQL without infrastructure encryption (missing property)
resource vulnerablePostgreSQL_NoEncryption 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'vulnerable-postgresql-no-encryption'
  location: 'eastus'
  properties: {
    // infrastructureEncryption not specified - should be detected
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
    minimalTlsVersion: '1.2'
  }
}

// TEST CASE: Vulnerable - MySQL with infrastructure encryption explicitly disabled
resource vulnerableMySQL_DisabledEncryption 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'vulnerable-mysql-disabled-encryption'
  location: 'eastus'
  properties: {
    infrastructureEncryption: 'Disabled'  // Should be detected
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
    minimalTlsVersion: '1.2'
  }
}

// TEST CASE: Vulnerable - MariaDB without infrastructure encryption
resource vulnerableMariaDB_NoEncryption 'Microsoft.DBforMariaDB/servers@2018-06-01' = {
  name: 'vulnerable-mariadb-no-encryption'
  location: 'eastus'
  properties: {
    // infrastructureEncryption not specified - should be detected
    administratorLogin: 'mariaadmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
    minimalTlsVersion: '1.2'
  }
}

// TEST CASE: Secure - PostgreSQL with infrastructure encryption enabled
resource securePostgreSQL_WithEncryption 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'secure-postgresql-with-encryption'
  location: 'eastus'
  properties: {
    infrastructureEncryption: 'Enabled'  // Should NOT be detected
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
    minimalTlsVersion: '1.2'
  }
}

// TEST CASE: Secure - MySQL with infrastructure encryption enabled
resource secureMySQL_WithEncryption 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'secure-mysql-with-encryption'
  location: 'eastus'
  properties: {
    infrastructureEncryption: 'Enabled'  // Should NOT be detected
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
    minimalTlsVersion: '1.2'
  }
}

// TEST CASE: Note - SQL Server and CosmosDB typically don't have infrastructureEncryption property
// so they should not be detected by this query
