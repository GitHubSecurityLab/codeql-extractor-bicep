private import bicep
private import codeql.bicep.Concepts
private import Network

module KeyVault {
  class VaultResource extends Resource {
    /**
     * Constructs a VaultResource for any Microsoft.KeyVault resource type.
     */
    VaultResource() { this.getResourceType().regexpMatch("^Microsoft.KeyVault/.*") }

    string tenantId() { result = this.getProperties().getTenantId().getValue() }

    KeyVaultProperties::Properties getProperties() { result = this.getProperty("properties") }

    KeyVaultProperties::AccessPolicy getAccessPolicies() {
      result = this.getProperties().getAccessPolicies()
    }

    Network::NetworkAcl getNetworkAcls() {
      result = this.getProperties().getNetworkAcls()
    }

    override string toString() { result = "Key Vault Resource" }
  }

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

    override Expr getPublicAccessProperty() {
      result = vaultResource.getProperties().getPublicNetworkAccess()
    }

    override string toString() { result = "Public Key Vault Resource" }
  }

  module KeyVaultProperties {
    /**
     * The properties object for the Microsoft.KeyVault/vaults type.
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

      StringLiteral getTenantId() { result = this.getProperty("tenantId") }

      string tenantId() { result = this.getTenantId().getValue() }

      StringLiteral getCreateMode() { result = this.getProperty("createMode") }

      string createMode() { result = this.getCreateMode().getValue() }

      Boolean getEnabledForDeployment() { result = this.getProperty("enabledForDeployment") }

      boolean enabledForDeployment() { result = this.getEnabledForDeployment().getBool() }

      Boolean getEnabledForDiskEncryption() {
        result = this.getProperty("enabledForDiskEncryption")
      }

      boolean enabledForDiskEncryption() { result = this.getEnabledForDiskEncryption().getBool() }

      Boolean getEnabledForTemplateDeployment() {
        result = this.getProperty("enabledForTemplateDeployment")
      }

      boolean enabledForTemplateDeployment() {
        result = this.getEnabledForTemplateDeployment().getBool()
      }

      Boolean getSoftDeleteEnabled() { result = this.getProperty("softDeleteEnabled") }

      boolean softDeleteEnabled() { result = this.getSoftDeleteEnabled().getBool() }

      Boolean getPurgeProtectionEnabled() { result = this.getProperty("purgeProtectionEnabled") }

      boolean purgeProtectionEnabled() { result = this.getPurgeProtectionEnabled().getBool() }

      StringLiteral getPublicNetworkAccess() { result = this.getProperty("publicNetworkAccess") }

      string publicNetworkAccess() { result = this.getPublicNetworkAccess().getValue() }

      Network::NetworkAcl getNetworkAcls() {
        result = this.getProperty("networkAcls")
      }

      AccessPolicy getAccessPolicies() {
        result = this.getProperty("accessPolicies").(Array).getElements()
      }

      AccessPolicy getAccessPolicy(int index) {
        result = this.getProperty("accessPolicies").(Array).getElement(index)
      }
    }

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

      string toString() { result = "AccessPolicy" }
    }

    class AccessPolicyPermissions extends Object {
      private AccessPolicy accessPolicy;

      /**
       * Constructs an AccessPolicyPermissions object for the given access policy.
       */
      AccessPolicyPermissions() { this = accessPolicy.getProperty("permissions") }

      Array getCertificates() { result = this.getProperty("certificates") }

      StringLiteral getCertificate(int index) { result = this.getCertificates().getElement(index) }

      Array getKeys() { result = this.getProperty("keys") }

      StringLiteral getKey(int index) { result = this.getKeys().getElement(index) }

      Array getSecrets() { result = this.getProperty("secrets") }

      StringLiteral getSecret(int index) { result = this.getSecrets().getElement(index) }

      Array getStorages() { result = this.getProperty("storage") }

      StringLiteral getStorage(int index) { result = this.getStorages().getElement(index) }

      string toString() { result = "AccessPolicyPermissions" }
    }
  }
}
