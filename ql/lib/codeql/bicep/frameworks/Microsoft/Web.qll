/**
 * Provides classes for working with Microsoft.Web resources in Bicep.
 *
 * This module defines classes for Azure App Service resources (Microsoft.Web/sites),
 * their properties, configurations, and security settings.
 *
 * Classes:
 * - WebResource: Base class for all Microsoft.Web resources
 * - SitesResource: Class for Microsoft.Web/sites resources (App Services)
 * - SiteConfigProperties: Class for site configuration properties
 * - SiteIdentityProperties: Class for site managed identity configuration
 * - PublicWebResource: Class for publicly accessible web resources
 * - ServerFarmsResource: Class for Microsoft.Web/serverfarms resources (App Service Plans)
 * - SlotResource: Class for Microsoft.Web/sites/slots resources (Deployment Slots)
 * - StaticSitesResource: Class for Microsoft.Web/staticSites resources (Static Web Apps)
 * - HostingEnvironmentsResource: Class for Microsoft.Web/hostingEnvironments resources (App Service Environments)
 */

private import bicep
private import codeql.bicep.Concepts
private import codeql.bicep.frameworks.Microsoft.General
private import codeql.bicep.ast.Literals

module Web {
  /**
   * Represents a Microsoft.Web resource in a Bicep file.
   * Base class for all Web-related resources.
   */
  class WebResource extends AzureResource {
    /**
     * Constructs a WebResource for any Microsoft.Web resource type.
     */
    WebResource() { this.getResourceType().regexpMatch("^Microsoft.Web/.*") }

    override string toString() { result = "WebResource[" + this.getName() + "]" }
  }

  /**
   * Represents a Microsoft.Web/sites resource (App Service) in a Bicep file.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites
   */
  class SitesResource extends WebResource {
    /**
     * Constructs a SitesResource for Microsoft.Web/sites resources.
     */
    SitesResource() { this.getResourceType().regexpMatch("^Microsoft.Web/sites@.*") }

    /**
     * Gets the properties object for the App Service.
     */
    SitesProperties::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Gets the identity configuration for the App Service.
     */
    SitesProperties::SiteIdentity getIdentity() { result = this.getProperty("identity") }

    /**
     * Gets the kind of App Service (e.g., "app", "functionapp", "api").
     */
    StringLiteral getKind() { result = this.getProperty("kind") }

    /**
     * Returns the kind of App Service as a string.
     */
    string kind() { 
      exists(StringLiteral kind | kind = this.getKind() and result = kind.getValue())
    }

    /**
     * Checks if the site is a function app.
     */
    predicate isFunctionApp() { this.kind().regexpMatch(".*functionapp.*") }

    /**
     * Checks if the site is a regular web app.
     */
    predicate isWebApp() { 
      this.kind().regexpMatch(".*app.*") and
      not this.isFunctionApp()
    }

    /**
     * Gets the HTTPS-only flag for the App Service.
     */
    BooleanLiteral getHttpsOnly() { result = this.getProperty("httpsOnly") }

    /**
     * Returns true if HTTPS-only setting is enabled.
     */
    predicate isHttpsOnly() {
      exists(BooleanLiteral httpsOnly |
        httpsOnly = this.getHttpsOnly() and
        httpsOnly.getBool() = true
      )
    }

    /**
     * Gets the extendedLocation configuration.
     */
    Object getExtendedLocation() { result = this.getProperty("extendedLocation") }

    /**
     * Gets the clientAffinityEnabled flag.
     */
    BooleanLiteral getClientAffinityEnabled() { result = this.getProperty("clientAffinityEnabled") }

    /**
     * Returns true if client affinity is enabled.
     */
    predicate isClientAffinityEnabled() {
      exists(BooleanLiteral clientAffinity |
        clientAffinity = this.getClientAffinityEnabled() and
        clientAffinity.getBool() = true
      )
    }

    /**
     * Gets the clientCertEnabled flag.
     */
    BooleanLiteral getClientCertEnabled() { result = this.getProperty("clientCertEnabled") }

