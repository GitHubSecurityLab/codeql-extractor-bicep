/**
 * @name Redis Cache without data backup
 * @description Redis Cache without data backup configuration risks data loss in case of failures.
 * @kind problem
 * @problem.severity warning
 * @security-severity 3.5
 * @precision high
 * @id bicep/redis-cache-no-backup
 * @tags security
 *       bicep
 *       azure
 *       CWE-693
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Cache

from Cache::RedisCacheResource redis, Cache::CacheProperties::RedisConfiguration config 
where 
  config = redis.getRedisConfiguration() and
  (
    not exists(string aofBackupEnabled | aofBackupEnabled = config.aofBackupEnabled()) and
    not exists(string rdbBackupEnabled | rdbBackupEnabled = config.rdbBackupEnabled())
  )
select redis,
  "Redis Cache '" + redis.getName() + "' does not have either AOF or RDB backups enabled, risking data loss."
