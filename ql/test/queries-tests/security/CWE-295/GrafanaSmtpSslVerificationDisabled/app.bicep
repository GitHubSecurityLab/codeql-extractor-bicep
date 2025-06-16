// Test file for GrafanaSmtpSslVerificationDisabled.ql
// Contains examples of secure and insecure configurations

// TEST CASE: Insecure - Grafana with SMTP SSL verification disabled
// This should be detected by the query
resource insecureGrafanaSmtp 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'insecure-grafana-smtp'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        host: 'smtp.example.com:587'
        user: 'grafanauser'
        password: 'password123'
        fromAddress: 'grafana@example.com'
        fromName: 'Grafana Alerts'
        skipVerify: true  // ALERT: SSL verification is disabled
        startTLSPolicy: 'MandatoryStartTLS'
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with SMTP SSL verification enabled
// This should NOT be detected by the query
resource secureGrafanaSmtp 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-smtp'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        host: 'smtp.example.com:587'
        user: 'grafanauser'
        password: 'password123'
        fromAddress: 'grafana@example.com'
        fromName: 'Grafana Alerts'
        skipVerify: false  // Secure: SSL verification is enabled
        startTLSPolicy: 'MandatoryStartTLS'
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with SMTP but no skipVerify setting (should default to false)
// This should NOT be detected by the query
resource defaultSecureGrafanaSmtp 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'default-grafana-smtp'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        host: 'smtp.example.com:587'
        user: 'grafanauser'
        password: 'password123'
        fromAddress: 'grafana@example.com'
        fromName: 'Grafana Alerts'
        // skipVerify not set, defaults to false
        startTLSPolicy: 'MandatoryStartTLS'
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Edge case - Grafana with SMTP disabled
// This should NOT be detected by the query even though skipVerify is true
resource disabledSmtpGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'disabled-smtp-grafana'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: false
        skipVerify: true  // This shouldn't trigger the alert because SMTP is disabled
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}
