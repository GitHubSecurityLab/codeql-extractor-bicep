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
   * Provides access to disk properties, encryption, zones, and disk pools.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/disks
   */
  class Disks extends Resource {
    /**
     * Constructs a Disks resource.
     */
    Disks() { this.getResourceType().regexpMatch("^Microsoft.Compute/disks@.*") }

    /**
     * Gets the properties object for the disk.
     */
    DisksProperties::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Gets the zones for the disk as an array of strings.
     */
    StringLiteral getZones() {
      result = this.getProperty("zones").(Array).getElements()
    }

    /**
     * Gets the encryption settings for the disk.
     */
    DisksProperties::EncryptionSettings getEncryptionSettings() {
      result = this.getProperties().getEncryptionSettings()
    }

    /**
     * Gets the disk pools that this disk is attached to.
     */
    DiskPools getDiskPools() { exists(DiskPools pools | pools.getDisks() = this | result = pools) }

    override string toString() { result = "Disks" }
  }

  /**
   * Represents a public disk resource where blob public access is enabled.
   */
  private class PublicDisks extends PublicResource {
    private StorageAccounts accounts;

    /**
     * Constructs a PublicDisks resource if blob public access is enabled.
     */
    PublicDisks() {
      accounts.getProperties().allowBlobPublicAccess() = true
      and
      this = accounts
    }

    /**
     * Gets the property indicating public access for the disk.
     */
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

      /**
       * Constructs a Properties object for storage accounts.
       */
      Properties() { this = storageAccounts.getProperty("properties") }

      /**
       * Gets the minimum TLS version for the storage account.
       */
      StringLiteral getMinimumTlsVersion() { result = this.getProperty("minimumTlsVersion") }

      /**
       * Gets the minimum TLS version as a string.
       */
      string minimumTlsVersion() { result = this.getMinimumTlsVersion().getValue() }

      /**
       * Gets the property indicating whether blob public access is allowed.
       */
      Boolean getAllowBlobPublicAccess() { result = this.getProperty("allowBlobPublicAccess") }

      /**
       * Gets whether blob public access is allowed as a boolean.
       */
      boolean allowBlobPublicAccess() { result = this.getAllowBlobPublicAccess().getBool() }

      /**
       * Gets the property indicating whether HTTPS traffic is supported only.
       */
      Boolean getSupportsHttpsTrafficOnly() {
        result = this.getProperty("supportsHttpsTrafficOnly")
      }

      /**
       * Gets the network ACLs for the storage account.
       */
      Network::NetworkAcl getNetworkAcls() { result = this.getProperty("networkAcls") }

      /**
       * Gets the access tier for the storage account.
       */
      StringLiteral getAccessTier() { result = this.getProperty("accessTier") }

      /**
       * Gets the access tier as a string.
       */
      string accessTier() { result = this.getAccessTier().getValue() }

      /**
       * Gets the property indicating whether hierarchical namespace is enabled.
       */
      Boolean getIsHnsEnabled() { result = this.getProperty("isHnsEnabled") }

      /**
       * Gets whether hierarchical namespace is enabled as a boolean.
       */
      boolean isHnsEnabled() { result = this.getIsHnsEnabled().getBool() }

      /**
       * The property "supportsHttpsTrafficOnly" indicates whether the storage account
       * supports only HTTPS traffic. If this property is not set, it defaults to true.
       */
      boolean supportsHttpsTrafficOnly() { result = this.getSupportsHttpsTrafficOnly().getBool() }

      /**
       * Converts the properties object to a string representation.
       */
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

      /**
       * Constructs a Properties object for disks.
       */
      Properties() { this = disks.getProperty("properties") }

      /**
       * Gets the encryption settings for the disk.
       */
      EncryptionSettings getEncryptionSettings() {
        result = this.getProperty("encryption")
      }

      /**
       * Gets whether encryption is enabled for the disk.
       */
      boolean getEncryptionEnabled() {
        result = this.getEncryptionSettings().getProperty("enabled").(Boolean).getBool()
      }

      /**
       * Gets the size of the disk in GB.
       */
      Number getDiskSizeGB() { result = this.getProperty("diskSizeGB") }

      /**
       * Converts the properties object to a string representation.
       */
      string toString() { result = "DiskProperties" }
    }

    /**
     * Represents the encryption settings object for disks in Bicep.
     */
    class EncryptionSettings extends Object {
      private Object encryptionSettings;

      /**
       * Constructs an EncryptionSettings object for disks.
       */
      EncryptionSettings() { this = encryptionSettings.getProperty("encryption") }

      /**
       * Gets the type of encryption used for the disk.
       */
      StringLiteral getType() { result = this.getProperty("type") }

      /**
       * Gets whether encryption is enabled for the disk.
       */
      boolean isEncryptionEnabled() { result = this.getProperty("enabled").(Boolean).getBool() }

      /**
       * Gets the URI of the key vault key used for encryption.
       */
      string getKeyVaultKeyUri() {
        result = this.getProperty("keyVaultKeyUri").(StringLiteral).getValue()
      }

      /**
       * Converts the encryption settings object to a string representation.
       */
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

      /**
       * Constructs a Properties object for disk pools.
       */
      Properties() { this = diskPools.getProperty("properties") }

      /**
       * Gets the provisioning state of the disk pool.
       */
      StringLiteral getProvisioningState() { result = this.getProperty("provisioningState") }

      /**
       * Gets the references to disks attached to the disk pool.
       */
      DiskRef getDisksRef() { result = this.getProperty("disks").(Array).getElements() }

      /**
       * Converts the properties object to a string representation.
       */
      string toString() { result = "DiskPoolProperties" }
    }

    /**
     * Represents a reference to a disk in a disk pool.
     */
    class DiskRef extends Object {
      private Properties properties;

      /**
       * Constructs a DiskRef object for a disk in a disk pool.
       */
      DiskRef() { this = properties.getProperty("disks").(Array).getElements() }

      /**
       * Gets the ID of the disk reference.
       */
      MemberExpression getId() { result = this.getProperty("id") }

      /**
       * Gets the ID of the disk reference as a string.
       */
      string id() { result = this.getId().getNamespace().getName() }

      /**
       * Converts the disk reference object to a string representation.
       */
      string toString() { result = "DiskRef" }
    }
  }
}
