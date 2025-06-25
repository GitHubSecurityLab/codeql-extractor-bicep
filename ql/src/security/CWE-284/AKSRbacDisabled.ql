/**
 * @name AKS cluster with RBAC disabled
 * @description Detects Azure Kubernetes Service (AKS) clusters where RBAC is disabled, which can lead to unauthorized access to the cluster.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id bicep/aks-rbac-disabled
 * @tags security
 *       bicep
 *       azure
 *       CWE-284
 */

import codeql.bicep.frameworks.Microsoft.AKS

from AKS::ManagedContainerResource resource, AKS::ManagedContainerProperties::Properties properties
where
  properties = resource.getProperties() and
  (
    // RBAC is explicitly disabled
    exists(properties.getEnableRBAC()) and
    properties.getEnableRBAC().getBool() = false
  )
select resource, "AKS cluster has RBAC disabled, which can lead to unauthorized access to the cluster."
