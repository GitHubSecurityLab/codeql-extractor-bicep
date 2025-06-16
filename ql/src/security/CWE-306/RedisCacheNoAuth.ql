/**
 * @name Redis Cache with authentication disabled
 * @description Redis Cache with authentication disabled allows anyone with network access to connect to the cache.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id bicep/redis-cache-no-auth
 * @tags security
 *       bicep
 *       azure
 *       CWE-306
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Cache

from Cache::RedisCacheResource redis, Cache::CacheProperties::RedisConfiguration config
where 
  config = redis.getRedisConfiguration() and
  config.authNotRequired() = "true"
select redis,
  "Redis Cache '" + redis.getName() + "' has authentication disabled, allowing unauthenticated access."
