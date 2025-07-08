/**
 * @name Web App without HTTPS-only setting
 * @description Azure Web Apps should enforce HTTPS-only mode to secure communications.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id bicep/sites-without-https-only
 * @tags security
 *       bicep
 *       azure
 *       CWE-319
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Web

from Web::SitesResource site
where
  // Find all sites without httpsOnly set to true
  not site.isHttpsOnly()
select site, "Azure Web App is not configured with HTTPS-only mode, potentially allowing insecure HTTP connections."