/**
 * @name Excessive permissions for Grafana editors
 * @description Granting admin permissions to editors reduces the effectiveness of access control
 *              and can lead to privilege escalation.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id bicep/grafana-excessive-editor-permissions
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
  users.hasEditorsCanAdmin() and
  users.editorsCanAdmin() = true
select users, 
       "Excessive permissions granted to Grafana editors (editorsCanAdmin=true). " +
       "This allows editors to administrate dashboards, folders and teams they create."
