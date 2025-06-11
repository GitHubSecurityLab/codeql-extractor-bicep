private import bicep

module Storage {
  /**
   * Represents a resource of type Microsoft.Storage/storageAccounts in Bicep.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts
   */
  class StorageAccounts extends Resource {
    StorageAccounts() {
      this.getResourceType().regexpMatch("^Microsoft.Storage/storageAccounts@.*")
    }

    Expr getKind() { result = this.getProperty("kind") }
  }

  /**
   * Represents the properties object for Microsoft.Storage/storageAccounts in Bicep.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts#storageaccountsproperties
   */
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
   * Represents a resource of type Microsoft.Compute/disks in Bicep.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/disks
   */
  class Disks extends Resource {
    Disks() { this.getResourceType().regexpMatch("^Microsoft.Compute/disks@.*") }
  }

  /**
   * Represents the properties object for Microsoft.Compute/disks in Bicep.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/disks#diskproperties
   */
  class DisksProperties extends Object {
    private Disks disks;

    DisksProperties() { this = disks.getProperty("properties") }

    Object getEncryptionSettings() { result = this.getProperty("encryptionSettingsCollection") }

    boolean getEncryptionEnabled() {
      result = this.getEncryptionSettings().getProperty("enabled").(Boolean).getBool()
    }
  }

  /**
   * Represents a resource of type Microsoft.Storage/storageAccounts/blobServices/containers in Bicep.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts/blobservices/containers
   */
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
