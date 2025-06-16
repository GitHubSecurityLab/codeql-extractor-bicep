# CSRF protection disabled in Grafana

This query identifies Microsoft.Dashboard/grafana resources that have Cross-Site Request Forgery (CSRF) protection explicitly disabled, which can lead to CSRF attacks.

## Description

Cross-Site Request Forgery (CSRF) is a type of attack that tricks a user's browser into executing unwanted actions on a web application in which the user is authenticated. The `csrfAlwaysCheck` property in Grafana's security configuration determines whether CSRF checks are always performed, even if the login cookie is not present in a request.

When `csrfAlwaysCheck` is set to `false`, CSRF checks may be skipped in certain scenarios, potentially leaving the Grafana instance vulnerable to CSRF attacks. This could allow an attacker to perform unauthorized actions on behalf of authenticated users.

## Recommendation

Always enable CSRF protection by either setting the `csrfAlwaysCheck` property to `true` or by omitting it (the default value is `false`, but Grafana still performs CSRF checks in most cases). If you're experiencing issues with legitimate requests being blocked, investigate the specific issue rather than disabling CSRF protection entirely.

## Example of vulnerable code

```bicep
resource vulnerableGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-csrf-disabled'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      security: {
        csrfAlwaysCheck: false  // Vulnerable: CSRF protection explicitly disabled
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
  name: 'grafana-csrf-enabled'
  location: 'eastus'
  properties: {
    grafanaConfigurations: {
      security: {
        csrfAlwaysCheck: true  // Secure: CSRF protection always enabled
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Alternative: omit the security block entirely to use defaults
resource secureGrafanaAlt 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'grafana-default-security'
  location: 'eastus'
  properties: {
    // No explicit security configuration, using Grafana defaults
  }
  sku: {
    name: 'Standard'
  }
}
```

## References

* [Grafana security configuration documentation](https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/)
* [Azure Managed Grafana documentation](https://learn.microsoft.com/en-us/azure/managed-grafana/)
* [CWE-352: Cross-Site Request Forgery (CSRF)](https://cwe.mitre.org/data/definitions/352.html)
* [OWASP Cross-Site Request Forgery Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
