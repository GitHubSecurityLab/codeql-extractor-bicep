/**
 * @name AKS cluster without disk encryption
 * @description Detects Azure Kubernetes Service (AKS) clusters without disk encryption, which can expose sensitive data.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.0
 * @precision high
 * @id bicep/aks-without-disk-encryption
 * @tags security
 *       bicep
 *       azure
 *       CWE-311
 */

import codeql.bicep.frameworks.Microsoft.AKS
import bicep

from AKS::ManagedContainerResource resource, AKS::ManagedContainerProperties::Properties properties
where
  properties = resource.getProperties() and
  not exists(properties.getDiskEncryptionSetID())
select resource, "AKS cluster is configured without disk encryption, which can expose sensitive data at rest."
