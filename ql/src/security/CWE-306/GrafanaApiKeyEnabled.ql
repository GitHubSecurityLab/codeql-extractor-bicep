/**
 * @name Grafana API key enabled
 * @description Enabling API keys in Grafana can increase the attack surface and lead to 
 *              unauthorized access if keys are not properly managed.
 * @kind problem
 * @problem.severity warning
 * @security-severity 4.5
 * @precision high
 * @id bicep/grafana-api-key-enabled
 * @tags security
 *       bicep
 *       azure
 *       CWE-306
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Dashboards

from Dashboards::GrafanaResource grafana, 
     Dashboards::GrafanaProperties::Properties props
where 
  props = grafana.getProperties() and
  props.hasApiKey() and
  props.apiKey() = "Enabled"
select props.getApiKey(), 
       "Grafana API key feature is enabled, which can increase the attack surface. " +
       "Consider disabling API keys if not strictly necessary."
