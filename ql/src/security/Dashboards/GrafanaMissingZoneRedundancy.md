# Missing zone redundancy in Grafana

This query identifies Microsoft.Dashboard/grafana resources that do not have zone redundancy enabled, which may reduce availability in case of zone failures.

## Description

Azure Managed Grafana instances can be deployed with or without zone redundancy. Zone redundancy provides higher availability by distributing resources across multiple availability zones in a region. When the `zoneRedundancy` property is set to `'Disabled'` or not specified, the Grafana instance is deployed in a single availability zone.

Without zone redundancy, if there is an outage in the availability zone where your Grafana instance is deployed, your monitoring capabilities could be completely lost. This could be particularly problematic during incidents when monitoring is most needed.

## Recommendation

For production environments and any scenarios where high availability is important, enable zone redundancy by setting the `zoneRedundancy` property to `'Enabled'`. This ensures that your Grafana instance can withstand zone failures within a region.

Note that enabling zone redundancy may increase the cost of your Grafana deployment, so evaluate the trade-off between availability and cost based on your specific requirements.

## Example of vulnerable code

```bicep
resource vulnerableGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-single-zone'
  location: 'eastus'
  properties: {
    zoneRedundancy: 'Disabled'  // Vulnerable: Zone redundancy is disabled
  }
  sku: {
    name: 'Standard'
  }
}

// Also vulnerable if zone redundancy is not specified
resource implicitVulnerableGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-single-zone-implicit'
  location: 'eastus'
  properties: {
    // zoneRedundancy not specified, defaults to 'Disabled'
  }
  sku: {
    name: 'Standard'
  }
}
```

## Example of secure code

```bicep
resource secureGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-multi-zone'
  location: 'eastus'
  properties: {
    zoneRedundancy: 'Enabled'  // Secure: Zone redundancy is enabled
  }
  sku: {
    name: 'Standard'
  }
}
```

## References

* [Azure availability zones overview](https://learn.microsoft.com/en-us/azure/availability-zones/az-overview)
* [Azure Managed Grafana documentation](https://learn.microsoft.com/en-us/azure/managed-grafana/)
* [High availability in cloud applications](https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/overview)
