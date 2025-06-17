// Test cases for database public network access detection

// TEST CASE: Vulnerable - SQL Server with public network access enabled
resource vulnerableSqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'vulnerable-sql-server'
  location: 'eastus'
  properties: {
    publicNetworkAccess: 'Enabled'  // Should be detected
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'Password123!'
  }
}

// TEST CASE: Vulnerable - PostgreSQL with public network access enabled
resource vulnerablePostgreSQL 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'vulnerable-postgresql'
  location: 'eastus'
  properties: {
    publicNetworkAccess: 'Enabled'  // Should be detected
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
  }
}

// TEST CASE: Vulnerable - MySQL with public network access enabled
resource vulnerableMySQL 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'vulnerable-mysql'
  location: 'eastus'
  properties: {
    publicNetworkAccess: 'Enabled'  // Should be detected
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
  }
}

// TEST CASE: Secure - SQL Server with public network access disabled
resource secureSqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'secure-sql-server'
  location: 'eastus'
  properties: {
    publicNetworkAccess: 'Disabled'  // Should NOT be detected
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'Password123!'
  }
}

// TEST CASE: Secure - PostgreSQL with public network access disabled
resource securePostgreSQL 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'secure-postgresql'
  location: 'eastus'
  properties: {
    publicNetworkAccess: 'Disabled'  // Should NOT be detected
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
  }
}

// TEST CASE: Secure - MySQL without explicit public network access (defaults to disabled)
resource defaultMySQL 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'default-mysql'
  location: 'eastus'
  properties: {
    // publicNetworkAccess not specified - should NOT be detected
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
  }
}
