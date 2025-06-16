/**
 * @name Missing zone redundancy in Grafana
 * @description Grafana instances without zone redundancy enabled may have reduced availability in
 *              case of zone failures.
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 3.0
 * @precision high
 * @id bicep/grafana-missing-zone-redundancy
 * @tags security
 *       bicep
 *       azure
 *       availability
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Dashboards

from Dashboards::GrafanaResource grafana, 
     Dashboards::GrafanaProperties::Properties props
where 
  props = grafana.getProperties() and
  (
    not props.hasZoneRedundancy() or
    props.zoneRedundancy() = "Disabled"
  )
select props.getZoneRedundancy(), 
       "Grafana instance is configured without zone redundancy, which may reduce availability " +
       "in case of zone failures."
