/**
 * @name Hardcoded SMTP credentials in Grafana configuration
 * @description Hardcoded credentials in Grafana SMTP configuration can lead to credential 
 *              exposure. Use Azure Key Vault references instead.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.0
 * @precision high
 * @id bicep/hardcoded-smtp-credentials
 * @tags security
 *       bicep
 *       azure
 *       CWE-798
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Dashboards

from Dashboards::GrafanaResource grafana, 
     Dashboards::GrafanaProperties::Properties props,
     Dashboards::GrafanaProperties::GrafanaConfigurations configs,
     Dashboards::GrafanaProperties::Smtp smtp,
     StringLiteral password
where 
  props = grafana.getProperties() and
  configs = props.getGrafanaConfigurations() and
  smtp = configs.getSmtp() and
  smtp.hasEnabled() and
  smtp.enabled() = true and
  smtp.hasPassword() and
  password = smtp.getPassword() and
  // Exclude passwords that appear to be using key vault references
  not password.getValue().matches("@Microsoft.KeyVault(%")
select password, 
       "Hardcoded SMTP password in Grafana configuration. Use Azure Key Vault references instead."
