# Grafana API key enabled

This query identifies Microsoft.Dashboard/grafana resources that have the API key feature enabled, which can increase the attack surface and lead to unauthorized access if keys are not properly managed.

## Description

Azure Managed Grafana allows users to create API keys that can be used to authenticate API requests. When the `apiKey` property is set to `'Enabled'`, users can generate these keys through the Grafana UI.

While API keys can be useful for automation and integration scenarios, they also increase the security risk. API keys can have broad permissions and, if compromised, could allow attackers to access or modify dashboards, query data sources, or perform administrative actions. Additionally, API keys often don't have the same level of auditing and monitoring as user accounts.

## Recommendation

Unless API keys are specifically required for your use case, disable them by setting the `apiKey` property to `'Disabled'`. If you do need to use API keys:

1. Grant the minimum required permissions to each key
2. Regularly rotate keys
3. Use shorter expiration times
4. Implement monitoring for API key usage

Consider using service principals or OAuth2 for service-to-service authentication instead of API keys when possible.

## Example of vulnerable code

```bicep
resource vulnerableGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-api-keys-enabled'
  location: 'eastus'
  properties: {
    apiKey: 'Enabled'  // Vulnerable: API keys are enabled
  }
  sku: {
    name: 'Standard'
  }
}
```

## Example of secure code

```bicep
resource secureGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-api-keys-disabled'
  location: 'eastus'
  properties: {
    apiKey: 'Disabled'  // Secure: API keys are disabled
  }
  sku: {
    name: 'Standard'
  }
}

// Alternative: omit the apiKey property if it defaults to 'Disabled'
resource secureGrafanaAlt 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-default-api-keys'
  location: 'eastus'
  properties: {
    // apiKey property omitted
  }
  sku: {
    name: 'Standard'
  }
}
```

## References

* [Grafana API keys documentation](https://grafana.com/docs/grafana/latest/administration/api-keys/)
* [Azure Managed Grafana documentation](https://learn.microsoft.com/en-us/azure/managed-grafana/)
* [CWE-306: Missing Authentication for Critical Function](https://cwe.mitre.org/data/definitions/306.html)
* [OWASP API Security Top 10: Broken Authentication](https://owasp.org/www-project-api-security/)
