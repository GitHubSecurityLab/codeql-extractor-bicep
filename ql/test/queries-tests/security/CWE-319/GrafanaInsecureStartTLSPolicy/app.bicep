// Test file for GrafanaInsecureStartTLSPolicy.ql
// Contains examples of secure and insecure configurations

// TEST CASE: Insecure - Grafana with NoStartTLS policy
// This should be detected by the query
resource insecureGrafanaNoStartTLS 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'insecure-grafana-no-starttls'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        startTLSPolicy: 'NoStartTLS'  // ALERT: No StartTLS policy (insecure)
        host: 'smtp.example.com'
        port: 25
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Insecure - Grafana with OpportunisticStartTLS policy
// This should be detected by the query
resource insecureGrafanaOpportunisticStartTLS 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'insecure-grafana-opportunistic-starttls'
  location: 'westeurope'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        startTLSPolicy: 'OpportunisticStartTLS'  // ALERT: Opportunistic StartTLS policy (insecure)
        host: 'smtp.example.com'
        port: 587
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with MandatoryStartTLS policy
// This should NOT be detected by the query
resource secureGrafanaMandatoryStartTLS 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-mandatory-starttls'
  location: 'centralus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        startTLSPolicy: 'MandatoryStartTLS'  // Secure: Mandatory StartTLS policy
        host: 'smtp.example.com'
        port: 587
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with SMTP disabled
// This should NOT be detected by the query
resource secureGrafanaSmtpDisabled 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-smtp-disabled'
  location: 'westus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: false
        startTLSPolicy: 'NoStartTLS'  // Not a security issue because SMTP is disabled
        host: 'smtp.example.com'
        port: 25
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// TEST CASE: Secure - Grafana with no SMTP configuration
// This should NOT be detected by the query
resource secureGrafanaNoSmtp 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'secure-grafana-no-smtp'
  location: 'eastus2'
  properties: {
    grafanaConfigurations: {
      // No SMTP configuration
    }
  }
  sku: {
    name: 'Standard'
  }
}
