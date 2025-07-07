/**
 * @name Remote debugging enabled in Web App
 * @description Enabling remote debugging in production Azure Web Apps is a security risk.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id bicep/webapp-remote-debugging
 * @tags security
 *       bicep
 *       azure
 *       CWE-306
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Web

from Web::SitesResource site, Web::SitesProperties::SiteConfig config
where
  config = site.getProperties().getSiteConfig() and
  config.isRemoteDebuggingEnabled()
select site, "Azure Web App has remote debugging enabled, which should not be used in production environments"