    /**
     * Returns true if client certificates are enabled.
     */
    predicate isClientCertEnabled() {
      exists(BooleanLiteral clientCert |
        clientCert = this.getClientCertEnabled() and
        clientCert.getBool() = true
      )
    }

    /**
     * Gets the clientCertMode setting.
     */
    StringLiteral getClientCertMode() { result = this.getProperty("clientCertMode") }

    /**
     * Gets the hostNameSslStates array.
     */
    Array getHostNameSslStates() { result = this.getProperty("hostNameSslStates") }

    /**
     * Gets the hyperV setting.
     */
    BooleanLiteral getHyperV() { result = this.getProperty("hyperV") }

    /**
     * Returns true if Hyper-V is enabled.
     */
    predicate isHyperVEnabled() {
      exists(BooleanLiteral hyperv |
        hyperv = this.getHyperV() and
        hyperv.getBool() = true
      )
    }

    /**
     * Gets the keyVaultReferenceIdentity.
     */
    StringLiteral getKeyVaultReferenceIdentity() { result = this.getProperty("keyVaultReferenceIdentity") }

    /**
     * Gets the redundancyMode.
     */
    StringLiteral getRedundancyMode() { result = this.getProperty("redundancyMode") }

    /**
     * Gets the storageAccountRequired flag.
     */
    BooleanLiteral getStorageAccountRequired() { result = this.getProperty("storageAccountRequired") }

    /**
     * Returns true if a storage account is required.
     */
    predicate isStorageAccountRequired() {
      exists(BooleanLiteral storageReq |
        storageReq = this.getStorageAccountRequired() and
        storageReq.getBool() = true
      )
    }

    /**
     * Gets the virtualNetworkSubnetId.
     */
    StringLiteral getVirtualNetworkSubnetId() { result = this.getProperty("virtualNetworkSubnetId") }

    override string toString() { result = "AppService[" + this.getIdentifier().getName() + "]" }
  }

  /**
   * Represents a Microsoft.Web/serverfarms resource (App Service Plan) in a Bicep file.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.web/serverfarms
   */
  class ServerFarmsResource extends WebResource {
    /**
     * Constructs a ServerFarmsResource for Microsoft.Web/serverfarms resources.
     */
    ServerFarmsResource() { this.getResourceType().regexpMatch("^Microsoft.Web/serverfarms@.*") }

    /**
     * Gets the properties object for the App Service Plan.
     */
    ServerFarmsProperties::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Gets the SKU object for the App Service Plan.
     */
    override Sku getSku() { result = this.getProperty("sku") }

    /**
     * Gets whether the App Service Plan is reserved (for Linux).
     */
    BooleanLiteral getReserved() { result = this.getProperty("reserved") }

    /**
     * Returns true if the App Service Plan is reserved (for Linux).
     */
    predicate isReserved() {
      exists(BooleanLiteral reserved |
        reserved = this.getReserved() and
        reserved.getBool() = true
      )
    }

    /**
     * Gets the hosting environment profile.
     */
    Object getHostingEnvironmentProfile() { result = this.getProperty("hostingEnvironmentProfile") }

    /**
     * Gets whether zone redundancy is enabled.
     */
    BooleanLiteral getZoneRedundant() { result = this.getProperty("zoneRedundant") }

    /**
     * Returns true if zone redundancy is enabled.
     */
    predicate isZoneRedundant() {
      exists(BooleanLiteral zoneRedundant |
        zoneRedundant = this.getZoneRedundant() and
        zoneRedundant.getBool() = true
      )
    }

    override string toString() { result = "AppServicePlan[" + this.getIdentifier().getName() + "]" }
  }

  /**
   * Represents a Microsoft.Web/sites/slots resource (Deployment Slot) in a Bicep file.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites/slots
   */
  class SlotResource extends WebResource {
    /**
     * Constructs a SlotResource for Microsoft.Web/sites/slots resources.
     */
    SlotResource() { this.getResourceType().regexpMatch("^Microsoft.Web/sites/slots@.*") }

