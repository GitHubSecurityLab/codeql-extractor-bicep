import bicep

query predicate keyvault(KeyVault::VaultResource vault) { any() }

query predicate keyvaultPolicies(
  KeyVault::VaultResource vault, KeyVault::KeyVaultProperties::AccessPolicy policy
) {
  policy = vault.getAccessPolicies()
}

query predicate keyvaultNetworkAcls(
  KeyVault::VaultResource vault, Network::NetworkAcl networkAcl
) {
  networkAcl = vault.getNetworkAcls()
}
