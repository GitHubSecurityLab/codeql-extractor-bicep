/**
 * @name CosmosDB without backup policy
 * @description CosmosDB accounts without a proper backup policy configured may lose data permanently.
 * @kind problem
 * @problem.severity warning
 * @security-severity 4.0
 * @precision high
 * @id bicep/cosmosdb-no-backup-policy
 * @tags security
 *       bicep
 *       azure
 *       availability
 *       CWE-404
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Databases::Databases

from CosmosDBAccounts cosmosdb
where 
  not exists(DatabaseProperties::BackupPolicy policy | policy = cosmosdb.getBackupPolicy())
select cosmosdb,
  "CosmosDB account '" + cosmosdb.getName() + "' does not have a backup policy configured, which may result in data loss."
