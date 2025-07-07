// Test cases for InsecureWebAppFtpsState.ql

// BAD: FTP and FTPS both allowed
resource webAppBad1 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-bad1'
  location: 'eastus'
  properties: {
    siteConfig: {
      ftpsState: 'AllAllowed'
    }
  }
}

// BAD: Only insecure FTP is allowed
resource webAppBad2 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-bad2'
  location: 'eastus'
  properties: {
    siteConfig: {
      ftpsState: 'FtpOnly'
    }
  }
}

// GOOD: Only secure FTPS is allowed
resource webAppGood1 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-good1'
  location: 'eastus'
  properties: {
    siteConfig: {
      ftpsState: 'FtpsOnly'
    }
  }
}

// GOOD: FTP and FTPS are both disabled
resource webAppGood2 'Microsoft.Web/sites@2021-03-01' = {
  name: 'mywebapp-good2'
  location: 'eastus'
  properties: {
    siteConfig: {
      ftpsState: 'Disabled'
    }
  }
}
