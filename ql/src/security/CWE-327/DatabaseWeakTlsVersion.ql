/**
 * @name Database with weak TLS version
 * @description Database resources configured with weak TLS versions are vulnerable to cryptographic attacks.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id bicep/database-weak-tls-version
 * @tags security
 *       bicep
 *       azure
 *       cryptography
 *       CWE-327
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Databases::Databases

from DatabaseResource db, string version
where 
  version = db.minimalTlsVersion() and
  (
    version = "1.0" or 
    version = "1.1" or
    version.regexpMatch("^TLS[_]?1[._][01]$")
  )
select db.getMinimalTlsVersion(),
  "Database '" + db.getName() + "' is configured with weak TLS version '" + version + "'. Use TLS 1.2 or higher."
