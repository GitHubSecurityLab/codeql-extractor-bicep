private import bicep

/**
 * A resource of type Microsoft.Compute/virtualMachines
 */
module Compute {
  /**
   * Represents a generic Microsoft.Compute resource.
   * Matches any resource of type Microsoft.Compute/*.
   */
  class ComputeResource extends AzureResource {
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
    class Properties extends ResourceProperties {
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
      NetworkingProfiles::NetworkProfile getNetworkProfile() { result = this.getProperty("networkProfile") }

      /**
       * Returns the OS profile object for the virtual machine.
       */
      OsProfiles::OsProfile getOsProfile() { result = this.getProperty("osProfile") }

      override string toString() {
        result = "VirtualMachinesProperties[" + virtualMachines.getName() + "]"
      }
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
      override string toString() { result = "HardwareProfile" }

      /**
       * Returns the vmSize property of the hardware profile.
       */
      Expr getVmSize() { result = this.getProperty("vmSize") }
    }
  }
}
