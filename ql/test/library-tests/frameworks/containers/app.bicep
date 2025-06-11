resource myRegistry 'Microsoft.ContainerRegistry/registries@2025-04-01' = {
  name: 'myregistry'
  location: 'eastus'
  sku: {
    name: 'Standard'
  }
  adminUserEnabled: true
  tags: {
    environment: 'dev'
  }
}

// Example Bicep file for a Container App with various settings
resource myContainerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'my-container-app'
  location: 'eastus'
  properties: {
    managedEnvironmentId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.App/managedEnvironments/my-env'
    configuration: {
      ingress: {
        external: true
        targetPort: 80
        transport: 'auto'
        corsPolicy: {
          allowCredentials: true
          allowedOrigins: [
            'https://example.com'
            'https://another.com'
          ]
          allowedMethods: [
            'GET'
            'POST'
            'OPTIONS'
          ]
          allowedHeaders: [
            'Authorization'
            'Content-Type'
          ]
          exposeHeaders: [
            'X-Custom-Header'
          ]
          maxAge: 3600
        }
      }
      secrets: [
        {
          name: 'my-secret'
          value: 'supersecretvalue'
        }
        {
          name: 'acr-password'
          value: 'myacrpassword'
        }
      ]
      registries: [
        {
          server: 'myregistry.azurecr.io'
          username: 'myacrusername'
          passwordSecretRef: 'acr-password'
        }
      ]
      activeRevisionsMode: 'Multiple'
    }
    template: {
      containers: [
        {
          name: 'myapp'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          resources: {
            cpu: 0.5
            memory: '1.0Gi'
          }
          env: [
            {
              name: 'ENV_VAR_1'
              value: 'value1'
            }
            {
              name: 'ENV_VAR_2'
              secretRef: 'my-secret'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 5
        rules: [
          {
            name: 'http-scaling'
            http: {
              metadata: {
                concurrentRequests: '50'
              }
            }
          }
        ]
      }
    }
  }
}
