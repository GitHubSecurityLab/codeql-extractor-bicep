// Test cases for WebAppRemoteDebugging.ql

// BAD: Remote debugging is enabled
resource webAppBad1 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-bad1'
  location: 'eastus'
  properties: {
    siteConfig: {
      remoteDebuggingEnabled: true
    }
  }
}

// BAD: Remote debugging is enabled with a specific version
resource webAppBad2 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-bad2'
  location: 'eastus'
  properties: {
    siteConfig: {
      remoteDebuggingEnabled: true
      remoteDebuggingVersion: 'VS2019'
    }
  }
}

// GOOD: Remote debugging is explicitly disabled
resource webAppGood1 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-good1'
  location: 'eastus'
  properties: {
    siteConfig: {
      remoteDebuggingEnabled: false
    }
  }
}

// GOOD: Remote debugging is not specified (defaults to disabled)
resource webAppGood2 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-good2'
  location: 'eastus'
  properties: {
    siteConfig: {
      // No remoteDebuggingEnabled property
    }
  }
}
