# Database without infrastructure encryption

Database resources without infrastructure encryption enabled may expose sensitive data to unauthorized access at the infrastructure level. This security gap falls under [CWE-311: Missing Encryption of Sensitive Data](https://cwe.mitre.org/data/definitions/311.html).

## Problem Description

Infrastructure encryption provides an additional layer of security by encrypting data at the infrastructure level, separate from the database's native encryption capabilities. When `infrastructureEncryption` is not enabled or is explicitly disabled:

1. **Data-at-Rest Vulnerability**: Data stored on the underlying storage infrastructure may not be adequately protected
2. **Compliance Gaps**: Many regulatory frameworks require multiple layers of encryption for sensitive data
3. **Defense in Depth**: Missing this layer reduces the overall security posture and defense-in-depth strategy
4. **Service Layer Exposure**: Data may be vulnerable if there are security issues at the Azure infrastructure level

This additional encryption layer is particularly important for:
- Healthcare data (HIPAA compliance)
- Financial data (PCI DSS compliance)
- Government and regulated industry data
- Any sensitive personal information

## Recommendation

Enable infrastructure encryption by setting the `infrastructureEncryption` property to `"Enabled"` in the database resource properties. This provides double encryption:

1. **Service-Level Encryption**: Azure's standard encryption for the database service
2. **Infrastructure-Level Encryption**: Additional encryption at the underlying infrastructure layer

Note that infrastructure encryption may have performance implications and should be tested in non-production environments first.

## Example

### Insecure configuration (no infrastructure encryption):

```bicep
resource insecurePostgreSQLServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'insecure-postgresql'
  location: 'eastus'
  properties: {
    // infrastructureEncryption property is missing - uses default (disabled)
    sslEnforcement: 'Enabled'
    minimalTlsVersion: '1.2'
    administratorLogin: 'pgadmin'
    administratorLoginPassword: password
  }
}

resource explicitlyDisabledServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'explicitly-disabled-mysql'
  location: 'eastus'
  properties: {
    infrastructureEncryption: 'Disabled'  // Vulnerable: Explicitly disabled
    sslEnforcement: 'Enabled'
    minimalTlsVersion: '1.2'
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: password
  }
}
```

### Secure configuration (infrastructure encryption enabled):

```bicep
resource securePostgreSQLServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: 'secure-postgresql'
  location: 'eastus'
  properties: {
    infrastructureEncryption: 'Enabled'  // Secure: Double encryption enabled
    sslEnforcement: 'Enabled'
    minimalTlsVersion: '1.2'
    administratorLogin: 'pgadmin'
    administratorLoginPassword: password
  }
}

resource secureMySQLServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'secure-mysql'
  location: 'eastus'
  properties: {
    infrastructureEncryption: 'Enabled'  // Secure: Double encryption enabled
    sslEnforcement: 'Enabled'
    minimalTlsVersion: '1.2'
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: password
  }
}
```

## References

- [CWE-311: Missing Encryption of Sensitive Data](https://cwe.mitre.org/data/definitions/311.html)
- [Azure Database for PostgreSQL infrastructure double encryption](https://docs.microsoft.com/en-us/azure/postgresql/concepts-infrastructure-double-encryption)
- [Azure Database for MySQL infrastructure double encryption](https://docs.microsoft.com/en-us/azure/mysql/concepts-infrastructure-double-encryption)
- [Azure encryption at rest overview](https://docs.microsoft.com/en-us/azure/security/fundamentals/encryption-atrest)
