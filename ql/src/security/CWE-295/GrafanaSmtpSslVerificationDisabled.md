# Grafana SMTP SSL verification disabled

This query identifies Microsoft.Dashboard/grafana resources that have SSL verification disabled in their SMTP configuration, which can lead to man-in-the-middle attacks and compromise of email communications.

## Description

Azure Managed Grafana can be configured to send email notifications using SMTP. The `skipVerify` property in the SMTP configuration controls whether the SSL/TLS certificate of the SMTP server is verified. When set to `true`, the certificate validation is disabled, which means the Grafana instance will not verify the identity of the SMTP server. This creates a security vulnerability where an attacker could potentially intercept email communications through a man-in-the-middle attack.

## Recommendation

Always set the `skipVerify` property to `false` (or omit it, as `false` is the default) in your Grafana SMTP configuration. This ensures that the SSL/TLS certificate of the SMTP server is properly validated, protecting against man-in-the-middle attacks.

## Example of vulnerable code

```bicep
resource vulnerableGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-insecure-smtp'
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
        skipVerify: true  // Vulnerable: SSL verification is disabled
        startTLSPolicy: 'MandatoryStartTLS'
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
resource secureGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-secure-smtp'
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

// Alternative: omit skipVerify as false is the default
resource secureGrafanaAlt 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-secure-smtp-alt'
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
        // skipVerify property is omitted (defaults to false)
        startTLSPolicy: 'MandatoryStartTLS'
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}
```

## References

* [Grafana SMTP configuration documentation](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#smtp)
* [Azure Managed Grafana documentation](https://learn.microsoft.com/en-us/azure/managed-grafana/)
* [CWE-295: Improper Certificate Validation](https://cwe.mitre.org/data/definitions/295.html)
