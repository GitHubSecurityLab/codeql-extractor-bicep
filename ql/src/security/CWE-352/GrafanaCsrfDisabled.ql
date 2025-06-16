/**
 * @name CSRF protection disabled in Grafana
 * @description CSRF protection is disabled in Grafana configuration, which can lead to 
 *              cross-site request forgery attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision high
 * @id bicep/grafana-csrf-disabled
 * @tags security
 *       bicep
 *       azure
 *       CWE-352
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Dashboards

from Dashboards::GrafanaResource grafana, 
     Dashboards::GrafanaProperties::Properties props,
     Dashboards::GrafanaProperties::GrafanaConfigurations configs,
     Dashboards::GrafanaProperties::Security security
where 
  props = grafana.getProperties() and
  configs = props.getGrafanaConfigurations() and
  security = configs.getSecurity() and
  security.hasCsrfAlwaysCheck() and
  security.csrfAlwaysCheck() = false
select security.getCsrfAlwaysCheck(), 
       "CSRF protection (csrfAlwaysCheck) is explicitly disabled in Grafana configuration, " +
       "which can lead to cross-site request forgery attacks."
