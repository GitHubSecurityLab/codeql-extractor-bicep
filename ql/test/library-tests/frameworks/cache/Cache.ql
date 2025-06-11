import bicep

query predicate cache(Cache::CacheResource cache) { any() }

query predicate cacheConfig(
  Cache::RedisCacheResource cache, Cache::CacheProperties::RedisConfiguration config
) {
  cache.getRedisConfiguration() = config
}
