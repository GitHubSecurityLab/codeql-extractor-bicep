# Database without SSL enforcement

Database resources with SSL enforcement disabled allow unencrypted connections, which can expose sensitive data during transmission. This security vulnerability falls under [CWE-319: Cleartext Transmission of Sensitive Information](https://cwe.mitre.org/data/definitions/319.html).

## Problem Description

When `sslEnforcement` is set to `"Disabled"`, database connections can be established without SSL/TLS encryption. This creates several security risks:

1. **Data Exposure**: Database credentials, queries, and results are transmitted in plain text
2. **Man-in-the-Middle Attacks**: Attackers can intercept and modify database communications
3. **Credential Theft**: Database usernames and passwords can be captured by network sniffers
4. **Data Integrity**: Unencrypted data can be tampered with during transmission
5. **Compliance Violations**: Many regulations require encryption of data in transit

This vulnerability affects all database types including:
- Azure SQL Database and Managed Instance
- Azure Database for PostgreSQL
- Azure Database for MySQL
- Azure Database for MariaDB

## Recommendation

Always enable SSL enforcement by setting `sslEnforcement` to `"Enabled"` in the database properties. Additionally:

1. **Configure TLS Version**: Use `minimalTlsVersion` to enforce strong TLS versions (1.2 or higher)
2. **Client Configuration**: Ensure client applications are configured to use SSL connections
3. **Certificate Validation**: Configure clients to validate server certificates
4. **Connection Strings**: Update connection strings to require SSL/TLS

## Example

### Insecure configuration (SSL enforcement disabled):

```bicep
resource insecurePostgreSQLServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'insecure-postgresql'
  location: 'eastus'
  properties: {
    sslEnforcement: 'Disabled'  // Vulnerable: Allows unencrypted connections
    administratorLogin: 'pgadmin'
    administratorLoginPassword: password
  }
}

resource insecureMySQLServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'insecure-mysql'
  location: 'eastus'
  properties: {
    sslEnforcement: 'Disabled'  // Vulnerable: Allows unencrypted connections
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: password
  }
}
```

### Secure configuration (SSL enforcement enabled):

```bicep
resource securePostgreSQLServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'secure-postgresql'
  location: 'eastus'
  properties: {
    sslEnforcement: 'Enabled'    // Secure: Requires SSL/TLS encryption
    minimalTlsVersion: '1.2'     // Secure: Enforces strong TLS version
    administratorLogin: 'pgadmin'
    administratorLoginPassword: password
  }
}

resource secureMySQLServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'secure-mysql'
  location: 'eastus'
  properties: {
    sslEnforcement: 'Enabled'    // Secure: Requires SSL/TLS encryption
    minimalTlsVersion: 'TLS1_2'  // Secure: Enforces strong TLS version
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: password
  }
}
```

## References

- [CWE-319: Cleartext Transmission of Sensitive Information](https://cwe.mitre.org/data/definitions/319.html)
- [Azure Database for PostgreSQL SSL configuration](https://docs.microsoft.com/en-us/azure/postgresql/concepts-ssl-connection-security)
- [Azure Database for MySQL SSL configuration](https://docs.microsoft.com/en-us/azure/mysql/concepts-ssl-connection-security)
- [Azure SQL Database connection security](https://docs.microsoft.com/en-us/azure/azure-sql/database/security-overview#connection-security)
