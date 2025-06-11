resource redisCache 'Microsoft.Cache/Redis@2023-04-01' = {
  name: 'myRedisCache'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    family: 'C'
    capacity: 1
  }
  properties: {
    enableNonSslPort: false
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    redisConfiguration: {
      maxmemory-policy: 'allkeys-lru'
    }
  }
}