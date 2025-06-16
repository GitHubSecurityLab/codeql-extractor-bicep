/**
 * @name Redis Cache without AAD authentication
 * @description Redis Cache using only access keys instead of Azure Active Directory authentication has weaker security controls.
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 2.0
 * @precision high
 * @id bicep/redis-cache-no-aad
 * @tags security
 *       bicep
 *       azure
 *       CWE-798
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Cache

from Cache::RedisCacheResource redis, Cache::CacheProperties::RedisConfiguration config
where 
  config = redis.getRedisConfiguration() and
  (
    not exists(string aadEnabled | aadEnabled = config.aadEnabled()) or
    config.aadEnabled() != "true"
  )
select redis,
  "Redis Cache '" + redis.getName() + "' is not using Azure Active Directory (AAD) authentication."
