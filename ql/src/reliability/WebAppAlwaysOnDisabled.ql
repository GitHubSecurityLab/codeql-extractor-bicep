/**
 * @name Web App without Always On enabled
 * @description Azure Web Apps should have Always On enabled to ensure reliability and security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 4.0
 * @precision high
 * @id bicep/webapp-always-on-disabled
 * @tags security
 *       bicep
 *       azure
 *       reliability
 */

import bicep

from Web::SitesResource site, Web::SitesProperties::SiteConfig config
where
  config = site.getProperties().getSiteConfig() and
  not config.isAlwaysOn() and
  // Only apply to production web apps, not function apps
  site.isWebApp() and
  not site.isFunctionApp()
select site, "Azure Web App doesn't have Always On enabled, which can lead to poor reliability and potential security issues due to cold starts."
