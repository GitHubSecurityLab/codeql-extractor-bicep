// Test file for HardcodedSmtpCredentials.ql
// Contains examples of secure and insecure configurations

// Parameters for secure implementation
@description('The name of the key vault containing the SMTP password')
param keyVaultName string = 'myKeyVault'

@description('The name of the secret containing the SMTP password')
param smtpPasswordSecretName string = 'smtpPassword'

@description('SMTP password for Grafana')
@secure()
param smtpPasswordParam string

// TEST CASE: Insecure - Grafana with hardcoded SMTP credentials
// This should be detected by the query
resource insecureGrafanaCredentials 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'insecure-grafana-credentials'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        host: 'smtp.example.com:587'
        user: 'grafanauser'
        password: 'SuperS3cr3tP@ssw0rd!'  // ALERT: Hardcoded credentials
        fromAddress: 'grafana@example.com'
        fromName: 'Grafana Alerts'
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Mock Key Vault resource for reference
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
  scope: resourceGroup()
}

// TEST CASE: Secure - Grafana with Key Vault reference for SMTP credentials
// This should NOT be detected by the query
resource secureGrafanaWithKeyVault 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-keyvault'
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

// TEST CASE: Secure - Grafana using parameter with secureString type
// This should NOT be detected by the query
resource secureGrafanaWithParam 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-param'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        host: 'smtp.example.com:587'
        user: 'grafanauser'
        password: smtpPasswordParam  // Secure: Using secure parameter
        fromAddress: 'grafana@example.com'
        fromName: 'Grafana Alerts'
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}
