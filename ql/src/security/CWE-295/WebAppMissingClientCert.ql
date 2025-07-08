/**
 * @name Web App without Client Certificate requirement
 * @description Azure Web Apps handling sensitive operations should require client certificates for additional authentication.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision medium
 * @id bicep/webapp-missing-client-cert
 * @tags security
 *       bicep
 *       azure
 *       CWE-295
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Web

from Web::SitesResource site
where
  // Site has HTTPS enabled (showing security awareness)
  site.isHttpsOnly() and
  (
    // But doesn't have client certificate enabled at the site level
    not site.isClientCertEnabled() or
    // Or has it enabled but not set to required in properties
    (
      site.isClientCertEnabled() and
      not site.getProperties().isClientCertRequired()
    )
  )
select site, "Azure Web App with HTTPS enabled doesn't require client certificates for mutual TLS authentication."
