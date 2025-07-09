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
 * - ExtendedLocation: Class for extended location configuration
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
    String getKind() { result = this.getProperty("kind") }

    /**
     * Returns the kind of App Service as a string.
     */
    string kind() { exists(String kind | kind = this.getKind() and result = kind.getValue()) }

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
     * Gets the extendedLocation configuration.
     */
    ExtendedLocation getExtendedLocation() { result = this.getProperty("extendedLocation") }

    /**
     * Gets the virtualNetworkSubnetId property.
     */
    String getVirtualNetworkSubnetId() { result = this.getProperties().getVirtualNetworkSubnetId() }

    /**
     * Gets the clientAffinityEnabled flag.
     */
    Boolean getClientAffinityEnabled() { result = this.getProperties().getClientAffinityEnabled() }

    /**
     * Gets the clientCertEnabled flag.
     */
    Boolean getClientCertEnabled() { result = this.getProperties().getClientCertEnabled() }

    /**
     * Returns true if the site has client certificates enabled.
     */
    predicate isClientCertEnabled() { this.getProperties().isClientCertEnabled() }

    /**
     * Gets the hostNameSslStates array.
     */
    Array getHostNameSslStates() { result = this.getProperties().getHostNameSslStates() }

    /**
     * Gets the hyperV setting.
     */
    Boolean getHyperV() { result = this.getProperties().getHyperV() }

    /**
     * Gets the keyVaultReferenceIdentity.
     */
    String getKeyVaultReferenceIdentity() {
      result = this.getProperties().getKeyVaultReferenceIdentity()
    }

    /**
     * Gets the redundancyMode.
     */
    String getRedundancyMode() { result = this.getProperties().getRedundancyMode() }

    /**
     * Gets the storageAccountRequired flag.
     */
    Boolean getStorageAccountRequired() {
      result = this.getProperties().getStorageAccountRequired()
    }

    /**
     * Returns true if client affinity is enabled.
     */
    predicate isClientAffinityEnabled() { this.getProperties().isClientAffinityEnabled() }

    /**
     * Returns true if Hyper-V is enabled.
     */
    predicate isHyperVEnabled() { this.getProperties().isHyperVEnabled() }

    /**
     * Returns true if a storage account is required.
     */
    predicate isStorageAccountRequired() { this.getProperties().isStorageAccountRequired() }

    /**
     * Gets the httpsOnly flag for the site.
     */
    Boolean getHttpsOnly() { result = this.getProperties().getHttpsOnly() }

    /**
     * Returns true if the site has HTTPS-only mode enabled.
     */
    predicate isHttpsOnly() {
      exists(Boolean httpsOnly |
        httpsOnly = this.getHttpsOnly() and
        httpsOnly.getBool() = true
      )
    }

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
    Boolean getReserved() { result = this.getProperty("reserved") }

    /**
     * Returns true if the App Service Plan is reserved (for Linux).
     */
    predicate isReserved() {
      exists(Boolean reserved |
        reserved = this.getReserved() and
        reserved.getBool() = true
      )
    }

    /**
     * Gets whether zone redundant deployment is enabled.
     */
    Boolean getZoneRedundant() { result = this.getProperties().getZoneRedundant() }

    /**
     * Returns true if zone redundant deployment is enabled.
     */
    predicate isZoneRedundant() { this.getProperties().isZoneRedundant() }

    /**
     * Gets the hosting environment profile.
     */
    HostingEnvironmentProfile getHostingEnvironmentProfile() {
      result = this.getProperties().getHostingEnvironmentProfile()
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
    SlotProperties::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Gets the identity configuration for the deployment slot.
     */
    SitesProperties::SiteIdentity getIdentity() { result = this.getProperty("identity") }

    /**
     * Gets the kind of the deployment slot.
     */
    String getKind() { result = this.getProperty("kind") }

    /**
     * Returns the kind of the deployment slot as a string.
     */
    string kind() { result = this.getKind().getValue() }

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

    /**
     * Gets the HTTPS-only flag for the deployment slot.
     */
    Boolean getHttpsOnly() { result = this.getProperties().getHttpsOnly() }

    /**
     * Returns true if HTTPS-only setting is enabled for the deployment slot.
     */
    predicate isHttpsOnly() { this.getProperties().isHttpsOnly() }

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
    HostingEnvironmentsResource() {
      this.getResourceType().regexpMatch("^Microsoft.Web/hostingEnvironments@.*")
    }

    /**
     * Gets the properties object for the App Service Environment.
     */
    HostingEnvironmentsProperties::Properties getProperties() {
      result = this.getProperty("properties")
    }

    /**
     * Gets the kind of the App Service Environment.
     */
    String getKind() { result = this.getProperty("kind") }

    /**
     * Returns the kind of the App Service Environment as a string.
     */
    string kind() { result = this.getKind().getValue() }

    override string toString() {
      result = "AppServiceEnvironment[" + this.getIdentifier().getName() + "]"
    }
  }

  /**
   * Represents an extended location configuration.
   */
  class ExtendedLocation extends Object {
    private WebResource parent;

    /**
     * Constructs an ExtendedLocation object.
     */
    ExtendedLocation() { this = parent.getProperty("extendedLocation") }

    /**
     * Gets the name of the extended location.
     */
    String getName() { result = this.getProperty("name") }

    /**
     * Gets the type of the extended location.
     */
    String getType() { result = this.getProperty("type") }

    string toString() { result = "ExtendedLocation" }
  }

  /**
   * Represents a hosting environment profile configuration.
   */
  class HostingEnvironmentProfile extends Object {
    /**
     * Constructs a HostingEnvironmentProfile object.
     */
    HostingEnvironmentProfile() {
      // This object can be referenced from multiple parent types
      exists(WebResource resource | this = resource.getProperty("hostingEnvironmentProfile")) or
      exists(SitesProperties::Properties props |
        this = props.getProperty("hostingEnvironmentProfile")
      ) or
      exists(SlotProperties::Properties props |
        this = props.getProperty("hostingEnvironmentProfile")
      ) or
      exists(ServerFarmsProperties::Properties props |
        this = props.getProperty("hostingEnvironmentProfile")
      )
    }

    /**
     * Gets the ID of the hosting environment.
     */
    String getId() { result = this.getProperty("id") }

    /**
     * Gets the name of the hosting environment.
     */
    String getName() { result = this.getProperty("name") }

    string toString() { result = "HostingEnvironmentProfile" }
  }

  /**
   * Represents an application stack configuration.
   */
  class ApplicationStack extends Object {
    private SitesProperties::SiteConfig parent;

    /**
     * Constructs an ApplicationStack object.
     */
    ApplicationStack() { this = parent.getProperty("applicationStack") }

    string toString() { result = "ApplicationStack" }
  }

  /**
   * Represents app settings configuration.
   */
  class AppSettings extends Object {
    private SitesProperties::SiteConfig parent;

    /**
     * Constructs an AppSettings object.
     */
    AppSettings() { this = parent.getProperty("appSettings") }

    string toString() { result = "AppSettings" }
  }

  /**
   * Represents user-assigned identities configuration.
   */
  class UserAssignedIdentities extends Object {
    private SitesProperties::SiteIdentity parent;

    /**
     * Constructs a UserAssignedIdentities object.
     */
    UserAssignedIdentities() { this = parent.getProperty("userAssignedIdentities") }

    string toString() { result = "UserAssignedIdentities" }
  }

  /**
   * Represents repository branch configuration.
   */
  class RepositoryBranch extends Object {
    private StaticSitesProperties::Properties parent;

    /**
     * Constructs a RepositoryBranch object.
     */
    RepositoryBranch() { this = parent.getProperty("repositoryBranch") }

    /**
     * Gets the name of the branch.
     */
    String getName() { result = this.getProperty("name") }

    string toString() { result = "RepositoryBranch" }
  }

  /**
   * Represents an HTTPS certificate configuration.
   */
  class HttpsCertificate extends Object {
    private SitesProperties::HttpsCertificates parent;
    private int index;

    /**
     * Constructs an HttpsCertificate object.
     */
    HttpsCertificate() { this = parent.getElement(index) }

    /**
     * Gets the name of the certificate.
     */
    String getName() { result = this.getProperty("name") }

    /**
     * Gets the thumbprint of the certificate.
     */
    String getThumbprint() { result = this.getProperty("thumbprint") }

    string toString() { result = "HttpsCertificate" }
  }

  /**
   * Module containing properties and configurations for Microsoft.Web/sites resources.
   */
  module SitesProperties {
    /**
     * Represents the properties object for a Microsoft.Web/sites resource.
     */
    class Properties extends ResourceProperties {
      private SitesResource parent;

      /**
       * Constructs a Properties object for the given site.
       */
      Properties() { this = parent.getProperty("properties") }

      /**
       * Gets the site configuration.
       */
      SiteConfig getSiteConfig() { result = this.getProperty("siteConfig") }

      /**
       * Gets the serverFarmId (App Service Plan ID).
       */
      String getServerFarmId() { result = this.getProperty("serverFarmId") }

      /**
       * Gets the hostingEnvironmentProfile.
       */
      HostingEnvironmentProfile getHostingEnvironmentProfile() {
        result = this.getProperty("hostingEnvironmentProfile")
      }

      /**
       * Gets the public network access setting.
       */
      String getPublicNetworkAccess() { result = this.getProperty("publicNetworkAccess") }

      /**
       * Gets the HTTPS-only flag for the App Service.
       */
      Boolean getHttpsOnly() { result = this.getProperty("httpsOnly") }

      /**
       * Gets the virtualNetworkSubnetId.
       */
      String getVirtualNetworkSubnetId() {
        result = this.getProperty("virtualNetworkSubnetId") or
        result = parent.getProperty("virtualNetworkSubnetId")
      }

      /**
       * Gets the enabled value.
       */
      Boolean getEnabled() { result = this.getProperty("enabled") }

      /**
       * Returns true if the site is enabled.
       */
      predicate isEnabled() {
        exists(Boolean enabled |
          enabled = this.getEnabled() and
          enabled.getBool() = true
        )
      }

      /**
       * Gets the client certificate mode.
       */
      String getClientCertMode() { result = this.getProperty("clientCertMode") }

      /**
       * Returns true if client certificate is required.
       */
      predicate isClientCertRequired() {
        exists(String mode |
          mode = this.getClientCertMode() and
          mode.getValue() = "Required"
        )
      }

      /**
       * Gets the client certificate exclusion paths.
       */
      String getClientCertExclusionPaths() { result = this.getProperty("clientCertExclusionPaths") }

      /**
       * Gets the container size.
       */
      Number getContainerSize() { result = this.getProperty("containerSize") }

      /**
       * Gets the custom domain verification ID.
       */
      String getCustomDomainVerificationId() {
        result = this.getProperty("customDomainVerificationId")
      }

      /**
       * Gets the daily memory time quota.
       */
      Number getDailyMemoryTimeQuota() { result = this.getProperty("dailyMemoryTimeQuota") }

      /**
       * Gets the default hostname.
       */
      String getDefaultHostname() { result = this.getProperty("defaultHostname") }

      /**
       * Gets the https certificate settings.
       */
      HttpsCertificates getHttpsCertificates() { result = this.getProperty("httpsCertificates") }

      /**
       * Gets the clientAffinityEnabled flag.
       */
      Boolean getClientAffinityEnabled() {
        result = this.getProperty("clientAffinityEnabled") or
        result = parent.getProperty("clientAffinityEnabled")
      }

      /**
       * Returns true if client affinity is enabled.
       */
      predicate isClientAffinityEnabled() {
        exists(Boolean clientAffinity |
          clientAffinity = this.getClientAffinityEnabled() and
          clientAffinity.getBool() = true
        )
      }

      /**
       * Gets the clientCertEnabled flag.
       */
      Boolean getClientCertEnabled() {
        result = this.getProperty("clientCertEnabled") or
        result = parent.getProperty("clientCertEnabled")
      }

      /**
       * Returns true if client certificates are enabled.
       */
      predicate isClientCertEnabled() {
        exists(Boolean clientCert |
          clientCert = this.getClientCertEnabled() and
          clientCert.getBool() = true
        )
      }

      /**
       * Gets the hostNameSslStates array.
       */
      Array getHostNameSslStates() {
        result = this.getProperty("hostNameSslStates") or
        result = parent.getProperty("hostNameSslStates")
      }

      /**
       * Gets the hyperV setting.
       */
      Boolean getHyperV() {
        result = this.getProperty("hyperV") or
        result = parent.getProperty("hyperV")
      }

      /**
       * Returns true if Hyper-V is enabled.
       */
      predicate isHyperVEnabled() {
        exists(Boolean hyperv |
          hyperv = this.getHyperV() and
          hyperv.getBool() = true
        )
      }

      /**
       * Gets the keyVaultReferenceIdentity.
       */
      String getKeyVaultReferenceIdentity() {
        result = this.getProperty("keyVaultReferenceIdentity") or
        result = parent.getProperty("keyVaultReferenceIdentity")
      }

      /**
       * Gets the redundancyMode.
       */
      String getRedundancyMode() {
        result = this.getProperty("redundancyMode") or
        result = parent.getProperty("redundancyMode")
      }

      /**
       * Gets the storageAccountRequired flag.
       */
      Boolean getStorageAccountRequired() {
        result = this.getProperty("storageAccountRequired") or
        result = parent.getProperty("storageAccountRequired")
      }

      /**
       * Returns true if a storage account is required.
       */
      predicate isStorageAccountRequired() {
        exists(Boolean storageReq |
          storageReq = this.getStorageAccountRequired() and
          storageReq.getBool() = true
        )
      }

      /**
       * Returns true if public network access is enabled.
       */
      predicate isPublicNetworkAccessEnabled() {
        not exists(String publicNetworkAccess |
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
      private Properties parent;

      /**
       * Constructs a SiteConfig object.
       */
      SiteConfig() { this = parent.getProperty("siteConfig") }

      /**
       * Gets the minimum TLS version.
       */
      String getMinTlsVersion() { result = this.getProperty("minTlsVersion") }

      /**
       * Gets the ftps state setting.
       */
      String getFtpsState() { result = this.getProperty("ftpsState") }

      /**
       * Gets whether remote debugging is enabled.
       */
      Boolean getRemoteDebuggingEnabled() { result = this.getProperty("remoteDebuggingEnabled") }

      /**
       * Returns true if remote debugging is enabled.
       */
      predicate isRemoteDebuggingEnabled() {
        exists(Boolean debugEnabled |
          debugEnabled = this.getRemoteDebuggingEnabled() and
          debugEnabled.getBool() = true
        )
      }

      /**
       * Gets the remote debugging version.
       */
      String getRemoteDebuggingVersion() { result = this.getProperty("remoteDebuggingVersion") }

      /**
       * Gets whether HTTP 2.0 is enabled.
       */
      Boolean getHttp20Enabled() { result = this.getProperty("http20Enabled") }

      /**
       * Returns true if HTTP 2.0 is enabled.
       */
      predicate isHttp20Enabled() {
        exists(Boolean http20 |
          http20 = this.getHttp20Enabled() and
          http20.getBool() = true
        )
      }

      /**
       * Gets whether Always On is enabled.
       */
      Boolean getAlwaysOn() { result = this.getProperty("alwaysOn") }

      /**
       * Returns the Always On setting as a boolean.
       */
      boolean alwaysOn() { result = this.getAlwaysOn().getBool() }

      /**
       * Returns true if Always On is enabled.
       */
      predicate isAlwaysOn() {
        exists(Boolean alwaysOn |
          alwaysOn = this.getAlwaysOn() and
          alwaysOn.getBool() = true
        )
      }

      /**
       * Gets whether web sockets are enabled.
       */
      Boolean getWebSocketsEnabled() { result = this.getProperty("webSocketsEnabled") }

      /**
       * Returns true if web sockets are enabled.
       */
      predicate areWebSocketsEnabled() {
        exists(Boolean webSockets |
          webSockets = this.getWebSocketsEnabled() and
          webSockets.getBool() = true
        )
      }

      /**
       * Gets the application stack.
       */
      ApplicationStack getApplicationStack() { result = this.getProperty("applicationStack") }

      /**
       * Gets the connection strings.
       */
      Array getConnectionStrings() { result = this.getProperty("connectionStrings") }

      /**
       * Gets the app settings.
       */
      AppSettings getAppSettings() { result = this.getProperty("appSettings") }

      /**
       * Gets the CORS settings.
       */
      CorsSettings getCors() { result = this.getProperty("cors") }

      /**
       * Gets the Linux FX version.
       */
      String getLinuxFxVersion() { result = this.getProperty("linuxFxVersion") }

      /**
       * Gets the Windows FX version.
       */
      String getWindowsFxVersion() { result = this.getProperty("windowsFxVersion") }

      /**
       * Gets the health check path.
       */
      String getHealthCheckPath() { result = this.getProperty("healthCheckPath") }

      string toString() { result = "SiteConfig" }
    }

    /**
     * Represents the CORS settings for a site configuration.
     */
    class CorsSettings extends Object {
      private SiteConfig parent;

      /**
       * Constructs a CorsSettings object.
       */
      CorsSettings() { this = parent.getProperty("cors") }

      /**
       * Gets the allowed origins.
       */
      Array getAllowedOrigins() { result = this.getProperty("allowedOrigins") }

      /**
       * Gets whether credentials are supported.
       */
      Boolean getSupportCredentials() { result = this.getProperty("supportCredentials") }

      /**
       * Returns true if credentials are supported.
       */
      predicate areCredentialsSupported() {
        exists(Boolean credentials |
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
      private Properties parent;

      /**
       * Constructs an HttpsCertificates object.
       */
      HttpsCertificates() { this = parent.getProperty("httpsCertificates") }

      /**
       * Gets a certificate by index.
       */
      HttpsCertificate getCertificate(int index) { result = this.getElement(index) }

      string toString() { result = "HttpsCertificates" }
    }

    /**
     * Represents the identity configuration for a Microsoft.Web/sites resource.
     */
    class SiteIdentity extends Object {
      private SitesResource parent;

      /**
       * Constructs a SiteIdentity object.
       */
      SiteIdentity() { this = parent.getProperty("identity") }

      /**
       * Gets the type of managed identity.
       */
      String getType() { result = this.getProperty("type") }

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
      UserAssignedIdentities getUserAssignedIdentities() {
        result = this.getProperty("userAssignedIdentities")
      }

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
      private StaticSitesResource parent;

      /**
       * Constructs a Properties object for the given static site.
       */
      Properties() { this = parent.getProperty("properties") }

      /**
       * Gets the staging environment policy.
       */
      String getStagingEnvironmentPolicy() { result = this.getProperty("stagingEnvironmentPolicy") }

      /**
       * Gets whether private endpoint connections are allowed.
       */
      Boolean getAllowConfigFileUpdates() { result = this.getProperty("allowConfigFileUpdates") }

      /**
       * Returns true if config file updates are allowed.
       */
      predicate areConfigFileUpdatesAllowed() {
        exists(Boolean allowUpdates |
          allowUpdates = this.getAllowConfigFileUpdates() and
          allowUpdates.getBool() = true
        )
      }

      /**
       * Gets the branch configuration for the repository.
       */
      RepositoryBranch getRepositoryBranch() { result = this.getProperty("repositoryBranch") }

      /**
       * Gets the repository token for the Static Web App.
       */
      String getRepositoryToken() { result = this.getProperty("repositoryToken") }

      /**
       * Gets the repository URL for the Static Web App.
       */
      String getRepositoryUrl() { result = this.getProperty("repositoryUrl") }

      /**
       * Gets whether private endpoint connections are allowed.
       */
      Boolean getAllowPrivateEndpoints() { result = this.getProperty("allowPrivateEndpoints") }

      /**
       * Returns true if private endpoints are allowed.
       */
      predicate arePrivateEndpointsAllowed() {
        exists(Boolean allowEndpoints |
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
      private HostingEnvironmentsResource parent;

      /**
       * Constructs a Properties object for the given hosting environment.
       */
      Properties() { this = parent.getProperty("properties") }

      /**
       * Gets the dedicated host count.
       */
      Number getDedicatedHostCount() { result = this.getProperty("dedicatedHostCount") }

      /**
       * Gets whether zone redundancy is enabled.
       */
      Boolean getZoneRedundant() { result = this.getProperty("zoneRedundant") }

      /**
       * Returns true if zone redundancy is enabled.
       */
      predicate isZoneRedundant() {
        exists(Boolean zoneRedundant |
          zoneRedundant = this.getZoneRedundant() and
          zoneRedundant.getBool() = true
        )
      }

      /**
       * Gets the internal load balancing mode.
       */
      String getInternalLoadBalancingMode() {
        result = this.getProperty("internalLoadBalancingMode")
      }

      /**
       * Gets the cluster settings.
       */
      Array getClusterSettings() { result = this.getProperty("clusterSettings") }

      /**
       * Gets the virtual network configuration.
       */
      VnetConfiguration getVirtualNetworkProfile() {
        result = this.getProperty("virtualNetworkProfile")
      }

      override string toString() { result = "HostingEnvironmentProperties" }
    }

    /**
     * Represents the virtual network configuration for an App Service Environment.
     */
    class VnetConfiguration extends Object {
      private Properties parent;

      /**
       * Constructs a VnetConfiguration object.
       */
      VnetConfiguration() { this = parent.getProperty("virtualNetworkProfile") }

      /**
       * Gets the subnet ID.
       */
      String getSubnetId() { result = this.getProperty("id") }

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
      private ServerFarmsResource parent;

      /**
       * Constructs a Properties object for the given server farm.
       */
      Properties() { this = parent.getProperty("properties") }

      /**
       * Gets the compute mode.
       */
      String getComputeMode() { result = this.getProperty("computeMode") }

      /**
       * Returns the compute mode as a string.
       */
      string computeMode() { result = this.getComputeMode().getValue() }

      /**
       * Gets the worker size.
       */
      String getWorkerSize() { result = this.getProperty("workerSize") }

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
      Boolean getPerSiteScaling() { result = this.getProperty("perSiteScaling") }

      /**
       * Returns true if per-site scaling is enabled.
       */
      predicate isPerSiteScalingEnabled() {
        exists(Boolean perSiteScaling |
          perSiteScaling = this.getPerSiteScaling() and
          perSiteScaling.getBool() = true
        )
      }

      /**
       * Gets the elastic scaling setting.
       */
      Boolean getElasticScaleEnabled() { result = this.getProperty("elasticScaleEnabled") }

      /**
       * Returns true if elastic scaling is enabled.
       */
      predicate isElasticScaleEnabled() {
        exists(Boolean elasticScale |
          elasticScale = this.getElasticScaleEnabled() and
          elasticScale.getBool() = true
        )
      }

      /**
       * Gets whether zone redundant deployment is enabled.
       */
      Boolean getZoneRedundant() { result = this.getProperty("zoneRedundant") }

      /**
       * Returns true if zone redundant deployment is enabled.
       */
      predicate isZoneRedundant() {
        exists(Boolean zoneRedundant |
          zoneRedundant = this.getZoneRedundant() and
          zoneRedundant.getBool() = true
        )
      }

      /**
       * Gets the hosting environment profile.
       */
      HostingEnvironmentProfile getHostingEnvironmentProfile() {
        result = parent.getProperty("hostingEnvironmentProfile")
      }

      /**
       * Gets whether the App Service Plan is reserved (for Linux).
       */
      Boolean getReserved() { result = parent.getProperty("reserved") }

      /**
       * Returns true if the App Service Plan is reserved (for Linux).
       */
      predicate isReserved() {
        exists(Boolean reserved |
          reserved = this.getReserved() and
          reserved.getBool() = true
        )
      }

      override string toString() { result = "ServerFarmProperties" }
    }
  }

  /**
   * Module containing property classes for Deployment Slot resources.
   */
  module SlotProperties {
    /**
     * Represents the properties object for a Microsoft.Web/sites/slots resource.
     */
    class Properties extends ResourceProperties {
      private SlotResource parent;

      /**
       * Constructs a Properties object for the given slot.
       */
      Properties() { this = parent.getProperty("properties") }

      /**
       * Gets the HTTPS-only flag for the deployment slot.
       */
      Boolean getHttpsOnly() {
        result = this.getProperty("httpsOnly") or
        result = parent.getProperty("httpsOnly")
      }

      /**
       * Returns true if HTTPS-only setting is enabled for the deployment slot.
       */
      predicate isHttpsOnly() {
        exists(Boolean httpsOnly |
          httpsOnly = this.getHttpsOnly() and
          httpsOnly.getBool() = true
        )
      }

      /**
       * Gets the site configuration.
       */
      SitesProperties::SiteConfig getSiteConfig() { result = this.getProperty("siteConfig") }

      /**
       * Gets the serverFarmId (App Service Plan ID).
       */
      String getServerFarmId() { result = this.getProperty("serverFarmId") }

      /**
       * Gets the hostingEnvironmentProfile.
       */
      HostingEnvironmentProfile getHostingEnvironmentProfile() {
        result = this.getProperty("hostingEnvironmentProfile")
      }

      override string toString() { result = "SlotProperties" }
    }
  }
}
