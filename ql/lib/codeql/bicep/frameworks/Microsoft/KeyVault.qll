private import bicep
private import codeql.bicep.Concepts

module KeyVault {
  /**
   * Represents a Microsoft.KeyVault resource in a Bicep file.
   * Provides access to Key Vault properties, access policies, and network ACLs.
   */
  class VaultResource extends Resource {
    /**
     * Constructs a VaultResource for any Microsoft.KeyVault resource type.
     * Matches resources with type starting with "Microsoft.KeyVault/".
     */
    VaultResource() { this.getResourceType().regexpMatch("^Microsoft.KeyVault/.*") }

    /**
     * Gets the tenant ID for the Key Vault resource.
     */
    string tenantId() { result = this.getProperties().getTenantId().getValue() }

    /**
     * Gets the properties object for the Key Vault resource.
     */
    KeyVaultProperties::Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Gets the access policies for the Key Vault resource.
     */
    KeyVaultProperties::AccessPolicy getAccessPolicies() {
      result = this.getProperties().getAccessPolicies()
    }

    /**
     * Gets the network ACLs for the Key Vault resource.
     */
    Network::NetworkAcl getNetworkAcls() {
      result = this.getProperties().getNetworkAcls()
    }

    override string toString() { result = "Key Vault Resource" }
  }

  /**
   * Represents a public Microsoft.KeyVault resource with public network access enabled.
   */
  class PublicVaultResource extends PublicResource {
    private VaultResource vaultResource;

    /**
     * Constructs a PublicVaultResource for any Microsoft.KeyVault resource type
     * that has public network access enabled.
     */
    PublicVaultResource() {
      vaultResource.getProperties().publicNetworkAccess() = "Enabled" and
      this = vaultResource
    }

    /**
     * Gets the property that indicates public network access for the Key Vault resource.
     */
    override Expr getPublicAccessProperty() {
      result = vaultResource.getProperties().getPublicNetworkAccess()
    }

    override string toString() { result = "Public Key Vault Resource" }
  }

  module KeyVaultProperties {
    /**
     * The properties object for the Microsoft.KeyVault/vaults type.
     * Provides access to Key Vault configuration and settings.
     */
    class Properties extends Object {
      private VaultResource vaultResource;

      /**
       * Constructs a Properties object for the given Key Vault resource.
       */
      Properties() { this = vaultResource.getProperty("properties") }

      /**
       * Returns the parent VaultResource.
       */
      VaultResource getVaultResource() { result = vaultResource }

      /**
       * Gets the tenant ID property.
       */
      StringLiteral getTenantId() { result = this.getProperty("tenantId") }

      /**
       * Gets the tenant ID value.
       */
      string tenantId() { result = this.getTenantId().getValue() }

      /**
       * Gets the create mode property.
       */
      StringLiteral getCreateMode() { result = this.getProperty("createMode") }

      /**
       * Gets the create mode value.
       */
      string createMode() { result = this.getCreateMode().getValue() }

      /**
       * Gets the enabledForDeployment property.
       */
      Boolean getEnabledForDeployment() { result = this.getProperty("enabledForDeployment") }

      /**
       * Returns true if enabled for deployment.
       */
      boolean enabledForDeployment() { result = this.getEnabledForDeployment().getBool() }

      /**
       * Gets the enabledForDiskEncryption property.
       */
      Boolean getEnabledForDiskEncryption() {
        result = this.getProperty("enabledForDiskEncryption")
      }

      /**
       * Returns true if enabled for disk encryption.
       */
      boolean enabledForDiskEncryption() { result = this.getEnabledForDiskEncryption().getBool() }

      /**
       * Gets the enabledForTemplateDeployment property.
       */
      Boolean getEnabledForTemplateDeployment() {
        result = this.getProperty("enabledForTemplateDeployment")
      }

