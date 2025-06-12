private import bicep
private import codeql.bicep.Concepts

module ManagedContainers {
  /**
   * Represents a Microsoft.ContainerService/managedClusters resource (AKS) in a Bicep file.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters
   */
  class ManagedContainerResource extends Resource {
    /**
     * Constructs a ManagedContainerResource for Microsoft.ContainerService/managedClusters resources.
     */
    ManagedContainerResource() {
      this.getResourceType().regexpMatch("^Microsoft.ContainerService/managedClusters@.*")
    }

    /**
     * Returns the properties object for the AKS resource.
     */
    ManagedContainerProperties::Properties getProperties() {
      result = this.getProperty("properties")
    }

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
    ManagedContainerProperties::AgentPoolProfiles getAgentPoolProfiles() {
      result = this.getProperties().getAgentPoolProfiles()
    }

    /**
     * Returns the networkProfile property.
     */
    Network::NetworkProfile getNetworkProfile() {
      result = this.getProperties().getNetworkProfile()
    }

    override string toString() { result = "ManagedContainerResource" }
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
       * Gets the DNS prefix property.
       */
      StringLiteral getDnsPrefix() { result = this.getProperty("dnsPrefix") }

      /**
       * Gets the agent pool profiles for the cluster.
       */
      AgentPoolProfiles getAgentPoolProfiles() {
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
       * Gets the identity property for the cluster.
       */
      Expr getIdentity() { result = this.getProperty("identity") }

      /**
       * Gets the Linux profile for the cluster.
       */
      Expr getLinuxProfile() { result = this.getProperty("linuxProfile") }

      /**
       * Gets the Windows profile for the cluster.
       */
      Expr getWindowsProfile() { result = this.getProperty("windowsProfile") }

      /**
       * Gets the service principal profile for the cluster.
       */
      Expr getServicePrincipalProfile() { result = this.getProperty("servicePrincipalProfile") }

      /**
       * Gets the AAD profile for the cluster.
       */
      Expr getAadProfile() { result = this.getProperty("aadProfile") }

      /**
       * Gets the auto scaler profile for the cluster.
       */
      Expr getAutoScalerProfile() { result = this.getProperty("autoScalerProfile") }

      /**
       * Gets the HTTP proxy configuration for the cluster.
       */
      Expr getHttpProxyConfig() { result = this.getProperty("httpProxyConfig") }

      /**
       * Gets the pod identity profile for the cluster.
       */
      Expr getPodIdentityProfile() { result = this.getProperty("podIdentityProfile") }

      /**
       * Gets the workload auto scaler profile for the cluster.
       */
      Expr getWorkloadAutoScalerProfile() { result = this.getProperty("workloadAutoScalerProfile") }

      /**
       * Gets the storage profile for the cluster.
       */
      Expr getStorageProfile() { result = this.getProperty("storageProfile") }

      /**
       * Gets the SKU for the cluster.
       */
      Sku getSku() { result = this.getProperty("sku") }

      /**
       * Gets the tags for the cluster.
       */
      Tags getTags() { result = this.getProperty("tags") }

      override string toString() { result = "ManagedContainerProperties" }
    }

    /**
     * Represents the agent pool profiles for a managed AKS cluster.
     * Provides access to properties such as name, VM size, count, OS type, mode, autoscaling, and scaling limits.
     */
    class AgentPoolProfiles extends Object {
      private Properties properties;

      /**
       * Constructs an AgentPoolProfiles object for the given properties.
       */
      AgentPoolProfiles() {
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
       * Gets the mode for the agent pool (e.g., System or User).
       */
      StringLiteral getMode() { result = this.getProperty("mode") }

      /**
       * Gets whether autoscaling is enabled for the agent pool.
       */
      Boolean getEnableAutoScaling() {
        result = this.getProperty("enableAutoScaling")
      }

      /**
       * Gets the minimum node count for autoscaling.
       */
      Number getMinCount() { result = this.getProperty("minCount") }

      /**
       * Gets the maximum node count for autoscaling.
       */
      Number getMaxCount() { result = this.getProperty("maxCount") }

      string toString() { result = "AgentPoolProfiles" }
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
      StringLiteral getEnablePrivateCluster() { result = this.getProperty("enablePrivateCluster") }

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
  }
}
