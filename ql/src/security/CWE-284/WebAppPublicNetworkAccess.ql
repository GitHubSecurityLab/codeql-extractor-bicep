/**
 * @name Web App with unrestricted public access
 * @description Azure Web Apps should restrict public network access to enhance security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision high
 * @id bicep/sites-public-network-access
 * @tags security
 *       bicep
 *       azure
 *       CWE-284
 */

import bicep
import codeql.bicep.frameworks.Microsoft.Web

from Web::SitesResource site, Web::SitesProperties::Properties props
where
  props = site.getProperties() and
  // Check if the site has public network access enabled (default) and no VNet integration
  props.isPublicNetworkAccessEnabled() and
  not exists(StringLiteral vnetSubnetId |
    vnetSubnetId = site.getVirtualNetworkSubnetId() or
    vnetSubnetId = props.getVirtualNetworkSubnetId()
  )
select site, "Azure Web App has unrestricted public network access without VNet integration, potentially increasing attack surface."
