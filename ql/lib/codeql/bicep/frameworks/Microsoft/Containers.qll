private import bicep

module Containers {
  /**
   * Represents a Microsoft.ContainerApp/containerApps resource (2025-02-02-preview).
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps
   */
  class ContainerResource extends Resource {
    /**
     * Constructs a ContainerResource for Microsoft.App/containerApps resources.
     */
    ContainerResource() { this.getResourceType().regexpMatch("^Microsoft.App/containerApps@.*") }

    /**
     * Returns the extendedLocation property.
     */
    Expr getExtendedLocation() { result = this.getProperty("extendedLocation") }

    /**
     * Returns the identity property.
     */
    Expr getIdentity() { result = this.getProperty("identity") }

    /**
     * Returns the kind property.
     */
    StringLiteral getKind() { result = this.getProperty("kind") }

    /**
     * Returns the managedBy property.
     */
    StringLiteral getManagedBy() { result = this.getProperty("managedBy") }

    /**
     * Returns the name property (overrides base Resource).
     */
    override string getName() { result = super.getName() }

    /**
     * Returns the properties object for the container app resource.
     */
    ContainerProperties::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Returns the configuration object for the container app resource.
     */
    ContainerProperties::ContainerConfiguration getConfiguration() {
      result = this.getProperties().getConfiguration()
    }

    /**
     * Returns the template object for the container app resource.
     */
    ContainerProperties::ContainerTemplate getTemplate() {
      result = this.getProperties().getTemplate()
    }

    /**
     * Returns the containers defined in the template.
     */
    ContainerProperties::ContainerApp getContainers() {
      result = this.getTemplate().getContainers()
    }

    /**
     * Returns a specific container by index from the template.
     */
    ContainerProperties::ContainerApp getContainer(int index) {
      result = this.getTemplate().getContainer(index)
    }

    Network::Ingress getNetworkIngress() { result = this.getConfiguration().getNetworkIngress() }

    Network::CorsPolicy getCorsPolicy() { result = this.getNetworkIngress().getCorsPolicy() }

    /**
     * Returns the SKU object for the container registry resource.
     */
    Sku getSku() { result = this.getProperty("sku") }

    Tags getTags() { result = this.getProperty("tags") }

    /**
     * Returns a string representation of the container app resource.
     */
    override string toString() { result = "ContainerResource" }
  }

  class ContainerRegistry extends Resource {
    /**
     * Constructs a ContainerRegistry for Microsoft.ContainerRegistry/containerRegistries resources (2025-02-02-preview).
     */
    ContainerRegistry() {
      this.getResourceType().regexpMatch("^Microsoft.ContainerRegistry/registries@.*$")
    }

    /**
     * Returns the SKU object for the container registry resource.
     */
    Sku getSku() { result = this.getProperty("sku") }

    Tags getTags() { result = this.getProperty("tags") }

    override string toString() { result = "ContainerRegistry" }
  }

  module ContainerProperties {
    /**
     * Represents the properties object for a container app resource (2025-02-02-preview).
     */
    class Properties extends ResourceProperties {
      private ContainerResource containerResource;

      /**
       * Constructs a Properties object for the given container app resource.
       */
      Properties() { this = containerResource.getProperty("properties") }

      /**
       * Returns the parent ContainerResource.
       */
      ContainerResource getContainerResource() { result = containerResource }

      /**
       * Returns the configuration property.
       */
      ContainerConfiguration getConfiguration() { result = this.getProperty("configuration") }

      /**
       * Returns the environmentId property.
       */
      StringLiteral getEnvironmentId() { result = this.getProperty("environmentId") }

      /**
       * Returns the managedEnvironmentId property.
       */
      StringLiteral getManagedEnvironmentId() { result = this.getProperty("managedEnvironmentId") }

      /**
       * Returns the patchingConfiguration property.
       */
      Expr getPatchingConfiguration() { result = this.getProperty("patchingConfiguration") }

      /**
       * Returns the template property.
       */
      ContainerTemplate getTemplate() { result = this.getProperty("template") }

      /**
       * Returns the workloadProfileName property.
       */
      StringLiteral getWorkloadProfileName() { result = this.getProperty("workloadProfileName") }

