private import bicep
private import codeql.bicep.Concepts
private import codeql.bicep.frameworks.Microsoft.General

module AKS {
  private import ManagedContainerProperties

  /**
   * Represents a Microsoft.ContainerService/managedClusters resource (AKS) in a Bicep file.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters
   */
  class ManagedContainerResource extends AzureResource {
    /**
     * Constructs a ManagedContainerResource for Microsoft.ContainerService/managedClusters resources.
     */
    ManagedContainerResource() {
      this.getResourceType().regexpMatch("^Microsoft.ContainerService/managedClusters@.*")
    }

    /**
     * Returns the properties object for the AKS resource.
     */
    Properties getProperties() {
      result = this.getProperty("properties")
    }

    /**
     * Returns the identity configuration for the cluster.
     */
    ManagedContainerIdentity getIdentity() { result = this.getProperty("identity") }

    /**
     * Returns the extended location configuration.
     */
    Expr getExtendedLocation() { result = this.getProperty("extendedLocation") }

    /**
     * Returns the kind property.
     */
    StringLiteral getKind() { result = this.getProperty("kind") }

    /**
     * Returns the kubernetesVersion property.
     */
    StringLiteral getKubernetesVersion() { result = this.getProperties().getKubernetesVersion() }

    /**
     * Returns the dnsPrefix property.
     */
    StringLiteral getDnsPrefix() { result = this.getProperties().getDnsPrefix() }

    /**
     * Returns the agentPoolProfiles property.
     */
    ManagedContainerProperties::AgentPoolProfile getAgentPoolProfiles() {
      result = this.getProperties().getAgentPoolProfiles()
    }

    /**
     * Returns the networkProfile property.
     */
    Network::NetworkProfile getNetworkProfile() {
      result = this.getProperties().getNetworkProfile()
    }

    /**
     * Returns the API server access profile.
     */
    ManagedContainerProperties::ApiServerAccessProfile getApiServerAccessProfile() {
      result = this.getProperties().getApiServerAccessProfile()
    }

    /**
     * Returns the addon profiles.
     */
    ManagedContainerProperties::AddonProfiles getAddonProfiles() {
      result = this.getProperties().getAddonProfiles()
    }

    /**
     * Returns the security profile.
     */
    SecurityProfile getSecurityProfile() {
      result = this.getProperties().getSecurityProfile()
    }

    /**
     * Returns the auto scaler profile.
     */
    AutoScalerProfile getAutoScalerProfile() {
      result = this.getProperties().getAutoScalerProfile()
    }

    /**
     * Returns the Azure Monitor profile.
     */
    AzureMonitorProfile getAzureMonitorProfile() {
      result = this.getProperties().getAzureMonitorProfile()
    }

    override string toString() { result = "ManagedContainerResource" }
  }


  /**
   * Represents the identity configuration for a managed cluster.
   */
  class ManagedContainerIdentity extends Object {
    ManagedContainerIdentity() { any() }

    /**
     * Gets the identity type.
     */
    StringLiteral getType() { result = this.getProperty("type") }

    /**
     * Gets user assigned identities.
     */
    Expr getUserAssignedIdentities() { result = this.getProperty("userAssignedIdentities") }

    /**
     * Gets delegated resources.
     */
    Expr getDelegatedResources() { result = this.getProperty("delegatedResources") }

    /**
     * Returns the type as a string.
     */
    string getIdentityType() { result = this.getType().getValue() }

    /**
     * Checks if the identity type is set.
     */
    predicate hasType() { exists(this.getType()) }

    /**
     * Checks if user assigned identities are configured.
     */
    predicate hasUserAssignedIdentities() { exists(this.getUserAssignedIdentities()) }
  }

  /**
   * Module containing property classes for managed AKS (Azure Kubernetes Service) resources.
   * Provides access to resource configuration, agent pools, network, API server, and addon profiles.
   */
  module ManagedContainerProperties {
    /**
     * Represents the properties object for a Kubernetes (AKS) resource.
     * Provides access to core configuration such as version, DNS prefix, agent pools, network, and more.
     */
    class Properties extends ResourceProperties {
      private ManagedContainerResource resource;

      /**
       * Constructs a Properties object for the given managed AKS resource.
       */
      Properties() { this = resource.getProperty("properties") }

      /**
       * Gets the parent ManagedContainerResource.
       */
      ManagedContainerResource getManagedContainerResource() { result = resource }

      /**
       * Gets the Kubernetes version property.
       */
      StringLiteral getKubernetesVersion() { result = this.getProperty("kubernetesVersion") }

