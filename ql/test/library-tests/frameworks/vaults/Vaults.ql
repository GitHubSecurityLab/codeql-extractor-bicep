import bicep

query predicate keyvault(KeyVault::VaultResource vault) {
  any()
}

query predicate keyvaultPolicies(KeyVault::VaultResource vault, KeyVault::KeyVaultProperties::AccessPolicy policy) {
  policy = vault.getAccessPolicies()
  
}
