# External snapshots enabled in Grafana

This query identifies Microsoft.Dashboard/grafana resources that have external snapshots enabled, which could potentially lead to data leakage.

## Description

Grafana allows users to create and share snapshots of dashboards. When the `externalEnabled` property in the snapshots configuration is set to `true`, users can publish these snapshots to an external, public snapshot server. This means that dashboard data, which may include sensitive metrics or information, could be shared outside of your organization.

External snapshots are stored on a public server provided by Grafana Labs, and anyone with the link can view the snapshot. This creates a risk of sensitive data exposure if users inadvertently share snapshots containing confidential information.

## Recommendation

Unless external snapshots are specifically required for your use case, disable external snapshots by setting the `externalEnabled` property to `false`. This ensures that snapshots can only be shared internally within your Grafana instance, reducing the risk of accidental data leakage.

## Example of vulnerable code

```bicep
resource vulnerableGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-external-snapshots'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      snapshots: {
        externalEnabled: true  // Vulnerable: External snapshots are enabled
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
  name: 'grafana-internal-snapshots'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      snapshots: {
        externalEnabled: false  // Secure: External snapshots are disabled
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Alternative: omit the snapshots configuration block entirely to use default settings
resource secureGrafanaAlt 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-default-snapshots'
  location: 'eastus'
  properties: {
    // No explicit snapshots configuration, using defaults
  }
  sku: {
    name: 'Standard'
  }
}
```

## References

* [Grafana snapshot documentation](https://grafana.com/docs/grafana/latest/dashboards/share-dashboards-panels/#publish-a-snapshot)
* [Azure Managed Grafana documentation](https://learn.microsoft.com/en-us/azure/managed-grafana/)
* [CWE-200: Exposure of Sensitive Information to an Unauthorized Actor](https://cwe.mitre.org/data/definitions/200.html)