      /**
       * Returns the Kubernetes version as a string.
       */
      string kubernetesVersion() { result = this.getKubernetesVersion().getValue() }

      /**
       * Gets the DNS prefix property.
       */
      StringLiteral getDnsPrefix() { result = this.getProperty("dnsPrefix") }

      /**
       * Returns the DNS prefix as a string.
       */
      string dnsPrefix() { result = this.getDnsPrefix().getValue() }

      /**
       * Gets the agent pool profiles for the cluster.
       */
      AgentPoolProfile getAgentPoolProfiles() {
        result = this.getProperty("agentPoolProfiles").(Array).getElements()
      }

      /**
       * Gets the network profile for the cluster.
       */
      Network::NetworkProfile getNetworkProfile() { result = this.getProperty("networkProfile") }

      /**
       * Gets the API server access profile for the cluster.
       */
      ApiServerAccessProfile getApiServerAccessProfile() {
        result = this.getProperty("apiServerAccessProfile")
      }

      /**
       * Gets the addon profiles for the cluster.
       */
      AddonProfiles getAddonProfiles() { result = this.getProperty("addonProfiles") }

      /**
       * Gets the AAD profile for the cluster.
       */
      AADProfile getAadProfile() { result = this.getProperty("aadProfile") }

      /**
       * Gets the auto scaler profile for the cluster.
       */
      AutoScalerProfile getAutoScalerProfile() { result = this.getProperty("autoScalerProfile") }

      /**
       * Gets the auto upgrade profile for the cluster.
       */
      AutoUpgradeProfile getAutoUpgradeProfile() { result = this.getProperty("autoUpgradeProfile") }

      /**
       * Gets the Azure Monitor profile for the cluster.
       */
      AzureMonitorProfile getAzureMonitorProfile() { result = this.getProperty("azureMonitorProfile") }

      /**
       * Gets the bootstrap profile for the cluster.
       */
      Expr getBootstrapProfile() { result = this.getProperty("bootstrapProfile") }

      /**
       * Gets the creation data for the cluster.
       */
      Expr getCreationData() { result = this.getProperty("creationData") }

      /**
       * Gets the security profile for the cluster.
       */
      SecurityProfile getSecurityProfile() { result = this.getProperty("securityProfile") }

      /**
       * Gets the service mesh profile for the cluster.
       */
      ServiceMeshProfile getServiceMeshProfile() { result = this.getProperty("serviceMeshProfile") }

      /**
       * Gets the storage profile for the cluster.
       */
      StorageProfile getStorageProfile() { result = this.getProperty("storageProfile") }

      /**
       * Gets the workload auto scaler profile for the cluster.
       */
      WorkloadAutoScalerProfile getWorkloadAutoScalerProfile() {
        result = this.getProperty("workloadAutoScalerProfile")
      }

      /**
       * Gets the Windows profile for the cluster.
       */
      Profiles::WindowsProfile getWindowsProfile() { result = this.getProperty("windowsProfile") }

      /**
       * Gets the Linux profile for the cluster.
       */
      Profiles::LinuxProfile getLinuxProfile() { result = this.getProperty("linuxProfile") }

      /**
       * Gets the HTTP proxy configuration for the cluster.
       */
      HttpProxyConfig getHttpProxyConfig() { result = this.getProperty("httpProxyConfig") }

      /**
       * Gets the pod identity profile for the cluster.
       */
      PodIdentityProfile getPodIdentityProfile() { result = this.getProperty("podIdentityProfile") }

      /**
       * Gets the service principal profile for the cluster.
       */
      ServicePrincipalProfile getServicePrincipalProfile() {
        result = this.getProperty("servicePrincipalProfile")
      }

      /**
       * Gets the identity profile for the cluster.
       */
      Expr getIdentityProfile() { result = this.getProperty("identityProfile") }

      /**
       * Gets the ingress profile for the cluster.
       */
      IngressProfile getIngressProfile() { result = this.getProperty("ingressProfile") }

      /**
       * Gets the metrics profile for the cluster.
       */
      MetricsProfile getMetricsProfile() { result = this.getProperty("metricsProfile") }

      /**
       * Gets the node provisioning profile for the cluster.
       */
      Expr getNodeProvisioningProfile() { result = this.getProperty("nodeProvisioningProfile") }

      /**
       * Gets the node resource group name.
       */
      StringLiteral getNodeResourceGroup() { result = this.getProperty("nodeResourceGroup") }

