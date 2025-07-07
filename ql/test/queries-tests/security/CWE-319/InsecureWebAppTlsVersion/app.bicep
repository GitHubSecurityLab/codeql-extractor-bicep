// Test cases for InsecureWebAppTlsVersion.ql

// GOOD: TLS 1.2 is used
resource webAppGood 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-good'
  location: 'eastus'
  properties: {
    siteConfig: {
      minTlsVersion: '1.2'
    }
  }
}

// BAD: TLS 1.1 is used
resource webAppBad1 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-bad1'
  location: 'eastus'
  properties: {
    siteConfig: {
      minTlsVersion: '1.1'
    }
  }
}

// BAD: TLS 1.0 is used
resource webAppBad2 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-bad2'
  location: 'eastus'
  properties: {
    siteConfig: {
      minTlsVersion: '1.0'
    }
  }
}

// GOOD: TLS 1.2 is used with other configurations
resource webAppGoodWithOtherConfig 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-good-other-config'
  location: 'eastus'
  properties: {
    siteConfig: {
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      http20Enabled: true
    }
  }
}