    /**
     * Gets the properties object for the deployment slot.
     */
    SitesProperties::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Gets the identity configuration for the deployment slot.
     */
    SitesProperties::SiteIdentity getIdentity() { result = this.getProperty("identity") }

    /**
     * Gets the kind of the deployment slot.
     */
    StringLiteral getKind() { result = this.getProperty("kind") }

    /**
     * Returns the kind of the deployment slot as a string.
     */
    string kind() { result = this.getKind().getValue() }

    /**
     * Gets the HTTPS-only flag for the deployment slot.
     */
    BooleanLiteral getHttpsOnly() { result = this.getProperty("httpsOnly") }

    /**
     * Returns true if HTTPS-only setting is enabled for the deployment slot.
     */
    predicate isHttpsOnly() {
      exists(BooleanLiteral httpsOnly |
        httpsOnly = this.getHttpsOnly() and
        httpsOnly.getBool() = true
      )
    }

    /**
     * Gets the parent site name.
     */
    string getParentSiteName() {
      // Parse from the resource name which is in the format "siteName/slotName"
      exists(string fullName | 
        fullName = this.getName() and
        result = fullName.regexpCapture("([^/]+)/.*", 1)
      )
    }

    /**
     * Gets the slot name (without the parent site name).
     */
    string getSlotName() {
      // Parse from the resource name which is in the format "siteName/slotName"
      exists(string fullName | 
        fullName = this.getName() and
        result = fullName.regexpCapture("[^/]+/(.*)", 1)
      )
    }

    override string toString() { result = "DeploymentSlot[" + this.getIdentifier().getName() + "]" }
  }

  /**
   * Represents a Microsoft.Web/staticSites resource (Static Web App) in a Bicep file.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.web/staticsites
   */
  class StaticSitesResource extends WebResource {
    /**
     * Constructs a StaticSitesResource for Microsoft.Web/staticSites resources.
     */
    StaticSitesResource() { this.getResourceType().regexpMatch("^Microsoft.Web/staticSites@.*") }

    /**
     * Gets the properties object for the Static Web App.
     */
    StaticSitesProperties::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Gets the identity configuration for the Static Web App.
     */
    SitesProperties::SiteIdentity getIdentity() { result = this.getProperty("identity") }

    /**
     * Gets the SKU object for the Static Web App.
     */
    override Sku getSku() { result = this.getProperty("sku") }

    override string toString() { result = "StaticWebApp[" + this.getIdentifier().getName() + "]" }
  }

  /**
   * Represents a Microsoft.Web/hostingEnvironments resource (App Service Environment) in a Bicep file.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.web/hostingenvironments
   */
  class HostingEnvironmentsResource extends WebResource {
    /**
     * Constructs a HostingEnvironmentsResource for Microsoft.Web/hostingEnvironments resources.
     */
    HostingEnvironmentsResource() { this.getResourceType().regexpMatch("^Microsoft.Web/hostingEnvironments@.*") }

    /**
     * Gets the properties object for the App Service Environment.
     */
    HostingEnvironmentsProperties::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Gets the kind of the App Service Environment.
     */
    StringLiteral getKind() { result = this.getProperty("kind") }

    /**
     * Returns the kind of the App Service Environment as a string.
     */
    string kind() { result = this.getKind().getValue() }

    override string toString() { result = "AppServiceEnvironment[" + this.getIdentifier().getName() + "]" }
  }

  /**
   * Module containing properties and configurations for Microsoft.Web/sites resources.
   */
  module SitesProperties {
    /**
     * Represents the properties object for a Microsoft.Web/sites resource.
     */
    class Properties extends ResourceProperties {
      private SitesResource site;

      /**
       * Constructs a Properties object for the given site.
       */
      Properties() { this = site.getProperty("properties") }

      /**
       * Gets the site configuration.
       */
      SiteConfig getSiteConfig() { result = this.getProperty("siteConfig") }