      /**
       * Gets the node resource group profile.
       */
      Expr getNodeResourceGroupProfile() { result = this.getProperty("nodeResourceGroupProfile") }

      /**
       * Gets the OIDC issuer profile.
       */
      OidcIssuerProfile getOidcIssuerProfile() { result = this.getProperty("oidcIssuerProfile") }

      /**
       * Gets private link resources.
       */
      Expr getPrivateLinkResources() { result = this.getProperty("privateLinkResources") }

      /**
       * Gets the public network access setting.
       */
      StringLiteral getPublicNetworkAccess() { result = this.getProperty("publicNetworkAccess") }

      /**
       * Gets the safeguards profile.
       */
      SafeguardsProfile getSafeguardsProfile() { result = this.getProperty("safeguardsProfile") }

      /**
       * Gets the scheduler profile.
       */
      Expr getSchedulerProfile() { result = this.getProperty("schedulerProfile") }

      /**
       * Gets the support plan.
       */
      StringLiteral getSupportPlan() { result = this.getProperty("supportPlan") }

      /**
       * Gets the upgrade settings.
       */
      Expr getUpgradeSettings() { result = this.getProperty("upgradeSettings") }

      /**
       * Gets the AI toolchain operator profile.
       */
      AIToolchainOperatorProfile getAiToolchainOperatorProfile() {
        result = this.getProperty("aiToolchainOperatorProfile")
      }

      /**
       * Gets the disk encryption set ID.
       */
      StringLiteral getDiskEncryptionSetID() { result = this.getProperty("diskEncryptionSetID") }

      /**
       * Gets the FQDN subdomain.
       */
      StringLiteral getFqdnSubdomain() { result = this.getProperty("fqdnSubdomain") }

      /**
       * Gets whether local accounts are disabled.
       */
      Boolean getDisableLocalAccounts() { result = this.getProperty("disableLocalAccounts") }

      /**
       * Gets whether namespace resources are enabled.
       */
      Boolean getEnableNamespaceResources() { result = this.getProperty("enableNamespaceResources") }

      /**
       * Gets whether RBAC is enabled.
       */
      Boolean getEnableRBAC() { result = this.getProperty("enableRBAC") }

      /**
       * Checks if the cluster has a specific Kubernetes version.
       */
      predicate hasKubernetesVersion() { exists(this.getKubernetesVersion()) }

      /**
       * Checks if the cluster has a DNS prefix.
       */
      predicate hasDnsPrefix() { exists(this.getDnsPrefix()) }

      /**
       * Checks if the cluster has agent pool profiles.
       */
      predicate hasAgentPoolProfiles() { exists(this.getAgentPoolProfiles()) }

      /**
       * Checks if the cluster has a network profile.
       */
      predicate hasNetworkProfile() { exists(this.getNetworkProfile()) }

      /**
       * Checks if the cluster has an API server access profile.
       */
      predicate hasApiServerAccessProfile() { exists(this.getApiServerAccessProfile()) }

      /**
       * Checks if the cluster has addon profiles.
       */
      predicate hasAddonProfiles() { exists(this.getAddonProfiles()) }

      /**
       * Checks if the cluster has a security profile.
       */
      predicate hasSecurityProfile() { exists(this.getSecurityProfile()) }

      string getToString() { result = "ManagedContainerProperties" }
    }

    /**
     * Represents the agent pool profiles for a managed AKS cluster.
     * Provides access to properties such as name, VM size, count, OS type, mode, autoscaling, and scaling limits.
     */
    class AgentPoolProfile extends Object {
      private Properties properties;

      /**
       * Constructs an AgentPoolProfile object for the given properties.
       */
      AgentPoolProfile() {
        this = properties.getProperty("agentPoolProfiles").(Array).getElements()
      }

      /**
       * Gets the name of the agent pool.
       */
      StringLiteral getName() { result = this.getProperty("name") }

      /**
       * Gets the VM size for the agent pool.
       */
      StringLiteral getVmSize() { result = this.getProperty("vmSize") }

      /**
       * Gets the node count for the agent pool.
       */
      Number getCount() { result = this.getProperty("count") }

      /**
       * Gets the OS type for the agent pool.
       */
      StringLiteral getOsType() { result = this.getProperty("osType") }

      /**
       * Gets the OS SKU for the agent pool.
       */
      StringLiteral getOsSKU() { result = this.getProperty("osSKU") }

      /**
       * Gets the mode for the agent pool (e.g., System, User, Gateway).
       */
      StringLiteral getMode() { result = this.getProperty("mode") }

