/**
 * @name Supports non-HTTPS traffic for storage accounts
 * @description Supports non-HTTPS traffic for storage accounts
 * @kind problem
 * @severity warning
 * @security-severity 9.0
 * @precision very-high
 * @id bicep/azure/storage-tls-disabled
 * @tags security
 *       bicep
 *       azure
 *       storage
 */

import bicep

from Storage::StorageAccounts storageAccount
where storageAccount.getProperties().supportsHttpsTrafficOnly() = false
select storageAccount.getProperties().getSupportsHttpsTrafficOnly(),
  "Supports non-HTTPS traffic for storage accounts."
