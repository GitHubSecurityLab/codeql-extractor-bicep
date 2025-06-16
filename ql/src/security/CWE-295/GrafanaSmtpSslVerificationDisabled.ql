/**
 * @name Grafana SMTP SSL verification disabled
 * @description Disabling SSL verification in Grafana SMTP configuration can lead to man-in-the-middle
 *              attacks and compromise of email communications.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.5
 * @precision high
 * @id bicep/grafana-smtp-ssl-verification-disabled
 * @tags security
 *       bicep
 *       azure
 *       CWE-295
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Dashboards

from Dashboards::GrafanaResource grafana, 
     Dashboards::GrafanaProperties::Properties props,
     Dashboards::GrafanaProperties::GrafanaConfigurations configs,
     Dashboards::GrafanaProperties::Smtp smtp
where 
  props = grafana.getProperties() and
  configs = props.getGrafanaConfigurations() and
  smtp = configs.getSmtp() and
  smtp.hasEnabled() and
  smtp.enabled() = true and
  smtp.hasSkipVerify() and
  smtp.skipVerify() = true
select smtp.getSkipVerify(), 
       "Grafana SMTP configuration has SSL verification disabled (skipVerify=true), " +
       "which can lead to man-in-the-middle attacks."
