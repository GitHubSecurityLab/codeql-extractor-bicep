/**
 * @name External snapshots enabled in Grafana
 * @description External snapshots in Grafana allow sharing dashboard data with external services,
 *              which could potentially lead to data leakage.
 * @kind problem
 * @problem.severity warning
 * @security-severity 4.0
 * @precision high
 * @id bicep/grafana-external-snapshots-enabled
 * @tags security
 *       bicep
 *       azure
 *       CWE-200
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Dashboards

from Dashboards::GrafanaResource grafana, 
     Dashboards::GrafanaProperties::Properties props,
     Dashboards::GrafanaProperties::GrafanaConfigurations configs,
     Dashboards::GrafanaProperties::Snapshots snapshots
where 
  props = grafana.getProperties() and
  configs = props.getGrafanaConfigurations() and
  snapshots = configs.getSnapshots() and
  snapshots.hasExternalEnabled() and
  snapshots.externalEnabled() = true
select snapshots, 
       "External snapshots are enabled in Grafana configuration, which could lead to " +
       "unintended sharing of dashboard data with external services."
