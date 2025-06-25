/**
 * @name AKS cluster with local accounts enabled
 * @description Detects Azure Kubernetes Service (AKS) clusters with local accounts enabled, which can lead to weaker authentication controls.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id bicep/aks-local-accounts-enabled
 * @tags security
 *       bicep
 *       azure
 *       CWE-306
 */

import codeql.bicep.frameworks.Microsoft.AKS

from AKS::ManagedContainerResource resource, AKS::ManagedContainerProperties::Properties properties
where
  properties = resource.getProperties() and
  (
    not exists(properties.getDisableLocalAccounts()) or
    properties.getDisableLocalAccounts().getBool() = false
  )
select resource, "AKS cluster has local accounts enabled, which can lead to weaker authentication controls compared to Azure AD-backed authentication."