      /**
       * Gets whether autoscaling is enabled for the agent pool.
       */
      Boolean getEnableAutoScaling() { result = this.getProperty("enableAutoScaling") }

      /**
       * Gets the minimum node count for autoscaling.
       */
      Number getMinCount() { result = this.getProperty("minCount") }

      /**
       * Gets the maximum node count for autoscaling.
       */
      Number getMaxCount() { result = this.getProperty("maxCount") }

      /**
       * Gets the maximum number of pods per node.
       */
      Number getMaxPods() { result = this.getProperty("maxPods") }

      /**
       * Gets the OS disk size in GB.
       */
      Number getOsDiskSizeGB() { result = this.getProperty("osDiskSizeGB") }

      /**
       * Gets the OS disk type.
       */
      StringLiteral getOsDiskType() { result = this.getProperty("osDiskType") }

      /**
       * Gets the kubelet disk type.
       */
      StringLiteral getKubeletDiskType() { result = this.getProperty("kubeletDiskType") }

      /**
       * Gets the workload runtime.
       */
      StringLiteral getWorkloadRuntime() { result = this.getProperty("workloadRuntime") }

      /**
       * Gets the orchestrator version.
       */
      StringLiteral getOrchestratorVersion() { result = this.getProperty("orchestratorVersion") }

      /**
       * Gets the availability zones.
       */
      Expr getAvailabilityZones() { result = this.getProperty("availabilityZones") }

      /**
       * Gets whether node public IP is enabled.
       */
      Boolean getEnableNodePublicIP() { result = this.getProperty("enableNodePublicIP") }

      /**
       * Gets whether encryption at host is enabled.
       */
      Boolean getEnableEncryptionAtHost() { result = this.getProperty("enableEncryptionAtHost") }

      /**
       * Gets whether FIPS is enabled.
       */
      Boolean getEnableFIPS() { result = this.getProperty("enableFIPS") }

      /**
       * Gets whether Ultra SSD is enabled.
       */
      Boolean getEnableUltraSSD() { result = this.getProperty("enableUltraSSD") }

      /**
       * Gets whether custom CA trust is enabled.
       */
      Boolean getEnableCustomCATrust() { result = this.getProperty("enableCustomCATrust") }

      /**
       * Gets the GPU instance profile.
       */
      StringLiteral getGpuInstanceProfile() { result = this.getProperty("gpuInstanceProfile") }

      /**
       * Gets the GPU profile.
       */
      Expr getGpuProfile() { result = this.getProperty("gpuProfile") }

      /**
       * Gets the kubelet configuration.
       */
      Expr getKubeletConfig() { result = this.getProperty("kubeletConfig") }

      /**
       * Gets the Linux OS configuration.
       */
      Expr getLinuxOSConfig() { result = this.getProperty("linuxOSConfig") }

      /**
       * Gets the network profile.
       */
      Expr getNetworkProfile() { result = this.getProperty("networkProfile") }

      /**
       * Gets the security profile.
       */
      Expr getSecurityProfile() { result = this.getProperty("securityProfile") }

      /**
       * Gets the upgrade settings.
       */
      Expr getUpgradeSettings() { result = this.getProperty("upgradeSettings") }

      /**
       * Gets the Windows profile.
       */
      Expr getWindowsProfile() { result = this.getProperty("windowsProfile") }

      /**
       * Gets the power state.
       */
      Expr getPowerState() { result = this.getProperty("powerState") }

      /**
       * Gets the proximity placement group ID.
       */
      StringLiteral getProximityPlacementGroupID() { result = this.getProperty("proximityPlacementGroupID") }

      /**
       * Gets the scale down mode.
       */
      StringLiteral getScaleDownMode() { result = this.getProperty("scaleDownMode") }

      /**
       * Gets the scale set eviction policy.
       */
      StringLiteral getScaleSetEvictionPolicy() { result = this.getProperty("scaleSetEvictionPolicy") }

      /**
       * Gets the scale set priority.
       */
      StringLiteral getScaleSetPriority() { result = this.getProperty("scaleSetPriority") }

      /**
       * Gets the spot max price.
       */
      Number getSpotMaxPrice() { result = this.getProperty("spotMaxPrice") }

      /**
       * Gets the subnet ID.
       */
      StringLiteral getVnetSubnetID() { result = this.getProperty("vnetSubnetID") }

      /**
       * Gets the pod subnet ID.
       */
      StringLiteral getPodSubnetID() { result = this.getProperty("podSubnetID") }

