/**
 * @name Redis Cache with non-SSL port enabled
 * @description Enabling non-SSL port for Redis Cache allows unencrypted connections, potentially exposing sensitive data.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id bicep/redis-cache-non-ssl-port
 * @tags security
 *       bicep
 *       azure
 *       CWE-319
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Cache

from Cache::RedisCacheResource redis
where redis.enableNonSslPort() = true
select redis,
  "Redis Cache '" + redis.getName() + "' has non-SSL port enabled, which allows unencrypted connections."
