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

  module ManagedContainerProperties {
    /**
     * Represents the properties object for a Kubernetes (AKS) resource.
     */
    class Properties extends Object {
      private ManagedContainerResource resource;

      Properties() { this = resource.getProperty("properties") }

      ManagedContainerResource getManagedContainerResource() { result = resource }

      StringLiteral getKubernetesVersion() { result = this.getProperty("kubernetesVersion") }

      StringLiteral getDnsPrefix() { result = this.getProperty("dnsPrefix") }

      AgentPoolProfiles getAgentPoolProfiles() {
        result = this.getProperty("agentPoolProfiles").(Array).getElements()
      }

      Network::NetworkProfile getNetworkProfile() { result = this.getProperty("networkProfile") }

      ApiServerAccessProfile getApiServerAccessProfile() {
        result = this.getProperty("apiServerAccessProfile")
      }

      AddonProfiles getAddonProfiles() { result = this.getProperty("addonProfiles") }

      Expr getIdentity() { result = this.getProperty("identity") }

      Expr getLinuxProfile() { result = this.getProperty("linuxProfile") }

      Expr getWindowsProfile() { result = this.getProperty("windowsProfile") }

      Expr getServicePrincipalProfile() { result = this.getProperty("servicePrincipalProfile") }

      Expr getAadProfile() { result = this.getProperty("aadProfile") }

      Expr getAutoScalerProfile() { result = this.getProperty("autoScalerProfile") }

      Expr getHttpProxyConfig() { result = this.getProperty("httpProxyConfig") }

      Expr getPodIdentityProfile() { result = this.getProperty("podIdentityProfile") }

      Expr getWorkloadAutoScalerProfile() { result = this.getProperty("workloadAutoScalerProfile") }

      Expr getStorageProfile() { result = this.getProperty("storageProfile") }

      Sku getSku() { result = this.getProperty("sku") }

      Tags getTags() { result = this.getProperty("tags") }

      string toString() { result = "ManagedContainerProperties" }
    }

    class AgentPoolProfiles extends Object {
      private Properties properties;

      AgentPoolProfiles() {
        this = properties.getProperty("agentPoolProfiles").(Array).getElements()
      }

      StringLiteral getName() { result = this.getProperty("name") }

      StringLiteral getVmSize() { result = this.getProperty("vmSize") }

      Expr getCount() { result = this.getProperty("count") }

      Expr getOsType() { result = this.getProperty("osType") }

      Expr getMode() { result = this.getProperty("mode") }

      string toString() { result = "AgentPoolProfiles" }
    }

    class ApiServerAccessProfile extends Object {
      private Properties properties;

      ApiServerAccessProfile() { this = properties.getProperty("apiServerAccessProfile") }

      StringLiteral getEnablePrivateCluster() { result = this.getProperty("enablePrivateCluster") }

      StringLiteral getPrivateDnsZone() { result = this.getProperty("privateDnsZone") }

      string toString() { result = "ApiServerAccessProfile" }
    }

    class AddonProfiles extends Object {
      private Properties properties;

      AddonProfiles() { this = properties.getProperty("addonProfiles") }

      AddonKubeDashboard getKubeDashboard() { result = this.getProperty("kubeDashboard") }

      string toString() { result = "AddonProfiles" }
    }

    class AddonKubeDashboard extends Object {
      private AddonProfiles profiles;

      AddonKubeDashboard() { this = profiles.getProperty("kubeDashboard") }

      Boolean getEnabled() { result = this.getProperty("enabled") }

      string toString() { result = "AddonKubeDashboard" }
    }

    class AddonAzurePolicy extends Object {
      private AddonProfiles profiles;

      AddonAzurePolicy() { this = profiles.getProperty("azurePolicy") }

      Boolean getEnabled() { result = this.getProperty("enabled") }

      string toString() { result = "AddonAzurePolicy" }
    }
  }
}
