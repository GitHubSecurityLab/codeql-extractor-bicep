# Insecure StartTLS policy in Grafana SMTP configuration

This query identifies Microsoft.Dashboard/grafana resources that use insecure StartTLS policies (`'NoStartTLS'` or `'OpportunisticStartTLS'`) in their SMTP configuration, which can lead to email communications being sent unencrypted.

## Description

Azure Managed Grafana can be configured to send email notifications using SMTP. The `startTLSPolicy` property in the SMTP configuration determines how the TLS encryption is handled when communicating with the SMTP server. There are three possible values:

- `'MandatoryStartTLS'`: Always uses TLS encryption; fails if the server doesn't support TLS
- `'OpportunisticStartTLS'`: Uses TLS encryption if the server supports it, falls back to unencrypted if not
- `'NoStartTLS'`: Never uses TLS encryption, always communicates in plain text

When set to `'NoStartTLS'` or `'OpportunisticStartTLS'`, there's a risk that email communications, which may contain sensitive information such as alert details, dashboard links, or system information, could be transmitted in plain text. This makes them susceptible to interception and eavesdropping.

## Recommendation

Always use the most secure StartTLS policy, `'MandatoryStartTLS'`, to ensure that all SMTP communications are encrypted. This ensures that if the SMTP server doesn't support TLS, the connection will fail rather than falling back to an insecure connection.

If you encounter issues with an SMTP server that doesn't support TLS, consider switching to a more secure email service provider rather than weakening your security posture.

## Example of vulnerable code

```bicep
resource vulnerableGrafanaNoTLS 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-no-tls'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        host: 'smtp.example.com:587'
        user: 'grafanauser'
        password: 'password123'
        startTLSPolicy: 'NoStartTLS'  // Vulnerable: No TLS encryption used
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

resource vulnerableGrafanaOpportunisticTLS 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-opportunistic-tls'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        host: 'smtp.example.com:587'
        user: 'grafanauser'
        password: 'password123'
        startTLSPolicy: 'OpportunisticStartTLS'  // Vulnerable: May fall back to unencrypted connection
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
  name: 'grafana-mandatory-tls'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        host: 'smtp.example.com:587'
        user: 'grafanauser'
        password: 'password123'
        startTLSPolicy: 'MandatoryStartTLS'  // Secure: Always uses TLS encryption
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
* [CWE-319: Cleartext Transmission of Sensitive Information](https://cwe.mitre.org/data/definitions/319.html)
* [StartTLS explained](https://en.wikipedia.org/wiki/Opportunistic_TLS)
