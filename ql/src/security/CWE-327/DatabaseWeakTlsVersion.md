# Database with weak TLS version

Database resources configured with weak TLS versions (1.0 or 1.1) are vulnerable to various cryptographic attacks and should use stronger encryption protocols. This security issue falls under [CWE-327: Use of a Broken or Risky Cryptographic Algorithm](https://cwe.mitre.org/data/definitions/327.html).

## Problem Description

TLS versions 1.0 and 1.1 have known security vulnerabilities and are considered deprecated:

1. **TLS 1.0**: Has several cryptographic weaknesses including:
   - Vulnerability to BEAST attacks
   - Weak cipher suites
   - Inadequate protection against protocol downgrade attacks

2. **TLS 1.1**: While better than 1.0, it still has limitations:
   - Limited cipher suite support
   - Vulnerable to certain types of attacks
   - Not recommended by modern security standards

3. **Compliance Issues**: Many security frameworks and regulations now require TLS 1.2 or higher
4. **Future-proofing**: Older TLS versions may become completely unsupported

## Recommendation

Configure database resources to use TLS 1.2 or higher by setting the `minimalTlsVersion` property appropriately:

- **TLS 1.2**: Set `minimalTlsVersion` to `"1.2"` or `"TLS1_2"`
- **TLS 1.3**: Set `minimalTlsVersion` to `"1.3"` or `"TLS1_3"` (if supported)

## Example

### Insecure configuration (weak TLS version):

```bicep
resource insecurePostgreSQLServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'insecure-postgresql'
  location: 'eastus'
  properties: {
    minimalTlsVersion: '1.0'  // Vulnerable: Uses deprecated TLS 1.0
    sslEnforcement: 'Enabled'
    administratorLogin: 'pgadmin'
    administratorLoginPassword: password
  }
}

resource insecureMySQLServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'insecure-mysql'
  location: 'eastus'  
  properties: {
    minimalTlsVersion: 'TLS1_1'  // Vulnerable: Uses deprecated TLS 1.1
    sslEnforcement: 'Enabled'
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: password
  }
}
```

### Secure configuration (strong TLS version):

```bicep
resource securePostgreSQLServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'secure-postgresql'
  location: 'eastus'
  properties: {
    minimalTlsVersion: '1.2'  // Secure: Uses TLS 1.2
    sslEnforcement: 'Enabled'
    administratorLogin: 'pgadmin'
    administratorLoginPassword: password
  }
}

resource secureMySQLServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'secure-mysql'
  location: 'eastus'
  properties: {
    minimalTlsVersion: 'TLS1_2'  // Secure: Uses TLS 1.2
    sslEnforcement: 'Enabled'
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: password
  }
}
```

## References

- [CWE-327: Use of a Broken or Risky Cryptographic Algorithm](https://cwe.mitre.org/data/definitions/327.html)
- [RFC 8996: Deprecating TLS 1.0 and TLS 1.1](https://tools.ietf.org/rfc/rfc8996.txt)
- [Azure Database for PostgreSQL TLS configuration](https://docs.microsoft.com/en-us/azure/postgresql/concepts-ssl-connection-security)
- [Azure Database for MySQL TLS configuration](https://docs.microsoft.com/en-us/azure/mysql/concepts-ssl-connection-security)
- [Azure SQL Database TLS configuration](https://docs.microsoft.com/en-us/azure/azure-sql/database/connectivity-settings#minimal-tls-version)
