private import bicep

module Storage {
  class StorageAccounts extends Resource {
    StorageAccounts() {
      this.getResourceType().regexpMatch("^Microsoft.Storage/storageAccounts@.*")
    }

    Expr getKind() { result = this.getProperty("kind") }
  }

  class StorageAccountsProperties extends Object {
    private StorageAccounts storageAccounts;

    StorageAccountsProperties() { this = storageAccounts.getProperty("properties") }

    /**
     * The property "supportsHttpsTrafficOnly" indicates whether the storage account
     * supports only HTTPS traffic. If this property is not set, it defaults to true.
     */
    boolean getSupportsHttpsTrafficOnly() {
      exists(Boolean bl | bl = this.getProperty("supportsHttpsTrafficOnly") | result = bl.getBool())
    }
  }

  /**
   * A resource of type Microsoft.Compute/disks
   */
  class Disks extends Resource {
    Disks() { this.getResourceType().regexpMatch("^Microsoft.Compute/disks@.*") }
  }

  /**
   * The Disk Properties object for the Microsoft.Compute/disks type
   */
  class DisksProperties extends Object {
    private Disks disks;

    DisksProperties() { this = disks.getProperty("properties") }

    Object getEncryptionSettings() { result = this.getProperty("encryptionSettingsCollection") }

    boolean getEncryptionEnabled() {
      result = this.getEncryptionSettings().getProperty("enabled").(Boolean).getBool()
    }
  }

  class BlobServiceContainers extends Resource {
    BlobServiceContainers() {
      this.getResourceType()
          .regexpMatch("^Microsoft.Storage/storageAccounts/blobServices/containers@.*")
    }

    Object getProperties() { result = this.getProperty("properties") }

    string getPublicAccess() {
      result = this.getProperties().getProperty("publicAccess").(StringLiteral).getValue()
    }
  }
}
