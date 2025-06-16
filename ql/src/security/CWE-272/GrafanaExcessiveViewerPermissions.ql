/**
 * @name Excessive permissions for Grafana viewers
 * @description Granting edit permissions to viewers reduces the effectiveness of access control
 *              and can lead to unauthorized changes to dashboards.
 * @kind problem
 * @problem.severity warning
 * @security-severity 4.0
 * @precision high
 * @id bicep/grafana-excessive-viewer-permissions
 * @tags security
 *       bicep
 *       azure
 *       CWE-272
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Dashboards

from Dashboards::GrafanaResource grafana, 
     Dashboards::GrafanaProperties::Properties props,
     Dashboards::GrafanaProperties::GrafanaConfigurations configs,
     Dashboards::GrafanaProperties::Users users
where 
  props = grafana.getProperties() and
  configs = props.getGrafanaConfigurations() and
  users = configs.getUsers() and
  users.hasViewersCanEdit() and
  users.viewersCanEdit() = true
select users, 
       "Excessive permissions granted to Grafana viewers (viewersCanEdit=true). " +
       "This allows viewers to make temporary edits to dashboards they have access to."