      /**
       * Gets the node labels.
       */
      Expr getNodeLabels() { result = this.getProperty("nodeLabels") }

      /**
       * Gets the node taints.
       */
      Expr getNodeTaints() { result = this.getProperty("nodeTaints") }

      /**
       * Gets the node initialization taints.
       */
      Expr getNodeInitializationTaints() { result = this.getProperty("nodeInitializationTaints") }

      /**
       * Gets the tags.
       */
      Expr getTags() { result = this.getProperty("tags") }

      /**
       * Returns the name as a string.
       */
      string name() { result = this.getName().getValue() }

      /**
       * Returns the VM size as a string.
       */
      string vmSize() { result = this.getVmSize().getValue() }

      /**
       * Returns the count as an integer.
       */
      int getCountValue() { 
        result = this.getCount().getValue()
      }

      /**
       * Returns the OS type as a string.
       */
      string osType() { result = this.getOsType().getValue() }

      /**
       * Returns the mode as a string.
       */
      string mode() { result = this.getMode().getValue() }

      /**
       * Checks if autoscaling is enabled.
       */
      predicate isAutoScalingEnabled() { this.getEnableAutoScaling().getBool() = true }

      /**
       * Checks if node public IP is enabled.
       */
      predicate isNodePublicIPEnabled() { this.getEnableNodePublicIP().getBool() = true }

      /**
       * Checks if encryption at host is enabled.
       */
      predicate isEncryptionAtHostEnabled() { this.getEnableEncryptionAtHost().getBool() = true }

      /**
       * Checks if FIPS is enabled.
       */
      predicate isFIPSEnabled() { this.getEnableFIPS().getBool() = true }

      /**
       * Checks if the agent pool has a specific name.
       */
      predicate hasName() { exists(this.getName()) }

      /**
       * Checks if the agent pool has a VM size specified.
       */
      predicate hasVmSize() { exists(this.getVmSize()) }

      /**
       * Checks if the agent pool has a count specified.
       */
      predicate hasCount() { exists(this.getCount()) }

      string getToString() { result = "AgentPoolProfile" }
    }

    /**
     * Represents the API server access profile for a managed AKS cluster.
     * Provides access to properties such as enablePrivateCluster and privateDnsZone.
     */
    class ApiServerAccessProfile extends Object {
      private Properties properties;

      /**
       * Constructs an ApiServerAccessProfile object for the given properties.
       */
      ApiServerAccessProfile() { this = properties.getProperty("apiServerAccessProfile") }

      /**
       * Gets the enablePrivateCluster property.
       */
      Boolean getEnablePrivateCluster() { result = this.getProperty("enablePrivateCluster") }

      boolean enablePrivateCluster() {
        result = this.getEnablePrivateCluster().getBool()
      }

      /**
       * Gets the privateDnsZone property.
       */
      StringLiteral getPrivateDnsZone() { result = this.getProperty("privateDnsZone") }

      string toString() { result = "ApiServerAccessProfile" }
    }

    /**
     * Represents the addon profiles for a managed AKS cluster.
     * Provides access to specific addons such as kubeDashboard and azurePolicy.
     */
    class AddonProfiles extends Object {
      private Properties properties;

      /**
       * Constructs an AddonProfiles object for the given properties.
       */
      AddonProfiles() { this = properties.getProperty("addonProfiles") }

      /**
       * Gets the kubeDashboard addon profile.
       */
      AddonKubeDashboard getKubeDashboard() { result = this.getProperty("kubeDashboard") }

      string toString() { result = "AddonProfiles" }
    }

    /**
     * Represents the kubeDashboard addon profile for a managed AKS cluster.
     */
    class AddonKubeDashboard extends Object {
      private AddonProfiles profiles;

      /**
       * Constructs an AddonKubeDashboard object for the given addon profiles.
       */
      AddonKubeDashboard() { this = profiles.getProperty("kubeDashboard") }

      /**
       * Gets the enabled property for the kubeDashboard addon.
       */
      Boolean getEnabled() { result = this.getProperty("enabled") }

      boolean enabled() {
        result = this.getEnabled().getBool()
      }

      string toString() { result = "AddonKubeDashboard" }
    }

    /**
     * Represents the azurePolicy addon profile for a managed AKS cluster.
     */
    class AddonAzurePolicy extends Object {
      private AddonProfiles profiles;

      /**
       * Constructs an AddonAzurePolicy object for the given addon profiles.
       */
      AddonAzurePolicy() { this = profiles.getProperty("azurePolicy") }

