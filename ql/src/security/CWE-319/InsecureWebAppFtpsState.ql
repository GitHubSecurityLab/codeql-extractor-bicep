/**
 * @name Insecure FTPS state in Web App
 * @description Using insecure FTP or allowing both FTP and FTPS in Azure Web Apps can expose sensitive credentials and data.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id bicep/insecure-webapp-ftps-state
 * @tags security
 *       bicep
 *       azure
 *       CWE-319
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Web

from Web::SitesResource site, Web::SitesProperties::SiteConfig config, StringLiteral ftpsState
where
  config = site.getProperties().getSiteConfig() and
  ftpsState = config.getFtpsState() and
  (
    ftpsState.getValue() = "AllAllowed" or
    ftpsState.getValue() = "FtpOnly"
  )
select site, "Azure Web App allows insecure FTP protocol: " + ftpsState.getValue() + ". Use 'FtpsOnly' or 'Disabled' instead."
