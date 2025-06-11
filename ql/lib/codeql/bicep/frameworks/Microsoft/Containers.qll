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

    ContainerProperties::ContainerConfiguration getConfiguration() {
      result = this.getProperties().getConfiguration()
    }

    ContainerProperties::ContainerTemplate getTemplate() {
      result = this.getProperties().getTemplate()
    }

    ContainerProperties::ContainerApp getContainers() {
      result = this.getTemplate().getContainers()
    }

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

      ContainerTemplate getTemplate() { result = this.getProperty("template") }

      string toString() { result = "ContainerProperties" }
    }

    class ContainerConfiguration extends Object {
      private Properties properties;

      /**
       * Constructs a Configuration object for the given properties.
       */
      ContainerConfiguration() { this = properties.getProperty("configuration") }

      Network::Ingress getNetworkIngress() { result = this.getProperty("ingress") }

      ContainerSecret getSecrets() { result = this.getProperty("secrets").(Array).getElements() }

      StringLiteral getActiveRevisionsMode() { result = this.getProperty("activeRevisionsMode") }

      string activeRevisionsMode() { result = this.getActiveRevisionsMode().getValue() }

      /**
       * Returns the template property.
       */
      Expr getTemplate() { result = this.getProperty("template") }

      string toString() { result = "ContainerConfiguration" }
    }

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
       * Returns the container app template's containers.
       */
      ContainerApp getContainers() { result = this.getProperty("containers").(Array).getElements() }

      ContainerApp getContainer(int index) {
        result = this.getProperty("containers").(Array).getElement(index)
      }

      string toString() { result = "ContainerTemplate" }
    }

    class ContainerApp extends Object {
      private ContainerTemplate template;

      ContainerApp() { this = template.getProperty("containers").(Array).getElements() }

      ContainerTemplate getContainerTemplate() { result = template }

      StringLiteral getName() { result = this.getProperty("name") }

      StringLiteral getImage() { result = this.getProperty("image") }

      ContainerResources getResources() { result = this.getProperty("resources") }

      ContainerEnv getEnvs() { result = this.getProperty("env").(Array).getElements() }

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

    class ContainerResources extends Object {
      private ContainerApp container;

      ContainerResources() { this = container.getProperty("resources") }

      /**
       * Returns the properties object for the container resource.
       */
      ContainerProperties::Properties getContainerProperties() {
        result = this.getProperty("properties")
      }

      Literals getCpu() { result = this.getProperty("cpu") }

      StringLiteral getMemory() { result = this.getProperty("memory") }

      string toString() { result = "ContainerResourceProperties" }
    }

    class ContainerEnv extends Object {
      private ContainerApp container;

      ContainerEnv() { this = container.getProperty("env").(Array).getElements() }

      ContainerApp getContainer() { result = container }

      StringLiteral getName() { result = this.getProperty("name") }

      StringLiteral getValue() { result = this.getProperty("value") }

      string toString() { result = "ContainerEnv" }
    }
  }
}