      /**
       * Gets the serverFarmId (App Service Plan ID).
       */
      StringLiteral getServerFarmId() { result = this.getProperty("serverFarmId") }

      /**
       * Gets the hostingEnvironmentProfile.
       */
      Object getHostingEnvironmentProfile() { result = this.getProperty("hostingEnvironmentProfile") }

      /**
       * Gets the public network access setting.
       */
      StringLiteral getPublicNetworkAccess() { result = this.getProperty("publicNetworkAccess") }

      /**
       * Gets the virtualNetworkSubnetId.
       */
      StringLiteral getVirtualNetworkSubnetId() { result = this.getProperty("virtualNetworkSubnetId") }

      /**
       * Gets the enabled value.
       */
      BooleanLiteral getEnabled() { result = this.getProperty("enabled") }

      /**
       * Returns true if the site is enabled.
       */
      predicate isEnabled() {
        exists(BooleanLiteral enabled |
          enabled = this.getEnabled() and
          enabled.getBool() = true
        )
      }

      /**
       * Gets the client certificate mode.
       */
      StringLiteral getClientCertMode() { result = this.getProperty("clientCertMode") }
      
      /**
       * Returns true if client certificate is required.
       */
      predicate isClientCertRequired() {
        exists(StringLiteral mode |
          mode = this.getClientCertMode() and
          mode.getValue() = "Required"
        )
      }

      /**
       * Gets the client certificate exclusion paths.
       */
      StringLiteral getClientCertExclusionPaths() { result = this.getProperty("clientCertExclusionPaths") }

      /**
       * Gets the container size.
       */
      Number getContainerSize() { result = this.getProperty("containerSize") }

      /**
       * Gets the custom domain verification ID.
       */
      StringLiteral getCustomDomainVerificationId() { result = this.getProperty("customDomainVerificationId") }

      /**
       * Gets the daily memory time quota.
       */
      Number getDailyMemoryTimeQuota() { result = this.getProperty("dailyMemoryTimeQuota") }

      /**
       * Gets the default hostname.
       */
      StringLiteral getDefaultHostname() { result = this.getProperty("defaultHostname") }

      /**
       * Gets the https certificate settings.
       */
      HttpsCertificates getHttpsCertificates() { result = this.getProperty("httpsCertificates") }

      /**
       * Returns true if public network access is enabled.
       */
      predicate isPublicNetworkAccessEnabled() {
        not exists(StringLiteral publicNetworkAccess |
          publicNetworkAccess = this.getPublicNetworkAccess() and
          publicNetworkAccess.getValue() = "Disabled"
        )
      }

      override string toString() { result = "SiteProperties" }
    }

    /**
     * Represents the site configuration for a Microsoft.Web/sites resource.
     */
    class SiteConfig extends Object {
      private Properties properties;

      /**
       * Constructs a SiteConfig object.
       */
      SiteConfig() { this = properties.getProperty("siteConfig") }

      /**
       * Gets the minimum TLS version.
       */
      StringLiteral getMinTlsVersion() { result = this.getProperty("minTlsVersion") }

      /**
       * Gets the ftps state setting.
       */
      StringLiteral getFtpsState() { result = this.getProperty("ftpsState") }

      /**
       * Gets whether remote debugging is enabled.
       */
      BooleanLiteral getRemoteDebuggingEnabled() { result = this.getProperty("remoteDebuggingEnabled") }

      /**
       * Returns true if remote debugging is enabled.
       */
      predicate isRemoteDebuggingEnabled() {
        exists(BooleanLiteral debugEnabled |
          debugEnabled = this.getRemoteDebuggingEnabled() and
          debugEnabled.getBool() = true
        )
      }

      /**
       * Gets the remote debugging version.
       */
      StringLiteral getRemoteDebuggingVersion() { result = this.getProperty("remoteDebuggingVersion") }

      /**
       * Gets whether HTTP 2.0 is enabled.
       */
      BooleanLiteral getHttp20Enabled() { result = this.getProperty("http20Enabled") }

