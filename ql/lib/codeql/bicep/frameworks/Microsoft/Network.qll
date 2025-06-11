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
}
