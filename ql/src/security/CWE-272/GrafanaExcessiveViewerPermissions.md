# Excessive permissions for Grafana viewers

This query identifies Microsoft.Dashboard/grafana resources that grant edit capabilities to viewer users, which reduces the effectiveness of access control and can lead to unauthorized changes to dashboards.

## Description

Azure Managed Grafana supports different user roles with varying levels of permissions. The `viewersCanEdit` property in the users configuration determines whether users with the viewer role can make temporary edits to dashboards they have access to. When set to `true`, viewers gain more capabilities than they typically should have based on the principle of least privilege.

While these edits are temporary and cannot be saved permanently, it still represents a weakening of the role-based access control model and could lead to confusion, accidental changes, or potential misuse of the dashboard data.

## Recommendation

Follow the principle of least privilege by setting the `viewersCanEdit` property to `false` or omitting it (the default is `false`). If certain users need to make edits to dashboards, consider granting them the editor role instead of giving all viewers edit capabilities.

## Example of vulnerable code

```bicep
resource vulnerableGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-excessive-viewer-perms'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        viewersCanEdit: true  // Vulnerable: Viewers can edit dashboards
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
  name: 'grafana-proper-viewer-perms'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        viewersCanEdit: false  // Secure: Viewers cannot edit dashboards
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Alternative: omit the viewersCanEdit property to use default (false)
resource secureGrafanaAlt 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-default-viewer-perms'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        // viewersCanEdit property omitted (defaults to false)
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}
```

## References

* [Grafana user permissions documentation](https://grafana.com/docs/grafana/latest/administration/user-management/user-roles/)
* [Azure Managed Grafana documentation](https://learn.microsoft.com/en-us/azure/managed-grafana/)
* [CWE-272: Least Privilege Violation](https://cwe.mitre.org/data/definitions/272.html)
* [Principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege)
