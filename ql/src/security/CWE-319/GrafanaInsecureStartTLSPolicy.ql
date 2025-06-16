/**
 * @name Insecure StartTLS policy in Grafana SMTP configuration
 * @description Using 'NoStartTLS' or 'OpportunisticStartTLS' in Grafana SMTP configuration 
 *              can lead to email communications being sent unencrypted.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.5
 * @precision high
 * @id bicep/grafana-insecure-starttls-policy
 * @tags security
 *       bicep
 *       azure
 *       CWE-319
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Dashboards

from Dashboards::GrafanaResource grafana, 
     Dashboards::GrafanaProperties::Properties props,
     Dashboards::GrafanaProperties::GrafanaConfigurations configs,
     Dashboards::GrafanaProperties::Smtp smtp,
     StringLiteral startTLSPolicy
where 
  props = grafana.getProperties() and
  configs = props.getGrafanaConfigurations() and
  smtp = configs.getSmtp() and
  smtp.hasEnabled() and
  smtp.enabled() = true and
  smtp.hasStartTLSPolicy() and
  startTLSPolicy = smtp.getStartTLSPolicy() and
  (
    startTLSPolicy.getValue() = "NoStartTLS" or
    startTLSPolicy.getValue() = "OpportunisticStartTLS"
  )
select startTLSPolicy, 
       "Insecure StartTLS policy '" + startTLSPolicy.getValue() + "' configured in Grafana SMTP settings. " +
       "This may allow email communications to be sent unencrypted. Use 'MandatoryStartTLS' instead."