      /**
       * Returns true if HTTP 2.0 is enabled.
       */
      predicate isHttp20Enabled() {
        exists(BooleanLiteral http20 |
          http20 = this.getHttp20Enabled() and
          http20.getBool() = true
        )
      }

      /**
       * Gets whether Always On is enabled.
       */
      BooleanLiteral getAlwaysOn() { result = this.getProperty("alwaysOn") }

      /**
       * Returns true if Always On is enabled.
       */
      predicate isAlwaysOn() {
        exists(BooleanLiteral alwaysOn |
          alwaysOn = this.getAlwaysOn() and
          alwaysOn.getBool() = true
        )
      }

      /**
       * Gets whether web sockets are enabled.
       */
      BooleanLiteral getWebSocketsEnabled() { result = this.getProperty("webSocketsEnabled") }

      /**
       * Returns true if web sockets are enabled.
       */
      predicate areWebSocketsEnabled() {
        exists(BooleanLiteral webSockets |
          webSockets = this.getWebSocketsEnabled() and
          webSockets.getBool() = true
        )
      }

      /**
       * Gets the application stack.
       */
      Object getApplicationStack() { result = this.getProperty("applicationStack") }

      /**
       * Gets the connection strings.
       */
      Array getConnectionStrings() { result = this.getProperty("connectionStrings") }

      /**
       * Gets the app settings.
       */
      Object getAppSettings() { result = this.getProperty("appSettings") }

      /**
       * Gets the CORS settings.
       */
      CorsSettings getCors() { result = this.getProperty("cors") }

      /**
       * Gets the Linux FX version.
       */
      StringLiteral getLinuxFxVersion() { result = this.getProperty("linuxFxVersion") }

      /**
       * Gets the Windows FX version.
       */
      StringLiteral getWindowsFxVersion() { result = this.getProperty("windowsFxVersion") }

      /**
       * Gets the health check path.
       */
      StringLiteral getHealthCheckPath() { result = this.getProperty("healthCheckPath") }

      string toString() { result = "SiteConfig" }
    }

    /**
     * Represents the CORS settings for a site configuration.
     */
    class CorsSettings extends Object {
      private SiteConfig siteConfig;

      /**
       * Constructs a CorsSettings object.
       */
      CorsSettings() { this = siteConfig.getProperty("cors") }

      /**
       * Gets the allowed origins.
       */
      Array getAllowedOrigins() { result = this.getProperty("allowedOrigins") }

      /**
       * Gets whether credentials are supported.
       */
      BooleanLiteral getSupportCredentials() { result = this.getProperty("supportCredentials") }

      /**
       * Returns true if credentials are supported.
       */
      predicate areCredentialsSupported() {
        exists(BooleanLiteral credentials |
          credentials = this.getSupportCredentials() and
          credentials.getBool() = true
        )
      }

      string toString() { result = "CorsSettings" }
    }

    /**
     * Represents the HTTPS certificates configuration for a site.
     */
    class HttpsCertificates extends Array {
      private Properties properties;

      /**
       * Constructs an HttpsCertificates object.
       */
      HttpsCertificates() { this = properties.getProperty("httpsCertificates") }

      /**
       * Gets a certificate by index.
       */
      Object getCertificate(int index) { 
        result = this.getElement(index)
      }

      string toString() { result = "HttpsCertificates" }
    }

    /**
     * Represents the identity configuration for a Microsoft.Web/sites resource.
     */
    class SiteIdentity extends Object {
      private SitesResource site;

      /**
       * Constructs a SiteIdentity object.
       */
      SiteIdentity() { this = site.getProperty("identity") }

      /**
       * Gets the type of managed identity.
       */
      StringLiteral getType() { result = this.getProperty("type") }

      /**
       * Returns the managed identity type as a string.
       */
      string identityType() { result = this.getType().getValue() }