      /**
       * Gets the enabled property for the azurePolicy addon.
       */
      Boolean getEnabled() { result = this.getProperty("enabled") }

      string toString() { result = "AddonAzurePolicy" }
    }

    /**
     * Represents the AAD profile for a managed AKS cluster.
     */
    class AADProfile extends Object {
      private Properties properties;

      /**
       * Constructs an AADProfile object for the given properties.
       */
      AADProfile() { this = properties.getProperty("aadProfile") }

      /**
       * Gets the managed property.
       */
      Boolean getManaged() { result = this.getProperty("managed") }

      /**
       * Gets the enable Azure RBAC property.
       */
      Boolean getEnableAzureRBAC() { result = this.getProperty("enableAzureRBAC") }

      /**
       * Gets the admin group object IDs.
       */
      Array getAdminGroupObjectIDs() { result = this.getProperty("adminGroupObjectIDs") }

      /**
       * Gets the tenant ID.
       */
      StringLiteral getTenantID() { result = this.getProperty("tenantID") }

      /**
       * Checks if AAD integration is managed.
       */
      predicate isManaged() { this.getManaged().getBool() = true }

      /**
       * Checks if Azure RBAC is enabled.
       */
      predicate isAzureRBACEnabled() { this.getEnableAzureRBAC().getBool() = true }

      /**
       * Checks if admin group object IDs are specified.
       */
      predicate hasAdminGroupObjectIDs() { exists(this.getAdminGroupObjectIDs()) }

      string toString() { result = "AADProfile" }
    }

    /**
     * Represents the auto scaler profile for a managed AKS cluster.
     */
    class AutoScalerProfile extends Object {
      private Properties properties;

      /**
       * Constructs an AutoScalerProfile object for the given properties.
       */
      AutoScalerProfile() { this = properties.getProperty("autoScalerProfile") }

      /**
       * Gets the balance similar node groups property.
       */
      Boolean getBalanceSimilarNodeGroups() { result = this.getProperty("balanceSimilarNodeGroups") }

      /**
       * Gets the expander property.
       */
      StringLiteral getExpander() { result = this.getProperty("expander") }

      /**
       * Gets the max empty bulk delete property.
       */
      Number getMaxEmptyBulkDelete() { result = this.getProperty("maxEmptyBulkDelete") }

      /**
       * Gets the new pod scale up delay property.
       */
      StringLiteral getNewPodScaleUpDelay() { result = this.getProperty("newPodScaleUpDelay") }

      /**
       * Gets the scale down delay after add property.
       */
      StringLiteral getScaleDownDelayAfterAdd() { result = this.getProperty("scaleDownDelayAfterAdd") }

      /**
       * Gets the scale down delay after delete property.
       */
      StringLiteral getScaleDownDelayAfterDelete() { result = this.getProperty("scaleDownDelayAfterDelete") }

      /**
       * Gets the scale down delay after failure property.
       */
      StringLiteral getScaleDownDelayAfterFailure() { result = this.getProperty("scaleDownDelayAfterFailure") }

      /**
       * Gets the scan interval property.
       */
      StringLiteral getScanInterval() { result = this.getProperty("scanInterval") }

      /**
       * Gets the skip nodes with local storage property.
       */
      Boolean getSkipNodesWithLocalStorage() { result = this.getProperty("skipNodesWithLocalStorage") }

      /**
       * Gets the skip nodes with system pods property.
       */
      Boolean getSkipNodesWithSystemPods() { result = this.getProperty("skipNodesWithSystemPods") }

      string toString() { result = "AutoScalerProfile" }
    }

    /**
     * Represents the auto upgrade profile for a managed AKS cluster.
     */
    class AutoUpgradeProfile extends Object {
      private Properties properties;

      /**
       * Constructs an AutoUpgradeProfile object for the given properties.
       */
      AutoUpgradeProfile() { this = properties.getProperty("autoUpgradeProfile") }

      /**
       * Gets the upgrade channel property.
       */
      StringLiteral getUpgradeChannel() { result = this.getProperty("upgradeChannel") }

      /**
       * Gets the node OS upgrade channel property.
       */
      StringLiteral getNodeOSUpgradeChannel() { result = this.getProperty("nodeOSUpgradeChannel") }

      /**
       * Gets the node OS upgrade management property.
       */
      Expr getNodeOSUpgradeManagement() { result = this.getProperty("nodeOSUpgradeManagement") }

      /**
       * Gets the auto upgrade channels property.
       */
      Expr getAutoUpgradeChannels() { result = this.getProperty("autoUpgradeChannels") }

