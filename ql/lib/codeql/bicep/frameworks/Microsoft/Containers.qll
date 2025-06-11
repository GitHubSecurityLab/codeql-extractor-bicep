private import bicep

module Containers {
  /**
   * Represents a Microsoft.ContainerApp/containerApps resource.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps
   */
  class ContainerResource extends Resource {
    /**
     * Constructs a ContainerResource for Microsoft.App/containerApps resources.
     */
    ContainerResource() { this.getResourceType().regexpMatch("^Microsoft.App/containerApps@.*") }

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

    /**
     * Returns a string representation of the container app resource.
     */
    override string toString() { result = "ContainerResource" }
  }

  module ContainerProperties {
    /**
     * Represents the properties object for a container app resource.
     */
    class Properties extends Object {
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
       * Returns the template property.
       */
      ContainerTemplate getTemplate() { result = this.getProperty("template") }

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
  }
}
