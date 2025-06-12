private import bicep

module Storage {
  /**
   * Represents a resource of type Microsoft.Storage/storageAccounts in Bicep.
   * Provides access to storage account properties, kind, network ACLs, and SKU.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts
   */
  class StorageAccounts extends Resource {
    /**
     * Constructs a StorageAccounts resource.
     */
    StorageAccounts() {
      this.getResourceType().regexpMatch("^Microsoft.Storage/storageAccounts@.*")
    }

    /**
     * Gets the properties object for the storage account.
     */
    StorageAccountProperies::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Gets the kind of the storage account (e.g., StorageV2, BlobStorage).
     */
    StringLiteral getKind() { result = this.getProperty("kind") }

    /**
     * Gets the network ACLs for the storage account.
     */
    Network::NetworkAcl getNetworkAcls() { result = this.getProperties().getNetworkAcls() }

    /**
     * Gets the SKU for the storage account.
     */
    Sku getSku() { result = this.getProperty("sku") }

    override string toString() { result = "StorageAccount" }
  }

  /**
   * Represents a resource of type Microsoft.Compute/disks in Bicep.
   * Provides access to disk pools and disk properties.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/disks
   */
  class Disks extends Resource {
    /**
     * Constructs a Disks resource.
     */
    Disks() { this.getResourceType().regexpMatch("^Microsoft.Compute/disks@.*") }

    DisksProperties::Properties getProperties() { result = this.getProperty("properties") }

    StringLiteral getZones() {
      result = this.getProperty("zones").(Array).getElements()
    }
  
    DisksProperties::EncryptionSettings getEncryptionSettings() {
      result = this.getProperties().getEncryptionSettings()
    }

    /**
     * Gets the disk pools that this disk is attached to.
     */
    DiskPools getDiskPools() { exists(DiskPools pools | pools.getDisks() = this | result = pools) }

    override string toString() { result = "Disks" }
  }

  private class PublicDisks extends PublicResource {
    private StorageAccounts accounts;

    PublicDisks() {
      accounts.getProperties().allowBlobPublicAccess() = true
      and
      this = accounts
    }

    override Expr getPublicAccessProperty() { 
      result = accounts.getProperties().getAllowBlobPublicAccess()
    }
  }

  /**
   * Represents a resource of type Microsoft.StoragePool/diskPools in Bicep.
   * Provides access to disk pool properties, attached disks, and SKU.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.storagepool/diskpools
   */
  class DiskPools extends Resource {
    /**
     * Constructs a DiskPools resource.
     */
    DiskPools() { this.getResourceType().regexpMatch("^Microsoft.StoragePool/diskPools@.*") }

    /**
     * Gets the properties object for the disk pool.
     */
    DiskPoolProperties::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Gets the disks attached to this disk pool.
     */
    Disks getDisks() {
      exists(DiskPoolProperties::DiskRef refs, Disks disks |
        refs = this.getProperties().getDisksRef() and
        disks.getIdentifier().getName() = refs.id()
      |
        result = disks
      )
    }

    /**
     * Gets the SKU for the disk pool.
     */
    Sku getSku() { result = this.getProperty("sku") }

    override string toString() { result = "DiskPools" }
  }

  /**
   * Represents a resource of type Microsoft.Storage/storageAccounts/blobServices/containers in Bicep.
   * Provides access to container properties and public access settings.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts/blobservices/containers
   */
  class BlobServiceContainers extends Resource {
    /**
     * Constructs a BlobServiceContainers resource.
     */
    BlobServiceContainers() {
      this.getResourceType()
          .regexpMatch("^Microsoft.Storage/storageAccounts/blobServices/containers@.*")
    }

    /**
     * Gets the properties object for the blob service container.
     */
    Object getProperties() { result = this.getProperty("properties") }

    /**
     * Gets the public access setting for the container.
     */
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
        result = this.getProperty("encryption")
      }

      boolean getEncryptionEnabled() {
        result = this.getEncryptionSettings().getProperty("enabled").(Boolean).getBool()
      }

      Number getDiskSizeGB() { result = this.getProperty("diskSizeGB") }

      string toString() { result = "DiskProperties" }
    }

    class EncryptionSettings extends Object {
      private Object encryptionSettings;

      EncryptionSettings() { this = encryptionSettings.getProperty("encryption") }

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
