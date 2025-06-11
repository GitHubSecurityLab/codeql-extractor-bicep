private import bicep

/**
 * A resource of type Microsoft.Compute/virtualMachines
 */
module Compute {
  /**
   * Represents a generic Microsoft.Compute resource.
   * Matches any resource of type Microsoft.Compute/*.
   */
  class ComputeResource extends Resource {
    /**
     * Constructs a ComputeResource for any Microsoft.Compute resource type.
     */
    ComputeResource() { this.getResourceType().regexpMatch("^Microsoft.Compute/.*") }
  }

  /**
   * Represents a Microsoft.Compute/virtualMachines resource.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines
   */
  class VirtualMachines extends ComputeResource {
    /**
     * Constructs a VirtualMachines resource.
     */
    VirtualMachines() {
      this.getResourceType().regexpMatch("^Microsoft.Compute/virtualMachines@.*")
    }

    /**
     * Returns a string representation of the VirtualMachines resource.
     */
    override string toString() { result = "VirtualMachines Resource" }

    /**
     * Returns the properties object for this virtual machine.
     */
    VirtualMachinesProperties::Properties getProperties() {
      result = this.getProperty("properties")
    }

    /**
     * Returns the hardware network interfaces of the virtual machine.
     */
    Network::NetworkInterfaces getNetworkInterfaces() {
      result = this.getProperties().getNetworkProfile().getNetworkInterfaces()
    }
  }

  /**
   * The properties module for Microsoft.Compute/virtualMachines resources.
   */
  module VirtualMachinesProperties {
    /**
     * The properties object for the Microsoft.Compute/virtualMachines type.
     */
    class Properties extends Object {
      private VirtualMachines virtualMachines;

      /**
       * Constructs a Properties object for the given virtual machine.
       */
      Properties() { this = virtualMachines.getProperty("properties") }

      /**
       * Returns the parent VirtualMachines resource.
       */
      VirtualMachines getVirtualMachine() { result = virtualMachines }

      /**
       * Returns the hardware profile object for the virtual machine.
       */
      HardwareProfile getHardwareProfile() { result = this.getProperty("hardwareProfile") }

      /**
       * Returns the network profile object for the virtual machine.
       */
      NetworkProfile getNetworkProfile() { result = this.getProperty("networkProfile") }

      /**
       * Returns the OS profile object for the virtual machine.
       */
      OsProfile getOsProfile() { result = this.getProperty("osProfile") }
    }

    /**
     * The hardwareProfile property object for the Microsoft.Compute/virtualMachines type.
     */
    class HardwareProfile extends Object {
      private Properties properties;

      /**
       * Constructs a HardwareProfile object for the given properties.
       */
      HardwareProfile() { this = properties.getProperty("hardwareProfile") }

      /**
       * Returns a string representation of the hardware profile.
       */
      string toString() { result = "HardwareProfile" }

      /**
       * Returns the vmSize property of the hardware profile.
       */
      Expr getVmSize() { result = this.getProperty("vmSize") }
    }

    /**
     * Represents a network profile for the Microsoft.Compute/virtualMachines type.
     */
    class NetworkProfile extends Object {
      private Properties properties;

      /**
       * Constructs a NetworkProfile object for the given properties.
       */
      NetworkProfile() { this = properties.getProperty("networkProfile") }

      /**
       * Returns a string representation of the network profile.
       */
      string toString() { result = "NetworkProfile" }

      /**
       * Returns the network interfaces for the virtual machine.
       */
      Network::NetworkInterfaces getNetworkInterfaces() {
        result = resolveResource(this.getNetworkInterfacesObject())
      }

      /**
       * Returns the networkInterfaces property as an object array.
       */
      private Object getNetworkInterfacesObject() {
        result = this.getProperty("networkInterfaces").(Array).getElements()
      }
    }

    /**
     * Represents the storage profile for the Microsoft.Compute/virtualMachines type.
     */
    class StorageProfile extends Object {
      private Properties properties;

      /**
       * Constructs a StorageProfile object for the given properties.
       */
      StorageProfile() { this = properties.getProperty("storageProfile") }

      /**
       * Returns the image reference for the storage profile.
       */
      ImageReference getImageReference() { result = this.getProperty("imageReference") }
    }

    /**
     * Represents an image reference for the Microsoft.Compute/virtualMachines type.
     * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines?pivots=deployment-language-bicep#imagereference
     */
    class ImageReference extends Object {
      private StorageProfile storageProfile;

      /**
       * Constructs an ImageReference object for the given storage profile.
       */
      ImageReference() { this = storageProfile.getProperty("imageReference") }

      /**
       * Returns the publisher property of the image reference.
       */
      Expr getPublisher() { result = this.getProperty("publisher") }

      /**
       * Returns the offer property of the image reference.
       */
      Expr getOffer() { result = this.getProperty("offer") }

      /**
       * Returns the sku property of the image reference.
       */
      Expr getSku() { result = this.getProperty("sku") }

      /**
       * Returns the version property of the image reference.
       */
      Expr getVersion() { result = this.getProperty("version") }
    }

    /**
     * Represents the OS profile for the Microsoft.Compute/virtualMachines type.
     */
    class OsProfile extends Object {
      private Properties properties;

      /**
       * Constructs an OsProfile object for the given properties.
       */
      OsProfile() { this = properties.getProperty("osProfile") }

      /**
       * Returns the computerName property of the OS profile.
       */
      Expr getComputerName() { result = this.getProperty("computerName") }

      /**
       * Returns the adminUsername property of the OS profile.
       */
      Expr getAdminUsername() { result = this.getProperty("adminUsername") }

      /**
       * Returns the adminPassword property of the OS profile.
       */
      Expr getAdminPassword() { result = this.getProperty("adminPassword") }
    }
  }
}
