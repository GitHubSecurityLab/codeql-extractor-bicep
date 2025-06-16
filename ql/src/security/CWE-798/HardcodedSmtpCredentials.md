# Hardcoded SMTP credentials in Grafana configuration

This query identifies Microsoft.Dashboard/grafana resources that have hardcoded SMTP credentials in their configuration, which could lead to credential exposure and unauthorized access.

## Description

Azure Managed Grafana can be configured to send email notifications using SMTP. When SMTP credentials are hardcoded in Bicep templates, they could be exposed to unauthorized individuals through source code repositories, logs, or other means. This is especially problematic when the templates are stored in version control systems.

Hardcoded credentials create a security risk since they cannot be easily rotated or managed securely. If the credentials are compromised, an attacker could gain access to the SMTP server and potentially use it to send malicious emails.

## Recommendation

Instead of hardcoding SMTP credentials directly in Bicep templates, use Azure Key Vault references or parameters with secure string types. This approach allows credentials to be stored securely in Azure Key Vault and referenced in your deployments without exposing them in the template files.

## Example of vulnerable code

```bicep
resource vulnerableGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-insecure-credentials'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        host: 'smtp.example.com:587'
        user: 'grafanauser'
        password: 'SuperSecretPassword123!'  // Vulnerable: Hardcoded credentials
        fromAddress: 'grafana@example.com'
        fromName: 'Grafana Alerts'
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}
```

## Example of secure code

```bicep
@description('The name of the key vault containing the SMTP password')
param keyVaultName string

@description('The name of the secret containing the SMTP password')
param smtpPasswordSecretName string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
  scope: resourceGroup()
}

resource secureGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-secure-credentials'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        host: 'smtp.example.com:587'
        user: 'grafanauser'
        password: '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}secrets/${smtpPasswordSecretName})'  // Secure: Using Key Vault reference
        fromAddress: 'grafana@example.com'
        fromName: 'Grafana Alerts'
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Alternative: using a parameter with secureString
@description('SMTP password for Grafana')
@secure()
param smtpPassword string

resource secureGrafanaAlt 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-secure-credentials-alt'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        host: 'smtp.example.com:587'
        user: 'grafanauser'
        password: smtpPassword  // Secure: Using secure parameter
        fromAddress: 'grafana@example.com'
        fromName: 'Grafana Alerts'
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}
```

## References

* [Azure Key Vault integration with ARM templates](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/key-vault-parameter)
* [Azure Managed Grafana documentation](https://learn.microsoft.com/en-us/azure/managed-grafana/)
* [CWE-798: Use of Hard-coded Credentials](https://cwe.mitre.org/data/definitions/798.html)