      /**
       * Returns true if the site has a system-assigned identity.
       */
      predicate hasSystemAssignedIdentity() {
        this.identityType() = "SystemAssigned" or
        this.identityType() = "SystemAssigned, UserAssigned"
      }

      /**
       * Returns true if the site has user-assigned identities.
       */
      predicate hasUserAssignedIdentities() {
        this.identityType() = "UserAssigned" or
        this.identityType() = "SystemAssigned, UserAssigned"
      }

      /**
       * Gets the user-assigned identities.
       */
      Object getUserAssignedIdentities() { result = this.getProperty("userAssignedIdentities") }

      string toString() { result = "SiteIdentity" }
    }
  }

  /**
   * Module containing property classes for Static Web App resources.
   */
  module StaticSitesProperties {
    /**
     * Represents the properties object for a Microsoft.Web/staticSites resource.
     */
    class Properties extends ResourceProperties {
      private StaticSitesResource staticSite;

      /**
       * Constructs a Properties object for the given static site.
       */
      Properties() { this = staticSite.getProperty("properties") }

      /**
       * Gets the staging environment policy.
       */
      StringLiteral getStagingEnvironmentPolicy() { result = this.getProperty("stagingEnvironmentPolicy") }

      /**
       * Gets whether private endpoint connections are allowed.
       */
      BooleanLiteral getAllowConfigFileUpdates() { result = this.getProperty("allowConfigFileUpdates") }

      /**
       * Returns true if config file updates are allowed.
       */
      predicate areConfigFileUpdatesAllowed() {
        exists(BooleanLiteral allowUpdates |
          allowUpdates = this.getAllowConfigFileUpdates() and
          allowUpdates.getBool() = true
        )
      }

      /**
       * Gets the branch configuration for the repository.
       */
      Object getRepositoryBranch() { result = this.getProperty("repositoryBranch") }

      /**
       * Gets the repository token for the Static Web App.
       */
      StringLiteral getRepositoryToken() { result = this.getProperty("repositoryToken") }

      /**
       * Gets the repository URL for the Static Web App.
       */
      StringLiteral getRepositoryUrl() { result = this.getProperty("repositoryUrl") }

      /**
       * Gets whether private endpoint connections are allowed.
       */
      BooleanLiteral getAllowPrivateEndpoints() { result = this.getProperty("allowPrivateEndpoints") }

      /**
       * Returns true if private endpoints are allowed.
       */
      predicate arePrivateEndpointsAllowed() {
        exists(BooleanLiteral allowEndpoints |
          allowEndpoints = this.getAllowPrivateEndpoints() and
          allowEndpoints.getBool() = true
        )
      }

      override string toString() { result = "StaticSiteProperties" }
    }
  }

  /**
   * Module containing property classes for App Service Environment resources.
   */
  module HostingEnvironmentsProperties {
    /**
     * Represents the properties object for a Microsoft.Web/hostingEnvironments resource.
     */
    class Properties extends ResourceProperties {
      private HostingEnvironmentsResource hostingEnv;

      /**
       * Constructs a Properties object for the given hosting environment.
       */
      Properties() { this = hostingEnv.getProperty("properties") }

      /**
       * Gets the dedicated host count.
       */
      Number getDedicatedHostCount() { result = this.getProperty("dedicatedHostCount") }

      /**
       * Gets whether zone redundancy is enabled.
       */
      BooleanLiteral getZoneRedundant() { result = this.getProperty("zoneRedundant") }

      /**
       * Returns true if zone redundancy is enabled.
       */
      predicate isZoneRedundant() {
        exists(BooleanLiteral zoneRedundant |
          zoneRedundant = this.getZoneRedundant() and
          zoneRedundant.getBool() = true
        )
      }

      /**
       * Gets the internal load balancing mode.
       */
      StringLiteral getInternalLoadBalancingMode() { result = this.getProperty("internalLoadBalancingMode") }

      /**
       * Gets the cluster settings.
       */
      Array getClusterSettings() { result = this.getProperty("clusterSettings") }