      string toString() { result = "ContainerProperties" }
    }

    /**
     * Represents the configuration object for a container app resource.
     */
    class ContainerConfiguration extends Object {
      private Properties properties;

      /**
       * Constructs a Configuration object for the given properties.
       */
      ContainerConfiguration() { this = properties.getProperty("configuration") }

      /**
       * Returns the network ingress configuration.
       */
      Network::Ingress getNetworkIngress() { result = this.getProperty("ingress") }

      /**
       * Returns the secrets defined in the configuration.
       */
      ContainerSecret getSecrets() { result = this.getProperty("secrets").(Array).getElements() }

      ContainerSecret getSecret(string name) {
        exists(ContainerSecret secret |
          secret = this.getSecrets() and
          secret.getName().getValue() = name
        |
          result = secret
        )
      }

      /**
       * Returns the active revisions mode as a StringLiteral.
       */
      StringLiteral getActiveRevisionsMode() { result = this.getProperty("activeRevisionsMode") }

      /**
       * Returns the active revisions mode as a string.
       */
      string activeRevisionsMode() { result = this.getActiveRevisionsMode().getValue() }

      /**
       * Returns the template property.
       */
      Expr getTemplate() { result = this.getProperty("template") }

      /**
       * Returns the Dapr configuration object, if present.
       *
       * @return The Dapr configuration expression.
       */
      Expr getDapr() { result = this.getProperty("dapr") }

      /**
       * Returns the identity settings object, if present.
       *
       * @return The identity settings expression.
       */
      Expr getIdentitySettings() { result = this.getProperty("identitySettings") }

      /**
       * Returns the ingress configuration object, if present.
       *
       * @return The ingress configuration expression.
       */
      Expr getIngress() { result = this.getProperty("ingress") }

      /**
       * Returns all container registries defined in the configuration.
       *
       * @return The container registry objects as an array.
       */
      ContainerRegistry getRegistries() {
        result = this.getProperty("registries").(Array).getElements()
      }

      /**
       * Returns a specific container registry by index.
       *
       * @param index The index of the registry.
       * @return The container registry at the specified index.
       */
      ContainerRegistry getRegistry(int index) {
        result = this.getProperty("registries").(Array).getElement(index)
      }

      /**
       * Returns the runtime configuration object, if present.
       *
       * @return The runtime configuration expression.
       */
      Expr getRuntime() { result = this.getProperty("runtime") }

      /**
       * Returns the service configuration object, if present.
       *
       * @return The service configuration expression.
       */
      Expr getService() { result = this.getProperty("service") }

      /**
       * Returns the target label property, if present.
       *
       * @return The target label string literal.
       */
      StringLiteral getTargetLabel() { result = this.getProperty("targetLabel") }

      string toString() { result = "ContainerConfiguration" }
    }

    /**
     * Represents a secret defined in the container app configuration.
     */
    class ContainerSecret extends Object {
      private ContainerConfiguration configuration;

      /**
       * Constructs a ContainerSecret for the given configuration.
       */
      ContainerSecret() { this = configuration.getProperty("secrets").(Array).getElements() }

      /**
       * Returns the name of the secret.
       */
      StringLiteral getName() { result = this.getProperty("name") }

      /**
       * Returns the value of the secret.
       */
      StringLiteral getValue() { result = this.getProperty("value") }

      string toString() { result = "ContainerSecret" }
    }

    /**
     * Represents the template object for a container app resource.
     */
    class ContainerTemplate extends Object {
      private Properties properties;

      /**
       * Constructs a ContainerTemplate for the given properties.
       */
      ContainerTemplate() { this = properties.getProperty("template") }

      /**
       * Returns the container app template.
       */
      Expr getContainerAppTemplate() { result = this.getProperty("containerAppTemplate") }

      /**
       * Returns the containers defined in the template.
       */
      ContainerApp getContainers() { result = this.getProperty("containers").(Array).getElements() }

      /**
       * Returns the initContainers defined in the template.
       */
      Expr getInitContainers() { result = this.getProperty("initContainers") }

      /**
       * Returns the revisionSuffix property.
       */
      StringLiteral getRevisionSuffix() { result = this.getProperty("revisionSuffix") }

