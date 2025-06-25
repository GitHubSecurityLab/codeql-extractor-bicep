/**
 * Profiles module for Microsoft Azure Bicep framework.
 *
 * This module provides classes to represent OS profiles, storage profiles, and many more.
 */

private import bicep
private import codeql.bicep.frameworks.Microsoft.General

module OsProfiles {
  /**
   * Represents the OS profile for the Microsoft.Compute/virtualMachines type.
   */
  class OsProfile extends Object {
    private ResourceProperties properties;
    private string profileType;

    /**
     * Constructs an OsProfile object for the given properties.
     */
    OsProfile() {
      this = properties.getProperty("osProfile") and profileType = "general"
      or
      this = properties.getProperty("linuxProfile") and profileType = "linux"
      or
      this = properties.getProperty("windowsProfile") and profileType = "windows"
    }

    /**
     * Returns the computerName property of the OS profile.
     */
    Expr getComputerName() { result = this.getProperty("computerName") }

    string osType() { result = profileType }

    /**
     * Returns the adminUsername property of the OS profile.
     */
    Expr getAdminUsername() { result = this.getProperty("adminUsername") }

    /**
     * Returns the adminPassword property of the OS profile.
     */
    Expr getAdminPassword() { result = this.getProperty("adminPassword") }

    SshConfig getSshConfig() { result = this.getProperty("ssh") }

    string toString() { result = "OsProfile[" + profileType + "]" }
  }

  /**
   * Represents the Windows profile for a managed AKS cluster.
   */
  class WindowsProfile extends OsProfile {
    private Object properties;

    /**
     * Constructs a WindowsProfile object for the given properties.
     */
    WindowsProfile() { this = properties.getProperty("windowsProfile") }

    /**
     * Gets the license type property.
     */
    StringLiteral getLicenseType() { result = this.getProperty("licenseType") }

    /**
     * Gets the GMSAProfile property.
     */
    Expr getGmsaProfile() { result = this.getProperty("gmsaProfile") }

    /**
     * Gets whether enabling CSI proxy is enabled.
     */
    Boolean getEnablingCSIProxy() { result = this.getProperty("enablingCSIProxy") }
  }

  /**
   * Represents the Linux profile for a managed AKS cluster.
   */
  class LinuxProfile extends OsProfile {
    private Object properties;

    /**
     * Constructs a LinuxProfile object for the given properties.
     */
    LinuxProfile() { this = properties.getProperty("linuxProfile") }

    /**
     * Gets the SSH key property.
     */
    Expr getSsh() { result = this.getProperty("ssh") }
  }

  class SshConfig extends Object {
    private OsProfile osProfile;

    /**
     * Constructs an SshConfig object for the given OS profile.
     */
    SshConfig() { this = osProfile.getProperty("ssh") }

    /**
     * Returns the publicKeys property of the SSH configuration.
     */
    SshPublicKey getPublicKeys() { result = this.getProperty("publicKeys").(Array).getElements() }

    /**
     * Returns a string representation of the SSH configuration.
     */
    string toString() { result = "SshConfig" }
  }

  class SshPublicKey extends Object {
    private SshConfig sshConfig;

    /**
     * Constructs an SshConfigPublicKey object for the given SSH configuration.
     */
    SshPublicKey() { this = sshConfig.getProperty("publicKeys").(Array).getElements() }

    /**
     * Returns the keyData property of the SSH public key.
     */
    Expr getKeyData() { result = this.getProperty("keyData") }

    /**
     * Returns a string representation of the SSH public key.
     */
    string toString() { result = "SshConfigPublicKey" }
  }
}

module NetworkingProfiles {
  /**
   * Represents a network profile for the Microsoft.Compute/virtualMachines type.
   */
  class NetworkProfile extends Object {
    private ResourceProperties properties;

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
}

module StorageProfiles {
  /**
   * Represents the storage profile for a managed AKS cluster.
   */
  class StorageProfile extends Object {
    private ResourceProperties properties;

    /**
     * Constructs a StorageProfile object for the given properties.
     */
    StorageProfile() { this = properties.getProperty("storageProfile") }

    /**
     * Returns the image reference for the storage profile.
     */
    ImageReference getImageReference() { result = this.getProperty("imageReference") }

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
}