      string toString() { result = "AutoUpgradeProfile" }
    }

    /**
     * Represents the Azure Monitor profile for a managed AKS cluster.
     */
    class AzureMonitorProfile extends Object {
      private Properties properties;

      /**
       * Constructs an AzureMonitorProfile object for the given properties.
       */
      AzureMonitorProfile() { this = properties.getProperty("azureMonitorProfile") }

      /**
       * Gets the metrics property.
       */
      Expr getMetrics() { result = this.getProperty("metrics") }

      /**
       * Gets the logs property.
       */
      Expr getLogs() { result = this.getProperty("logs") }

      /**
       * Gets the profiles property.
       */
      Expr getProfiles() { result = this.getProperty("profiles") }

      string toString() { result = "AzureMonitorProfile" }
    }

    /**
     * Represents the security profile for a managed AKS cluster.
     */
    class SecurityProfile extends Object {
      private Properties properties;

      /**
       * Constructs a SecurityProfile object for the given properties.
       */
      SecurityProfile() { this = properties.getProperty("securityProfile") }

      /**
       * Gets the Azure Key Vault KMS property.
       */
      Expr getAzureKeyVaultKms() { result = this.getProperty("azureKeyVaultKms") }

      /**
       * Gets the defender property.
       */
      Expr getDefender() { result = this.getProperty("defender") }

      /**
       * Gets the image cleaner property.
       */
      Expr getImageCleaner() { result = this.getProperty("imageCleaner") }

      /**
       * Gets the node restriction property.
       */
      Expr getNodeRestriction() { result = this.getProperty("nodeRestriction") }

      /**
       * Gets the workload identity property.
       */
      Expr getWorkloadIdentity() { result = this.getProperty("workloadIdentity") }

      string toString() { result = "SecurityProfile" }
    }

    /**
     * Represents the service mesh profile for a managed AKS cluster.
     */
    class ServiceMeshProfile extends Object {
      private Properties properties;

      /**
       * Constructs a ServiceMeshProfile object for the given properties.
       */
      ServiceMeshProfile() { this = properties.getProperty("serviceMeshProfile") }

      /**
       * Gets the mode property.
       */
      StringLiteral getMode() { result = this.getProperty("mode") }

      /**
       * Gets whether Istio is enabled.
       */
      Boolean getIstioEnabled() { result = this.getProperty("istioEnabled") }

      string toString() { result = "ServiceMeshProfile" }
    }

    /**
     * Represents the storage profile for a managed AKS cluster.
     */
    class StorageProfile extends Object {
      private Properties properties;

      /**
       * Constructs a StorageProfile object for the given properties.
       */
      StorageProfile() { this = properties.getProperty("storageProfile") }

      /**
       * Gets the blob CSI driver property.
       */
      Expr getBlobCSIDriver() { result = this.getProperty("blobCSIDriver") }

      /**
       * Gets the disk CSI driver property.
       */
      Expr getDiskCSIDriver() { result = this.getProperty("diskCSIDriver") }

      /**
       * Gets the file CSI driver property.
       */
      Expr getFileCSIDriver() { result = this.getProperty("fileCSIDriver") }

      /**
       * Gets the snapshot controller property.
       */
      Expr getSnapshotController() { result = this.getProperty("snapshotController") }

      string toString() { result = "StorageProfile" }
    }

    /**
     * Represents the workload auto scaler profile for a managed AKS cluster.
     */
    class WorkloadAutoScalerProfile extends Object {
      private Properties properties;

      /**
       * Constructs a WorkloadAutoScalerProfile object for the given properties.
       */
      WorkloadAutoScalerProfile() { this = properties.getProperty("workloadAutoScalerProfile") }

      /**
       * Gets the keda property.
       */
      Expr getKeda() { result = this.getProperty("keda") }

      /**
       * Gets the vertical pod autoscaler property.
       */
      Expr getVerticalPodAutoscaler() { result = this.getProperty("verticalPodAutoscaler") }

      string toString() { result = "WorkloadAutoScalerProfile" }
    }

    /**
     * Represents the HTTP proxy config for a managed AKS cluster.
     */
    class HttpProxyConfig extends Object {
      private Properties properties;

      /**
       * Constructs an HttpProxyConfig object for the given properties.
       */
      HttpProxyConfig() { this = properties.getProperty("httpProxyConfig") }

      /**
       * Gets the HTTP proxy property.
       */
      StringLiteral getHttpProxy() { result = this.getProperty("httpProxy") }

