private import bicep

module Network {
  /**
   * Represents a generic Microsoft.Network resource.
   * Matches any resource of type Microsoft.Network/*.
   */
  class NetworkResource extends Resource {
    /**
     * Constructs a NetworkResource for any Microsoft.Network resource type.
     */
    NetworkResource() { this.getResourceType().regexpMatch("^Microsoft.Network/.*") }
  }

  /**
   * Represents a Microsoft.Network/networkInterfaces resource.
   */
  class NetworkInterfaces extends NetworkResource {
    /**
     * Constructs a NetworkInterfaces resource.
     */
    NetworkInterfaces() {
      this.getResourceType().regexpMatch("^Microsoft.Network/networkInterfaces@.*")
    }

    /**
     * Returns a string representation of the NetworkInterfaces resource.
     */
    override string toString() { result = "NetworkInterfaces Resource" }

    /**
     * Returns the properties object for this network interface.
     */
    NetworkInterfaceProperties::Properties getProperties() {
      result = this.getProperty("properties")
    }
  }

  /**
   * A module for all properties of Microsoft.Network/networkInterfaces resources.
   */
  module NetworkInterfaceProperties {
    /**
     * The properties object for the Microsoft.Network/networkInterfaces type.
     */
    class Properties extends Object {
      private NetworkInterfaces networkInterfaces;

      /**
       * Constructs a Properties object for the given network interface.
       */
      Properties() { this = networkInterfaces.getProperty("properties") }

      /**
       * Returns the ipConfigurations property as an array of IpConfiguration objects.
       */
      IpConfiguration getIpConfigurations() {
        result = this.getProperty("ipConfigurations").(Array).getElements()
      }
    }

    /**
     * Represents an IpConfiguration for the Microsoft.Network/networkInterfaces type.
     * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines?pivots=deployment-language-bicep#virtualmachinenetworkinterfaceipconfigurationproperties
     */
    class IpConfiguration extends Object {
      private Properties properties;

      /**
       * Constructs an IpConfiguration object for the given properties.
       */
      IpConfiguration() { this = properties.getProperty("ipConfigurations").(Array).getElements() }

      /**
       * Returns the name property of the IpConfiguration.
       */
      string getName() { result = this.getProperty("name").(StringLiteral).getValue() }
    }
  }

  /**
   * Represents a Microsoft.Network/virtualNetworks resource.
   */
  class VirtualNetworks extends NetworkResource {
    /**
     * Constructs a VirtualNetworks resource.
     */
    VirtualNetworks() {
      this.getResourceType().regexpMatch("^Microsoft.Network/virtualNetworks@.*")
    }

    /**
     * Returns a string representation of the VirtualNetworks resource.
     */
    override string toString() { result = "VirtualNetworks Resource" }

    /**
     * Returns the properties object for the Microsoft.Network/virtualNetworks type.
     */
    VirtualNetworkProperties::Properties getProperties() { result = this.getProperty("properties") }
  }

  /**
   * Represents a Microsoft.Network/virtualNetworks/subnets resource.
   */
  class VirtualNetworkSubnets extends Resource {
    /**
     * Constructs a VirtualNetworkSubnets resource.
     */
    VirtualNetworkSubnets() {
      this.getResourceType().regexpMatch("^Microsoft.Network/virtualNetworks/subnets@.*")
    }
  }

  class NetworkAcl extends Object {
    private Resource resource;

    NetworkAcl() {
      exists(Object props |
        props = resource.getProperty("properties") and
        this = props.getProperty(["networkAcl", "networkAcls"])
      )
    }

    Resource getResource() { result = resource }

    StringLiteral getBypass() { result = this.getProperty("bypass") }

    string bypass() { result = this.getBypass().getValue() }

    StringLiteral getDefaultAction() { result = this.getProperty("defaultAction") }

    string defaultAction() { result = this.getDefaultAction().getValue() }

    IpRule getIpRules() { result = this.getProperty("ipRules").(Array).getElements() }

    string toString() { result = "Network ACL" }
  }

  class IpRule extends Object {
    private NetworkAcl acl;

    IpRule() { this = acl.getProperty("ipRules").(Array).getElements() }

    NetworkAcl getNetworkAcl() { result = acl }

    StringLiteral getValue() { result = this.getProperty("value") }

    string toString() { result = "IP Rule" }
  }

  /**
   * Represents the ingress configuration for a resource (e.g., container app).
   * Provides access to ingress properties such as external, targetPort, transport, CORS policy, and allowInsecure.
   */
  class Ingress extends Object {
    private Object properties;

    /**
     * Constructs an Ingress object for the given properties.
     */
    Ingress() { this = properties.getProperty("ingress") }

    /**
     * Returns the 'external' property as a Boolean.
     */
    Boolean getExternal() { result = this.getProperty("external") }

