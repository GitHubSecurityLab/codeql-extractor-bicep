/**
 * @name Database without SSL enforcement
 * @description Database resources with SSL enforcement disabled allow unencrypted connections, exposing data in transit.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.0
 * @precision high
 * @id bicep/database-ssl-not-enforced
 * @tags security
 *       bicep
 *       azure
 *       cryptography
 *       CWE-319
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Databases::Databases

from DatabaseResource db
where 
  db.sslEnforcement() = "Disabled"
select db.getSslEnforcement(),
  "Database '" + db.getName() + "' has SSL enforcement disabled, allowing unencrypted connections that may expose data in transit."
