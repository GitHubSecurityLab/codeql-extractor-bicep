import bicep

query predicate storage(Storage::StorageAccounts storageAccount) {
  any() 
}

query predicate poolDisks(Storage::DiskPools pool, Storage::Disks disk) {
  pool.getDisks() = disk
}
