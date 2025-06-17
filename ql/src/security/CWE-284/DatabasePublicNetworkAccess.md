# Database with public network access enabled

Database resources configured with public network access enabled are accessible from the internet, significantly increasing the attack surface and security risks. This misconfiguration falls under [CWE-284: Improper Access Control](https://cwe.mitre.org/data/definitions/284.html).

## Problem Description

When a database resource has `publicNetworkAccess` set to `"Enabled"`, it allows connections from any public IP address on the internet. This creates several security risks:

1. **Increased Attack Surface**: The database becomes a target for brute force attacks, credential stuffing, and other network-based attacks
2. **Data Exposure Risk**: If authentication is compromised, sensitive data stored in the database could be accessed by attackers
3. **Compliance Issues**: Many regulatory frameworks require databases containing sensitive data to be isolated from public networks
4. **Lateral Movement**: A compromised publicly accessible database can serve as an entry point for attackers to move laterally within your infrastructure

This issue affects all database types including SQL servers, PostgreSQL, MySQL, MariaDB, Cosmos DB, and others.

## Recommendation

Disable public network access by setting `publicNetworkAccess` to `"Disabled"` and use one of these secure alternatives:

1. **Private Endpoints**: Use Azure Private Link to create private endpoints for secure connectivity
2. **Virtual Network Integration**: Deploy databases within a virtual network (VNet) for network isolation
3. **Service Endpoints**: Use VNet service endpoints to allow access only from specific subnets
4. **Firewall Rules**: If public access is absolutely necessary, configure strict firewall rules to allow only specific IP addresses

## Example

### Insecure configuration (public access enabled):

```bicep
resource insecureSqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'insecure-sql-server'
  location: 'eastus'
  properties: {
    publicNetworkAccess: 'Enabled'  // Vulnerable: Allows public internet access
    administratorLogin: 'sqladmin'
    administratorLoginPassword: password
  }
}
```

### Secure configuration (public access disabled):

```bicep
resource secureSqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'secure-sql-server'
  location: 'eastus'
  properties: {
    publicNetworkAccess: 'Disabled'  // Secure: Blocks public internet access
    administratorLogin: 'sqladmin'
    administratorLoginPassword: password
  }
}

// Add a private endpoint for secure connectivity
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: 'sql-private-endpoint'
  location: 'eastus'
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'sql-connection'
        properties: {
          privateLinkServiceId: secureSqlServer.id
          groupIds: ['sqlServer']
        }
      }
    ]
  }
}
```

## References

- [CWE-284: Improper Access Control](https://cwe.mitre.org/data/definitions/284.html)
- [Azure SQL Database public network access](https://docs.microsoft.com/en-us/azure/azure-sql/database/connectivity-settings#deny-public-network-access)
- [Azure Private Link for Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/private-endpoint-overview)
- [Azure Database for PostgreSQL private connectivity](https://docs.microsoft.com/en-us/azure/postgresql/concepts-data-access-and-security-private-link)
