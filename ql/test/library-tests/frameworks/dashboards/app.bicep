// Example of Microsoft.Dashboard/grafana resources
// This file contains multiple examples to test all the properties defined in our CodeQL module

// Basic grafana resource with minimum required properties
resource basicGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'basic-grafana'
  location: 'westus2'
  properties: {}
  sku: {
    name: 'Standard'
  }
}

// Grafana with public network access enabled - used to test PublicGrafanaResource class
resource publicGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'public-grafana'
  location: 'eastus'
  properties: {
    publicNetworkAccess: 'Enabled'
  }
  sku: {
    name: 'Standard'
  }
}

// Grafana with public network access explicitly disabled
resource privateGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'private-grafana'
  location: 'westeurope'
  properties: {
    publicNetworkAccess: 'Disabled'
  }
  sku: {
    name: 'Standard'
  }
}

// Grafana with identity configuration
resource identityGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'identity-grafana'
  location: 'eastus2'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
  sku: {
    name: 'Standard'
  }
}

// Grafana with user assigned identity
resource userIdentityGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'user-identity-grafana'
  location: 'westus'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity': {}
    }
  }
  properties: {}
  sku: {
    name: 'Standard'
  }
}

// Comprehensive Grafana resource with all main properties
resource comprehensiveGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'comprehensive-grafana'
  location: 'centralus'
  identity: {
    type: 'SystemAssigned,UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity': {}
    }
  }
  properties: {
    apiKey: 'Enabled'
    autoGeneratedDomainNameLabelScope: 'TenantReuse'
    deterministicOutboundIP: 'Enabled'
    grafanaMajorVersion: '10'
    publicNetworkAccess: 'Enabled'
    zoneRedundancy: 'Enabled'
  }
  sku: {
    name: 'Standard'
  }
  tags: {
    Environment: 'Production'
    Department: 'IT'
  }
}

// Grafana with enterprise configurations
resource enterpriseGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'enterprise-grafana'
  location: 'northeurope'
  properties: {
    enterpriseConfigurations: {
      marketplaceAutoRenew: 'Enabled'
      marketplacePlanId: 'enterprise-plan-123'
    }
  }
  sku: {
    name: 'Enterprise'
  }
}

// Grafana with security settings
resource securityGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'security-grafana'
  location: 'uksouth'
  properties: {
    grafanaConfigurations: {
      security: {
        csrfAlwaysCheck: true
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Grafana with SMTP configuration
resource smtpGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'smtp-grafana'
  location: 'japaneast'
  properties: {
    grafanaConfigurations: {
      smtp: {
        enabled: true
        fromAddress: 'grafana@example.com'
        fromName: 'Grafana Alerts'
        host: 'smtp.example.com:587'
        password: 'SecurePasswordHere'
        skipVerify: false
        startTLSPolicy: 'MandatoryStartTLS'
        user: 'grafanauser'
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Grafana with snapshots configuration
resource snapshotsGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'snapshots-grafana'
  location: 'brazilsouth'
  properties: {
    grafanaConfigurations: {
      snapshots: {
        externalEnabled: false
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Grafana with unified alerting screenshots configuration
resource alertingGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'alerting-grafana'
  location: 'australiaeast'
  properties: {
    grafanaConfigurations: {
      unifiedAlertingScreenshots: {
        captureEnabled: false
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Grafana with users configuration
resource usersGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'users-grafana'
  location: 'southcentralus'
  properties: {
    grafanaConfigurations: {
      users: {
        editorsCanAdmin: true
        viewersCanEdit: true
      }
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Grafana with integrations configuration
resource integrationsGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'integrations-grafana'
  location: 'eastus2'
  properties: {
    grafanaIntegrations: {
      azureMonitorWorkspaceIntegrations: [
        {
          azureMonitorWorkspaceResourceId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.OperationalInsights/workspaces/my-workspace'
        },
        {
          azureMonitorWorkspaceResourceId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.OperationalInsights/workspaces/my-second-workspace'
        }
      ]
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Grafana with plugins configuration
resource pluginsGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'plugins-grafana'
  location: 'canadacentral'
  properties: {
    grafanaPlugins: {
      'grafana-worldmap-panel': {}
      'grafana-piechart-panel': {}
    }
  }
  sku: {
    name: 'Standard'
  }
}

// Super comprehensive Grafana resource with all properties
resource fullGrafana 'Microsoft.Dashboard/grafana@2024-11-01-preview' = {
  name: 'full-featured-grafana'
  location: 'westus3'
  identity: {
    type: 'SystemAssigned,UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity': {}
    }
  }
  properties: {
    apiKey: 'Enabled'
    autoGeneratedDomainNameLabelScope: 'TenantReuse'
    deterministicOutboundIP: 'Enabled'
    grafanaMajorVersion: '10'
    publicNetworkAccess: 'Enabled'
    zoneRedundancy: 'Enabled'
    enterpriseConfigurations: {
      marketplaceAutoRenew: 'Enabled'
      marketplacePlanId: 'enterprise-plan-premium'
    }
    grafanaConfigurations: {
      security: {
        csrfAlwaysCheck: true
      }
      smtp: {
        enabled: true
        fromAddress: 'grafana@company.com'
        fromName: 'Grafana Enterprise Alerts'
        host: 'smtp.company.com:587'
        password: 'SecureEnterprisePassword'
        skipVerify: false
        startTLSPolicy: 'MandatoryStartTLS'
        user: 'grafanaadmin'
      }
      snapshots: {
        externalEnabled: false
      }
      unifiedAlertingScreenshots: {
        captureEnabled: true
      }
      users: {
        editorsCanAdmin: true
        viewersCanEdit: false
      }
    }
    grafanaIntegrations: {
      azureMonitorWorkspaceIntegrations: [
        {
          azureMonitorWorkspaceResourceId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.OperationalInsights/workspaces/primary-workspace'
        },
        {
          azureMonitorWorkspaceResourceId: '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.OperationalInsights/workspaces/secondary-workspace'
        }
      ]
    }
    grafanaPlugins: {
      'grafana-worldmap-panel': {}
      'grafana-piechart-panel': {}
      'grafana-clock-panel': {}
      'grafana-azure-monitor-datasource': {}
    }
  }
  sku: {
    name: 'Enterprise'
  }
  tags: {
    Environment: 'Production'
    Department: 'Engineering'
    CostCenter: 'CC-123456'
    Project: 'Enterprise Monitoring'
  }
}

// Grafana with an older API version
resource olderVersionGrafana 'Microsoft.Dashboard/grafana@2023-09-01' = {
  name: 'older-version-grafana'
  location: 'eastus'
  properties: {
    apiKey: 'Enabled'
  }
  sku: {
    name: 'Standard'
  }
}