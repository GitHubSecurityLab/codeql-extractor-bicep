/**
 * @name Redis Cache with unsafe memory policy
 * @description Redis Cache with certain memory policies may delete data unexpectedly in production.
 * @kind problem
 * @problem.severity warning
 * @security-severity 4.0
 * @precision high
 * @id bicep/redis-cache-unsafe-memory-policy
 * @tags security
 *       bicep
 *       azure
 *       CWE-400
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Cache

from Cache::RedisCacheResource redis, Cache::CacheProperties::RedisConfiguration config, string unsafePolicy
where 
  config = redis.getRedisConfiguration() and
  unsafePolicy = config.maxMemoryPolicy() and
  unsafePolicy in ["allkeys-lru", "allkeys-random", "volatile-lru", "volatile-random", "volatile-ttl"]
select redis,
  "Redis Cache '" + redis.getName() + "' uses potentially unsafe memory policy '" + unsafePolicy + "' which may cause unexpected data loss."
