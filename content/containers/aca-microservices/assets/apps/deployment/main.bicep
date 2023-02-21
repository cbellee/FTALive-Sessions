param location string
param tag string
param acrName string
param pubAppName string
param pubAppPort string
param subAppName string
param subAppPort string
param pubSubName string
param topicName string
param deployServiceBus bool = false

module aca_env 'modules/aca-env.bicep' = {
  name: 'aca-env-module'
  params: {
    location: location
  }
}

module redis 'modules/redis.bicep' = {
  name: 'redis-module'
  params: {
    location: location
  }
}

module sbus 'modules/sbus.bicep' = {
  name: 'sbus-module'
  params: {
    location: location
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: acrName
}

module aca_dapr_redis './modules/aca-dapr-redis.bicep' = if (!deployServiceBus) {
  name: 'aca-dapr-redis-module'
  params: {
    acaEnvName: aca_env.outputs.name
    acrName: acr.name
    location: location
    pubAppName: pubAppName
    pubAppPort: pubAppPort
    pubSubName: pubSubName
    pubSubTopic: topicName
    redisName: redis.outputs.name
    subAppName: subAppName
    subAppPort: subAppPort
    tag: tag
  }
}

module aca_dapr_redis_component './modules/aca-dapr-redis-component.bicep' = if (!deployServiceBus) {
  name: 'aca-dapr-redis-component-modules'
  params: {
    acaEnvName: aca_env.outputs.name
    pubAppName: pubAppName
    pubSubName: pubSubName
    redisName: redis.outputs.name
    subAppName: subAppName
  }
}

module aca_dapr_sbus './modules/aca-dapr-sbus.bicep' = if (deployServiceBus) {
  name: 'aca-dapr-sbus-module'
  params: {
    acaEnvName: aca_env.outputs.name
    acrName: acr.name
    location: location
    pubAppName: pubAppName
    pubAppPort: pubAppPort
    subAppName: subAppName
    subAppPort: subAppPort
    pubSubName: pubSubName
    sbusName: sbus.outputs.name
    pubSubTopic: topicName
    tag: tag
  }
}

module aca_dapr_sbus_component './modules/aca-dapr-sbus-component.bicep' = if (deployServiceBus) {
  name: 'aca-dapr-sbus-component-modules'
  params: {
    acaEnvName: aca_env.outputs.name
    pubAppName: pubAppName
    subAppName: subAppName
    pubSubName: pubSubName
    sbusName: sbus.outputs.name
  }
}
