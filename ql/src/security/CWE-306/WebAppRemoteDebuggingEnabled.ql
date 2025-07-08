/**
 * @name Web App with Remote Debugging enabled
 * @description Remote debugging should be disabled in production web apps to prevent unauthorized access.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision high
 * @id bicep/webapp-remote-debugging-enabled
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
select site, "Azure Web App has remote debugging enabled, which can expose sensitive debugging information."
