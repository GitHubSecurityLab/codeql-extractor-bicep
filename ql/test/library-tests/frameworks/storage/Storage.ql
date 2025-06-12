import bicep

query predicate storage(Storage::StorageAccounts storageAccount) { any() }

query predicate poolDisks(Storage::DiskPools pool, Storage::Disks disk) { pool.getDisks() = disk }

query predicate diskEncryption(
  Storage::Disks disk, Storage::DiskEncryption::EncryptionSettings encryptionSettings
) {
  disk.getEncryptionSettings() = encryptionSettings
}

query predicate accountEncryption(
  Storage::StorageAccounts storageAccount,
  Storage::DiskEncryption::EncryptionSettings encryptionSettings
) {
  storageAccount.getEncryptionSettings() = encryptionSettings
}
