/**
 * @name Database with public network access enabled
 * @description Database resources with public network access enabled are accessible from the internet, increasing the attack surface.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision high
 * @id bicep/database-public-network-access
 * @tags security
 *       bicep
 *       azure
 *       CWE-284
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Databases::Databases

from DatabaseResource db
where 
  db.publicNetworkAccess() = "Enabled"
select db.getPublicNetworkAccess(),
  "Database '" + db.getName() + "' has public network access enabled, making it accessible from the internet."