      /**
       * Gets the HTTPS proxy property.
       */
      StringLiteral getHttpsProxy() { result = this.getProperty("httpsProxy") }

      /**
       * Gets the no proxy property.
       */
      Array getNoProxy() { result = this.getProperty("noProxy") }

      /**
       * Gets the trusted CA property.
       */
      StringLiteral getTrustedCa() { result = this.getProperty("trustedCa") }

      string toString() { result = "HttpProxyConfig" }
    }

    /**
     * Represents the pod identity profile for a managed AKS cluster.
     */
    class PodIdentityProfile extends Object {
      private Properties properties;

      /**
       * Constructs a PodIdentityProfile object for the given properties.
       */
      PodIdentityProfile() { this = properties.getProperty("podIdentityProfile") }

      /**
       * Gets whether pod identity is enabled.
       */
      Boolean getEnabled() { result = this.getProperty("enabled") }

      /**
       * Gets whether pod identity is in user assigned mode.
       */
      Boolean getUserAssignedIdentityExceptions() { result = this.getProperty("userAssignedIdentityExceptions") }

      string toString() { result = "PodIdentityProfile" }
    }

    /**
     * Represents the service principal profile for a managed AKS cluster.
     */
    class ServicePrincipalProfile extends Object {
      private Properties properties;

      /**
       * Constructs a ServicePrincipalProfile object for the given properties.
       */
      ServicePrincipalProfile() { this = properties.getProperty("servicePrincipalProfile") }

      /**
       * Gets the client ID property.
       */
      StringLiteral getClientId() { result = this.getProperty("clientId") }

      /**
       * Gets the secret property.
       */
      StringLiteral getSecret() { result = this.getProperty("secret") }

      string toString() { result = "ServicePrincipalProfile" }
    }

    /**
     * Represents the ingress profile for a managed AKS cluster.
     */
    class IngressProfile extends Object {
      private Properties properties;

      /**
       * Constructs an IngressProfile object for the given properties.
       */
      IngressProfile() { this = properties.getProperty("ingressProfile") }

      /**
       * Gets the WebApplicationFirewallProfile property.
       */
      Expr getWebApplicationFirewallProfile() { result = this.getProperty("webApplicationFirewallProfile") }

      string toString() { result = "IngressProfile" }
    }

    /**
     * Represents the metrics profile for a managed AKS cluster.
     */
    class MetricsProfile extends Object {
      private Properties properties;

      /**
       * Constructs a MetricsProfile object for the given properties.
       */
      MetricsProfile() { this = properties.getProperty("metricsProfile") }

      /**
       * Gets whether metrics is enabled.
       */
      Boolean getEnabled() { result = this.getProperty("enabled") }

      string toString() { result = "MetricsProfile" }
    }

    /**
     * Represents the OIDC issuer profile for a managed AKS cluster.
     */
    class OidcIssuerProfile extends Object {
      private Properties properties;

      /**
       * Constructs an OidcIssuerProfile object for the given properties.
       */
      OidcIssuerProfile() { this = properties.getProperty("oidcIssuerProfile") }

      /**
       * Gets whether the OIDC issuer is enabled.
       */
      Boolean getEnabled() { result = this.getProperty("enabled") }

      /**
       * Gets the OIDC issuer URL.
       */
      StringLiteral getIssuerURL() { result = this.getProperty("issuerURL") }

      string toString() { result = "OidcIssuerProfile" }
    }

    /**
     * Represents the safeguards profile for a managed AKS cluster.
     */
    class SafeguardsProfile extends Object {
      private Properties properties;

      /**
       * Constructs a SafeguardsProfile object for the given properties.
       */
      SafeguardsProfile() { this = properties.getProperty("safeguardsProfile") }

      /**
       * Gets whether safeguards are enabled.
       */
      Boolean getEnabled() { result = this.getProperty("enabled") }

      string toString() { result = "SafeguardsProfile" }
    }

    /**
     * Represents the AI toolchain operator profile for a managed AKS cluster.
     */
    class AIToolchainOperatorProfile extends Object {
      private Properties properties;

      /**
       * Constructs an AIToolchainOperatorProfile object for the given properties.
       */
      AIToolchainOperatorProfile() { this = properties.getProperty("aiToolchainOperatorProfile") }

      /**
       * Gets whether the AI toolchain operator is enabled.
       */
      Boolean getEnabled() { result = this.getProperty("enabled") }

      string toString() { result = "AIToolchainOperatorProfile" }
    }
  }
}
