/**
 * @name Redis Cache without data backup
 * @description Redis Cache with both AOF and RDB backups disabled risks data loss in case of failures.
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

from Expr output, Cache::RedisCacheResource redis, Cache::CacheProperties::RedisConfiguration config
where
  // If the resource doesn't have a Redis configuration, its an issue.
  not exists(redis.getRedisConfiguration()) and
  output = redis.getProperties()
  or
  (
    // We only consider Redis Cache resources that have a configuration.
    config = redis.getRedisConfiguration() and
    // If they don't have any backup enabled, we consider it a risk.
    (
      not config.hasAofBackupEnabled() and
      not config.hasRdbBackupEnabled() and
      output = config
    )
    or
    config.hasAofBackupEnabled() and
    config.aofBackupEnabled() = "false" and
    output = config
    or
    config.hasRdbBackupEnabled() and
    config.rdbBackupEnabled() = "false" and
    output = config
  )
select output,
  "Redis Cache '" + redis.getName() +
    "' has both AOF and RDB backups disabled (or not configured), risking data loss."
