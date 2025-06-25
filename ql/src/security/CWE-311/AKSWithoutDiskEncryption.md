# AKS cluster without disk encryption

Azure Kubernetes Service (AKS) clusters should utilize disk encryption to protect sensitive data at rest. Without disk encryption, data stored on node disks could be vulnerable to unauthorized access if the storage is compromised.

## Problem statement

When an AKS cluster is configured without disk encryption:

1. Node VM disks including OS disks and data disks could store data in an unencrypted format
2. In case of physical theft, hardware decommissioning, or improper disk handling, sensitive data might be exposed
3. Security and compliance requirements (like HIPAA, PCI DSS, or GDPR) may be violated
4. If a node is compromised, an attacker may be able to access data directly from the disk

## Recommendation

Configure disk encryption for your AKS cluster by setting a disk encryption set ID:

```bicep
resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2022-07-02' = {
  name: 'myDiskEncryptionSet'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    activeKey: {
      keyUrl: keyVault.getSecret('encryptionKey').id
    }
  }
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'secureAksCluster'
  location: location
  properties: {
    // Other properties...
    diskEncryptionSetID: diskEncryptionSet.id
    // Other properties...
  }
}
```

## Example

### Insecure configuration (No disk encryption)

```bicep
resource aksClusterInsecure 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterInsecure'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    // Missing diskEncryptionSetID
    // Other properties...
  }
}
```

### Secure configuration (With disk encryption)

```bicep
resource aksClusterSecure 'Microsoft.ContainerService/managedClusters@2023-02-02-preview' = {
  name: 'aksClusterSecure'
  location: location
  properties: {
    kubernetesVersion: '1.24.9'
    dnsPrefix: 'aksdns'
    diskEncryptionSetID: diskEncryptionSet.id // Secure: Using disk encryption
    // Other properties...
  }
}
```

## References

* [Azure Disk Encryption for AKS clusters](https://learn.microsoft.com/en-us/azure/aks/azure-disk-customer-managed-keys)
* [Data encryption in AKS](https://learn.microsoft.com/en-us/azure/aks/concepts-data-encryption)
