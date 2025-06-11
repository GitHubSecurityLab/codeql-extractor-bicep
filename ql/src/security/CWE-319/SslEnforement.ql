/**
 * @name SSL / TLS not Enforced
 * @description SSL / TLS should be enforced on resources to ensure secure communication.
 * @kind problem
 * @problem.severity error
 * @security-severity 6.0
 * @precision high
 * @id bicep/ssl-enforcement-disabled
 * @tags security
 *       bicep
 *       azure
 *       cryptography
 */


import bicep
import codeql.bicep.frameworks.Microsoft.Databases::Databases

from DatabaseResource db
where db.sslEnforcement() = "Disabled"
select db.getSslEnforcement(),
  "SSL / TLS is not enforced on the database resource '" + db.getName() + "'."