      /**
       * Gets the virtual network configuration.
       */
      VnetConfiguration getVirtualNetworkProfile() { result = this.getProperty("virtualNetworkProfile") }

      override string toString() { result = "HostingEnvironmentProperties" }
    }

    /**
     * Represents the virtual network configuration for an App Service Environment.
     */
    class VnetConfiguration extends Object {
      private Properties props;

      /**
       * Constructs a VnetConfiguration object.
       */
      VnetConfiguration() { this = props.getProperty("virtualNetworkProfile") }

      /**
       * Gets the subnet ID.
       */
      StringLiteral getSubnetId() { result = this.getProperty("id") }

      /**
       * Gets the subnet resource ID.
       */
      string subnetId() { result = this.getSubnetId().getValue() }

      string toString() { result = "VnetConfiguration" }
    }
  }

  /**
   * Module containing property classes for App Service Plan resources.
   */
  module ServerFarmsProperties {
    /**
     * Represents the properties object for a Microsoft.Web/serverfarms resource.
     */
    class Properties extends ResourceProperties {
      private ServerFarmsResource serverFarm;

      /**
       * Constructs a Properties object for the given server farm.
       */
      Properties() { this = serverFarm.getProperty("properties") }

      /**
       * Gets the compute mode.
       */
      StringLiteral getComputeMode() { result = this.getProperty("computeMode") }

      /**
       * Returns the compute mode as a string.
       */
      string computeMode() { result = this.getComputeMode().getValue() }

      /**
       * Gets the worker size.
       */
      StringLiteral getWorkerSize() { result = this.getProperty("workerSize") }

      /**
       * Returns the worker size as a string.
       */
      string workerSize() { result = this.getWorkerSize().getValue() }

      /**
       * Gets the worker size ID.
       */
      Number getWorkerSizeId() { result = this.getProperty("workerSizeId") }

      /**
       * Returns the worker size ID as an integer.
       */
      int workerSizeId() { result = this.getWorkerSizeId().getValue() }

      /**
       * Gets the number of workers.
       */
      Number getNumberOfWorkers() { result = this.getProperty("numberOfWorkers") }

      /**
       * Returns the number of workers as an integer.
       */
      int numberOfWorkers() { result = this.getNumberOfWorkers().getValue() }

      /**
       * Gets the per site scaling setting.
       */
      BooleanLiteral getPerSiteScaling() { result = this.getProperty("perSiteScaling") }

      /**
       * Returns true if per-site scaling is enabled.
       */
      predicate isPerSiteScalingEnabled() {
        exists(BooleanLiteral perSiteScaling |
          perSiteScaling = this.getPerSiteScaling() and
          perSiteScaling.getBool() = true
        )
      }

      /**
       * Gets the elastic scaling setting.
       */
      BooleanLiteral getElasticScaleEnabled() { result = this.getProperty("elasticScaleEnabled") }

      /**
       * Returns true if elastic scaling is enabled.
       */
      predicate isElasticScaleEnabled() {
        exists(BooleanLiteral elasticScale |
          elasticScale = this.getElasticScaleEnabled() and
          elasticScale.getBool() = true
        )
      }

      /**
       * Gets whether zone redundant deployment is enabled.
       */
      BooleanLiteral getZoneRedundant() { result = this.getProperty("zoneRedundant") }

      /**
       * Returns true if zone redundant deployment is enabled.
       */
      predicate isZoneRedundant() {
        exists(BooleanLiteral zoneRedundant |
          zoneRedundant = this.getZoneRedundant() and
          zoneRedundant.getBool() = true
        )
      }

      /**
       * Gets the maximum number of workers.
       */
      Number getMaximumElasticWorkerCount() { result = this.getProperty("maximumElasticWorkerCount") }

      /**
       * Returns the maximum number of workers as an integer.
       */
      int maximumElasticWorkerCount() { result = this.getMaximumElasticWorkerCount().getValue() }

      override string toString() { result = "ServerFarmProperties" }
    }
  }
}