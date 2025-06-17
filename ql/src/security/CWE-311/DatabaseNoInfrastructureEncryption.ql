/**
 * @name Database without infrastructure encryption
 * @description Database resources without infrastructure encryption enabled may expose data to unauthorized access at the infrastructure level.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id bicep/database-no-infrastructure-encryption
 * @tags security
 *       bicep
 *       azure
 *       encryption
 *       CWE-311
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Databases::Databases

from DatabaseResource db
where 
  (
    not exists(string encryption | encryption = db.infrastructureEncryption()) or
    db.infrastructureEncryption() = "Disabled"
  )
select db,
  "Database '" + db.getName() + "' does not have infrastructure encryption enabled, which may expose data at the infrastructure level."
