# Web App without Always On enabled

Azure Web Apps should have the "Always On" setting enabled in production environments to ensure reliability, performance, and security. When Always On is disabled, the application may experience cold start delays and periodic shutdowns that could impact availability and security.

## Recommendation

Enable the "Always On" setting for all production Azure Web Apps:

```bicep
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'myWebApp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      alwaysOn: true  // Enable Always On for reliability and security
    }
  }
}
```

## Example

### Suboptimal configuration

```bicep
resource webAppWithoutAlwaysOn 'Microsoft.Web/sites@2022-03-01' = {
  name: 'myWebApp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      // Always On is not explicitly enabled, which can lead to
      // application shutdowns and cold starts
    }
  }
}
```

### Recommended configuration

```bicep
resource webAppWithAlwaysOn 'Microsoft.Web/sites@2022-03-01' = {
  name: 'myWebApp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      alwaysOn: true  // Explicitly enable Always On
    }
  }
}
```

## Why this is important

When "Always On" is disabled:
- The application can be unloaded after a period of inactivity
- Cold starts can cause delays for users and create availability issues
- Periodic recycling can interrupt background processes
- Attackers could potentially exploit behavior differences between cold and warm instances

## References
* [Configure an App Service app](https://learn.microsoft.com/en-us/azure/app-service/configure-common)
* [Azure App Service plan overview](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans)
