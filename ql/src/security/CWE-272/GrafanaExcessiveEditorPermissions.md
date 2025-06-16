# Excessive permissions for Grafana editors

This query identifies Microsoft.Dashboard/grafana resources that grant administrative capabilities to editor users, which reduces the effectiveness of access control and can lead to privilege escalation.

## Description

Azure Managed Grafana supports different user roles with varying levels of permissions. The `editorsCanAdmin` property in the users configuration determines whether users with the editor role can administrate dashboards, folders, and teams they create. When set to `true`, editors gain administrative capabilities that go beyond their standard role, potentially violating the principle of least privilege.

This configuration can lead to unintended privilege escalation, where editors gain more control over the Grafana instance than intended. It could result in unauthorized access to sensitive data, changes to important dashboards, or modifications to team permissions.

## Recommendation

Follow the principle of least privilege by setting the `editorsCanAdmin` property to `false` or omitting it (the default is `false`). If certain users need administrative capabilities, consider granting them the admin role instead of elevating all editors' permissions.

## Example of vulnerable code

```bicep
resource vulnerableGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-excessive-editor-perms'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        editorsCanAdmin: true  // Vulnerable: Editors have admin capabilities
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
  name: 'grafana-proper-editor-perms'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        editorsCanAdmin: false  // Secure: Editors do not have admin capabilities
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Alternative: omit the editorsCanAdmin property to use default (false)
resource secureGrafanaAlt 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-default-editor-perms'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      users: {
        // editorsCanAdmin property omitted (defaults to false)
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
