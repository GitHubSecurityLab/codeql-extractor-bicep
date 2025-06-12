import bicep

query predicate cache(Cache::CacheResource cache) { any() }

query predicate cacheProps(Cache::RedisCacheResource cache, Cache::CacheProperties::Properties props) {
  cache.getProperties() = props
}

query predicate cacheConfig(
  Cache::RedisCacheResource cache, Cache::CacheProperties::RedisConfiguration config
) {
  cache.getRedisConfiguration() = config
}
