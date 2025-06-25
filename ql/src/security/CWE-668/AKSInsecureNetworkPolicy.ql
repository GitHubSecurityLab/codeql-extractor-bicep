/**
 * @name AKS cluster with insecure network policy
 * @description Detects Azure Kubernetes Service (AKS) clusters configured with an insecure or missing network policy, which may allow unwanted pod-to-pod communication.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.5
 * @precision high
 * @id bicep/aks-insecure-network-policy
 * @tags security
 *       bicep
 *       azure
 *       CWE-668
 */

import codeql.bicep.frameworks.Microsoft.AKS
import bicep

from AKS::ManagedContainerResource resource, AKS::ManagedContainerProperties::Properties properties, 
     Object networkProfile
where
  properties = resource.getProperties() and
  networkProfile = properties.getNetworkProfile() and
  (
    not exists(networkProfile.getProperty("networkPolicy")) or
    networkProfile.getProperty("networkPolicy").(StringLiteral).getValue() = "none"
  )
select resource, "AKS cluster is configured with an insecure or missing network policy, which may allow unwanted pod-to-pod communication."
