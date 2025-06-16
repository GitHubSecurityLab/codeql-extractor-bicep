/**
 * @name Redis Cache with public network access enabled
 * @description Redis Cache resources with public network access enabled are exposed to the internet and potential attackers.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id bicep/redis-cache-public-network
 * @tags security
 *       bicep
 *       azure
 *       CWE-284
 */

import bicep
import codeql.bicep.Concepts
import codeql.bicep.frameworks.Microsoft.Cache

from Cache::PublicRedisCacheResource publicRedis
select publicRedis,
  "Redis Cache '" + publicRedis.(Resource).getName() + "' has public network access enabled, exposing it to the internet."
