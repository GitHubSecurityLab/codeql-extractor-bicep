// Secure CORS example: only specific headers allowed
resource secureContainerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'secure-container-app'
  location: 'eastus'
  properties: {
    managedEnvironmentId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.App/managedEnvironments/my-env'
    configuration: {
      ingress: {
        external: true
        targetPort: 80
        corsPolicy: {
          allowCredentials: false
          allowedOrigins: [ 'https://example.com' ]
          allowedHeaders: [ 'Authorization', 'Content-Type' ]
        }
      }
    }
    template: {
      containers: [
        {
          name: 'app'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        }
      ]
    }
  }
}

// Insecure CORS example: all headers allowed (should be flagged)
resource insecureContainerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'insecure-container-app'
  location: 'eastus'
  properties: {
    managedEnvironmentId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.App/managedEnvironments/my-env'
    configuration: {
      ingress: {
        external: true
        targetPort: 80
        corsPolicy: {
          allowCredentials: false
          allowedOrigins: [ '*' ]
          allowedHeaders: [ '*' ]
        }
      }
    }
    template: {
      containers: [
        {
          name: 'app'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        }
      ]
    }
  }
}
