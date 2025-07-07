/**
 * @name Insecure TLS version in Web App
 * @description Using an insecure TLS version in an Azure Web App may lead to security vulnerabilities.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.1
 * @precision high
 * @id bicep/insecure-webapp-tls-version
 * @tags security
 *       bicep
 *       azure
 *       CWE-319
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Web

from Web::SitesResource site, Web::SitesProperties::SiteConfig config, StringLiteral tlsVersion
where
  config = site.getProperties().getSiteConfig() and
  tlsVersion = config.getMinTlsVersion() and
  (
    tlsVersion.getValue() = "1.0" or
    tlsVersion.getValue() = "1.1"
  )
select site, "Azure Web App configured with insecure TLS version: " + tlsVersion.getValue()
