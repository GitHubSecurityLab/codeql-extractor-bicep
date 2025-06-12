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

    StorageAccountProperies::Properties getProperties() { result = this.getProperty("properties") }

    StringLiteral getKind() { result = this.getProperty("kind") }

    Network::NetworkAcl getNetworkAcls() { result = this.getProperties().getNetworkAcls() }

    Sku getSku() { result = this.getProperty("sku") }

    override string toString() { result = "StorageAccount" }
  }

  /**
   * Represents a resource of type Microsoft.Compute/disks in Bicep.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/disks
   */
  class Disks extends Resource {
    Disks() { this.getResourceType().regexpMatch("^Microsoft.Compute/disks@.*") }

    DiskPools getDiskPools() { exists(DiskPools pools | pools.getDisks() = this | result = pools) }

    override string toString() { result = "Disks" }
  }

  class DiskPools extends Resource {
    DiskPools() { this.getResourceType().regexpMatch("^Microsoft.StoragePool/diskPools@.*") }

    DiskPoolProperties::Properties getProperties() { result = this.getProperty("properties") }

    Disks getDisks() {
      exists(DiskPoolProperties::DiskRef refs, Disks disks |
        refs = this.getProperties().getDisksRef() and
        disks.getIdentifier().getName() = refs.id()
      |
        result = disks
      )
    }

    Sku getSku() { result = this.getProperty("sku") }

    override string toString() { result = "DiskPools" }
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

  module StorageAccountProperies {
    /**
     * Represents the properties object for Microsoft.Storage/storageAccounts in Bicep.
     * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts#storageaccountsproperties
     */
    class Properties extends ResourceProperties {
      private StorageAccounts storageAccounts;

      Properties() { this = storageAccounts.getProperty("properties") }

      StringLiteral getMinimumTlsVersion() { result = this.getProperty("minimumTlsVersion") }

      string minimumTlsVersion() { result = this.getMinimumTlsVersion().getValue() }

      Boolean getAllowBlobPublicAccess() { result = this.getProperty("allowBlobPublicAccess") }

      boolean allowBlobPublicAccess() { result = this.getAllowBlobPublicAccess().getBool() }

      Boolean getSupportsHttpsTrafficOnly() {
        result = this.getProperty("supportsHttpsTrafficOnly")
      }

      Network::NetworkAcl getNetworkAcls() { result = this.getProperty("networkAcls") }

      StringLiteral getAccessTier() { result = this.getProperty("accessTier") }

      string accessTier() { result = this.getAccessTier().getValue() }

      Boolean getIsHnsEnabled() { result = this.getProperty("isHnsEnabled") }

      boolean isHnsEnabled() { result = this.getIsHnsEnabled().getBool() }

      /**
       * The property "supportsHttpsTrafficOnly" indicates whether the storage account
       * supports only HTTPS traffic. If this property is not set, it defaults to true.
       */
      boolean supportsHttpsTrafficOnly() { result = this.getSupportsHttpsTrafficOnly().getBool() }

      string toString() { result = "StorageAccountsProperties" }
    }
  }

  module DisksProperties {
    /**
     * Represents the properties object for Microsoft.Compute/disks in Bicep.
     * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/disks#diskproperties
     */
    class Properties extends ResourceProperties {
      private Disks disks;

      Properties() { this = disks.getProperty("properties") }

      EncryptionSettings getEncryptionSettings() {
        result = this.getProperty("encryptionSettingsCollection")
      }

      boolean getEncryptionEnabled() {
        result = this.getEncryptionSettings().getProperty("enabled").(Boolean).getBool()
      }

      Number getDiskSizeGB() { result = this.getProperty("diskSizeGB") }
    }

    class EncryptionSettings extends Properties {
      private Object encryptionSettings;

      EncryptionSettings() { this = encryptionSettings.getProperty("encryptionSettings") }

      StringLiteral getType() { result = this.getProperty("type") }

      boolean isEncryptionEnabled() { result = this.getProperty("enabled").(Boolean).getBool() }

      string getKeyVaultKeyUri() {
        result = this.getProperty("keyVaultKeyUri").(StringLiteral).getValue()
      }

      string toString() { result = "DiskEncryptionSettings" }
    }
  }

  module DiskPoolProperties {
    /**
     * Represents the properties object for Microsoft.Compute/diskPools in Bicep.
     * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/diskpools#diskpoolproperties
     */
    class Properties extends ResourceProperties {
      private DiskPools diskPools;

      Properties() { this = diskPools.getProperty("properties") }

      StringLiteral getProvisioningState() { result = this.getProperty("provisioningState") }

      DiskRef getDisksRef() { result = this.getProperty("disks").(Array).getElements() }

      string toString() { result = "DiskPoolProperties" }
    }

    class DiskRef extends Object {
      private Properties properties;

      DiskRef() { this = properties.getProperty("disks").(Array).getElements() }

      MemberExpression getId() { result = this.getProperty("id") }

      string id() { result = this.getId().getNamespace().getName() }

      string toString() { result = "DiskRef" }
    }
  }
}