    /**
     * Returns the 'external' property as a boolean.
     */
    boolean external() { result = this.getExternal().(Boolean).getBool() }

    /**
     * Returns the 'targetPort' property as a Number.
     */
    Number getTargetPort() { result = this.getProperty("targetPort") }

    /**
     * Returns the 'targetPort' property as an int.
     */
    int targetPort() { result = this.getTargetPort().getValue() }

    /**
     * Returns the 'transport' property as a StringLiteral.
     */
    StringLiteral getTransport() { result = this.getProperty("transport") }

    /**
     * Returns the 'transport' property as a string.
     */
    string transport() { result = this.getTransport().getValue() }

    /**
     * Returns the 'corsPolicy' property as a CorsPolicy object.
     */
    CorsPolicy getCorsPolicy() { result = this.getProperty("corsPolicy") }

    /**
     * Returns the 'allowInsecure' property as a Boolean.
     */
    Boolean getAllowInsecure() { result = this.getProperty("allowInsecure") }

    /**
     * Returns the 'allowInsecure' property as a boolean.
     */
    boolean allowInsecure() { result = this.getAllowInsecure().getBool() }

    string toString() { result = "NetworkIngress" }
  }

  /**
   * Represents a CORS policy for ingress.
   * Provides access to CORS-related properties such as allowCredentials, allowedOrigins, allowedMethods, allowedHeaders, exposedHeaders, and maxAge.
   */
  class CorsPolicy extends Object {
    private Object properties;

    /**
     * Constructs a CorsPolicy object for the given properties.
     */
    CorsPolicy() { this = properties.getProperty("corsPolicy") }

    /**
     * Returns the 'allowCredentials' property as a Boolean.
     */
    Boolean getAllowCredentials() {
      result = this.getProperty("allowCredentials")
    }

    /**
     * Returns the 'allowCredentials' property as a boolean.
     */
    boolean allowCredentials() { result = this.getAllowCredentials().getBool() }

    /**
     * Returns the 'allowedOrigins' property as an array of StringLiterals.
     */
    Array getAllowedOrigins() {
      result = this.getProperty("allowedOrigins")
    }

    /**
     * Returns the 'allowedMethods' property as an array of StringLiterals.
     */
    Array getAllowedMethods() {
      result = this.getProperty("allowedMethods")
    }

    /**
     * Returns the 'allowedHeaders' property as an array of StringLiterals.
     */
    Array getAllowedHeaders() {
      result = this.getProperty("allowedHeaders")
    }

    /**
     * Returns the 'exposedHeaders' property as an array of StringLiterals.
     */
    Array getExposedHeaders() {
      result = this.getProperty("exposedHeaders")
    }

    /**
     * Returns the 'maxAge' property as a Number.
     */
    Number getMaxAge() { result = this.getProperty("maxAge") }

    string toString() { result = "CorsPolicy" }
  }

  module VirtualNetworkProperties {
    /**
     * The properties object for the Microsoft.Network/virtualNetworks/subnets type.
     */
    class Properties extends Object {
      private VirtualNetworkSubnets virtualNetworkSubnets;

      /**
       * Constructs a Properties object for the given subnet.
       */
      Properties() { this = virtualNetworkSubnets.getProperty("properties") }

      /**
       * Returns the address space object for the subnet.
       */
      AddressSpace getAddressSpace() { result = this.getProperty("addressSpace") }

      /**
       * Returns true if DDoS protection is enabled for the subnet.
       */
      boolean getEnableDdosProtection() {
        result = this.getProperty("enableDdosProtection").(Boolean).getBool()
      }

      /**
       * Returns true if VM protection is enabled for the subnet.
       */
      boolean getEnableVmProtection() {
        result = this.getProperty("enableVmProtection").(Boolean).getBool()
      }
    }

    /**
     * Represents an AddressSpace for the Microsoft.Network/virtualNetworks type.
     */
    class AddressSpace extends Object {
      private Properties properties;

      /**
       * Constructs an AddressSpace object for the given properties.
       */
      AddressSpace() { this = properties.getProperty("addressSpace") }

      /**
       * Returns the addressPrefixes property as a string value.
       */
      string getAddressPrefixes() {
        result =
          this.getProperty("addressPrefixes").(Array).getElements().(StringLiteral).getValue()
      }
    }
  }

  class NetworkProfile extends Object {
    private Resource resource;

    NetworkProfile() {
      exists(Object props |
        props = resource.getProperty("properties") and
        this = props.getProperty("networkProfile")
      )
    }

    Resource getResource() { result = resource }

    StringLiteral getNetworkPlugin() { result = this.getProperty("networkPlugin") }

    string networkPlugin() { result = this.getNetworkPlugin().getValue() }

    StringLiteral getNetworkPolicy() { result = this.getProperty("networkPolicy") }

    string networkPolicy() { result = this.getNetworkPolicy().getValue() }

    string toString() { result = "NetworkProfile" }
  }
}