      /**
       * Returns the scale property.
       */
      Expr getScale() { result = this.getProperty("scale") }

      /**
       * Returns the serviceBinds property.
       */
      Expr getServiceBinds() { result = this.getProperty("serviceBinds") }

      /**
       * Returns the terminationGracePeriodSeconds property.
       */
      Expr getTerminationGracePeriodSeconds() {
        result = this.getProperty("terminationGracePeriodSeconds")
      }

      /**
       * Returns the volumes property.
       */
      Expr getVolumes() { result = this.getProperty("volumes") }

      /**
       * Returns a specific container by index from the template.
       */
      ContainerApp getContainer(int index) {
        result = this.getProperty("containers").(Array).getElement(index)
      }

      string toString() { result = "ContainerTemplate" }
    }

    /**
     * Represents a container defined in the container app template.
     */
    class ContainerApp extends Object {
      private ContainerTemplate template;

      /**
       * Constructs a ContainerApp for the given template.
       */
      ContainerApp() { this = template.getProperty("containers").(Array).getElements() }

      /**
       * Returns the parent ContainerTemplate.
       */
      ContainerTemplate getContainerTemplate() { result = template }

      /**
       * Returns the name of the container.
       */
      StringLiteral getName() { result = this.getProperty("name") }

      /**
       * Returns the image of the container.
       */
      StringLiteral getImage() { result = this.getProperty("image") }

      /**
       * Returns the resources object for the container.
       */
      ContainerResources getResources() { result = this.getProperty("resources") }

      /**
       * Returns the environment variables defined for the container.
       */
      ContainerEnv getEnvs() { result = this.getProperty("env").(Array).getElements() }

      /**
       * Returns a specific environment variable by name.
       */
      ContainerEnv getEnv(string name) {
        exists(ContainerEnv env |
          env = this.getEnvs() and
          env.getName().getValue() = name
        |
          result = env
        )
      }

      string toString() { result = "ContainerProperty" }
    }

    /**
     * Represents the resources object for a container.
     */
    class ContainerResources extends Object {
      private ContainerApp container;

      /**
       * Constructs a ContainerResources object for the given container.
       */
      ContainerResources() { this = container.getProperty("resources") }

      /**
       * Returns the properties object for the container resource.
       */
      ContainerProperties::Properties getContainerProperties() {
        result = this.getProperty("properties")
      }

      /**
       * Returns the CPU resource allocation.
       */
      Literals getCpu() { result = this.getProperty("cpu") }

      /**
       * Returns the memory resource allocation.
       */
      StringLiteral getMemory() { result = this.getProperty("memory") }

      string toString() { result = "ContainerResourceProperties" }
    }

    /**
     * Represents an environment variable defined for a container.
     */
    class ContainerEnv extends Object {
      private ContainerApp container;

      /**
       * Constructs a ContainerEnv for the given container.
       */
      ContainerEnv() { this = container.getProperty("env").(Array).getElements() }

      /**
       * Returns the parent ContainerApp.
       */
      ContainerApp getContainer() { result = container }

      /**
       * Returns the name of the environment variable.
       */
      StringLiteral getName() { result = this.getProperty("name") }

      /**
       * Returns the value of the environment variable.
       */
      StringLiteral getValue() { result = this.getProperty("value") }

      string toString() { result = "ContainerEnv" }
    }

    class ContainerRegistry extends Object {
      private ContainerConfiguration configuration;

      /**
       * Constructs a ContainerRegistry for the given configuration.
       */
      ContainerRegistry() { this = configuration.getProperty("registries").(Array).getElements() }

      /**
       * Returns the registry server URL.
       */
      StringLiteral getServer() { result = this.getProperty("server") }

      /**
       * Returns the username for the registry.
       */
      StringLiteral getUsername() { result = this.getProperty("username") }

      /**
       * Returns the password for the registry.
       */
      StringLiteral getPassword() {
        exists(StringLiteral ref | ref = this.getProperty("passwordSecretRef") |
          result = configuration.getSecret(ref.getValue()).getValue()
        )
        or
        result = this.getProperty("password")
      }

      string toString() { result = "ContainerRegistry" }
    }
  }
}