      /**
       * Returns true if enabled for template deployment.
       */
      boolean enabledForTemplateDeployment() {
        result = this.getEnabledForTemplateDeployment().getBool()
      }

      /**
       * Gets the softDeleteEnabled property.
       */
      Boolean getSoftDeleteEnabled() { result = this.getProperty("softDeleteEnabled") }

      /**
       * Returns true if soft delete is enabled.
       */
      boolean softDeleteEnabled() { result = this.getSoftDeleteEnabled().getBool() }

      /**
       * Gets the purgeProtectionEnabled property.
       */
      Boolean getPurgeProtectionEnabled() { result = this.getProperty("purgeProtectionEnabled") }

      /**
       * Returns true if purge protection is enabled.
       */
      boolean purgeProtectionEnabled() { result = this.getPurgeProtectionEnabled().getBool() }

      /**
       * Gets the publicNetworkAccess property.
       */
      StringLiteral getPublicNetworkAccess() { result = this.getProperty("publicNetworkAccess") }

      /**
       * Gets the public network access value.
       */
      string publicNetworkAccess() { result = this.getPublicNetworkAccess().getValue() }

      /**
       * Gets the network ACLs for the Key Vault.
       */
      Network::NetworkAcl getNetworkAcls() {
        result = this.getProperty("networkAcls")
      }

      /**
       * Gets all access policies for the Key Vault.
       */
      AccessPolicy getAccessPolicies() {
        result = this.getProperty("accessPolicies").(Array).getElements()
      }

      /**
       * Gets a specific access policy by index.
       */
      AccessPolicy getAccessPolicy(int index) {
        result = this.getProperty("accessPolicies").(Array).getElement(index)
      }
    }

    /**
     * Represents an access policy for a Key Vault resource.
     */
    class AccessPolicy extends Object {
      private KeyVaultProperties::Properties properties;

      /**
       * Constructs an AccessPolicy object for the given Key Vault properties.
       */
      AccessPolicy() { this = properties.getProperty("accessPolicies").(Array).getElements() }

      /**
       * Returns the tenant ID of the access policy.
       */
      string getTenantId() { result = this.getProperty("tenantId").(StringLiteral).getValue() }

      /**
       * Returns the object ID of the access policy.
       */
      string getObjectId() { result = this.getProperty("objectId").(StringLiteral).getValue() }

      /**
       * Returns a string representation of the access policy.
       */
      string toString() { result = "AccessPolicy" }
    }

    /**
     * Represents the permissions associated with a Key Vault access policy.
     */
    class AccessPolicyPermissions extends Object {
      private AccessPolicy accessPolicy;

      /**
       * Constructs an AccessPolicyPermissions object for the given access policy.
       */
      AccessPolicyPermissions() { this = accessPolicy.getProperty("permissions") }

      /**
       * Gets the certificates permissions array.
       */
      Array getCertificates() { result = this.getProperty("certificates") }

      /**
       * Gets a certificate permission by index.
       */
      StringLiteral getCertificate(int index) { result = this.getCertificates().getElement(index) }

      /**
       * Gets the keys permissions array.
       */
      Array getKeys() { result = this.getProperty("keys") }

      /**
       * Gets a key permission by index.
       */
      StringLiteral getKey(int index) { result = this.getKeys().getElement(index) }

      /**
       * Gets the secrets permissions array.
       */
      Array getSecrets() { result = this.getProperty("secrets") }

      /**
       * Gets a secret permission by index.
       */
      StringLiteral getSecret(int index) { result = this.getSecrets().getElement(index) }

      /**
       * Gets the storage permissions array.
       */
      Array getStorages() { result = this.getProperty("storage") }

      /**
       * Gets a storage permission by index.
       */
      StringLiteral getStorage(int index) { result = this.getStorages().getElement(index) }

      /**
       * Returns a string representation of the access policy permissions.
       */
      string toString() { result = "AccessPolicyPermissions" }
    }
  }
}
