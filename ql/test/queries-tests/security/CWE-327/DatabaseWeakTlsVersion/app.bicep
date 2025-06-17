// Test cases for database weak TLS version detection

// TEST CASE: Vulnerable - PostgreSQL with TLS 1.0
resource vulnerablePostgreSQL_TLS10 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'vulnerable-postgresql-tls10'
  location: 'eastus'
  properties: {
    minimalTlsVersion: '1.0'  // Should be detected - weak TLS
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
  }
}

// TEST CASE: Vulnerable - MySQL with TLS 1.1
resource vulnerableMySQL_TLS11 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'vulnerable-mysql-tls11'
  location: 'eastus'
  properties: {
    minimalTlsVersion: 'TLS1_1'  // Should be detected - weak TLS
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
  }
}

// TEST CASE: Vulnerable - SQL Server with TLS 1.0
resource vulnerableSQL_TLS10 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'vulnerable-sql-tls10'
  location: 'eastus'
  properties: {
    minimalTlsVersion: '1.0'  // Should be detected - weak TLS
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'Password123!'
  }
}

// TEST CASE: Vulnerable - MariaDB with TLS_1.1 format
resource vulnerableMariaDB_TLS11 'Microsoft.DBforMariaDB/servers@2018-06-01' = {
  name: 'vulnerable-mariadb-tls11'
  location: 'eastus'
  properties: {
    minimalTlsVersion: 'TLS_1.1'  // Should be detected - weak TLS
    administratorLogin: 'mariaadmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
  }
}

// TEST CASE: Secure - PostgreSQL with TLS 1.2
resource securePostgreSQL_TLS12 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'secure-postgresql-tls12'
  location: 'eastus'
  properties: {
    minimalTlsVersion: '1.2'  // Should NOT be detected - secure TLS
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
  }
}

// TEST CASE: Secure - MySQL with TLS1_2 format
resource secureMySQL_TLS12 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'secure-mysql-tls12'
  location: 'eastus'
  properties: {
    minimalTlsVersion: 'TLS1_2'  // Should NOT be detected - secure TLS
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
  }
}

// TEST CASE: Secure - SQL Server with TLS 1.3
resource secureSQL_TLS13 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'secure-sql-tls13'
  location: 'eastus'
  properties: {
    minimalTlsVersion: '1.3'  // Should NOT be detected - secure TLS
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'Password123!'
  }
}

// TEST CASE: Secure - Database without explicit TLS version (uses defaults)
resource defaultTLSDatabase 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'default-tls-database'
  location: 'eastus'
  properties: {
    // minimalTlsVersion not specified - should NOT be detected
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'Password123!'
    sslEnforcement: 'Enabled'
  }
}
