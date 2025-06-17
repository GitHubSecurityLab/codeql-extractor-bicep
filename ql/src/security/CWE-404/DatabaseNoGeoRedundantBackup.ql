/**
 * @name Database without geo-redundant backup
 * @description Database resources without geo-redundant backup enabled may lose data in case of regional disasters.
 * @kind problem
 * @problem.severity warning
 * @security-severity 3.0
 * @precision high
 * @id bicep/database-no-geo-redundant-backup
 * @tags security
 *       bicep
 *       azure
 *       availability
 *       CWE-404
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Databases::Databases

from DatabaseResource db, DatabaseProperties::Backup backup
where 
  backup = db.getProperties().getProperty("backup") and
  (
    not exists(string geoRedundant | geoRedundant = backup.geoRedundantBackup()) or
    backup.geoRedundantBackup() = "Disabled"
  )
select backup,
  "Database '" + db.getName() + "' does not have geo-redundant backup enabled, which may result in data loss during regional disasters."
