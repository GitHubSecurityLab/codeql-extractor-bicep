/**
 * @name AKS cluster with public network access enabled
 * @description Detects Azure Kubernetes Service (AKS) clusters with public network access enabled, which can expose the cluster to potential unauthorized access.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision high
 * @id bicep/aks-public-network-access
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
    (
      exists(properties.getPublicNetworkAccess()) and
      properties.getPublicNetworkAccess().getValue().toLowerCase() = "enabled"
    ) or
    not exists(properties.getPublicNetworkAccess()) // Default is "enabled" if not specified
  ) and
  // Exclude clusters that have private API server enabled
  (
    not exists(properties.getApiServerAccessProfile()) or
    not exists(properties.getApiServerAccessProfile().getEnablePrivateCluster()) or
    properties.getApiServerAccessProfile().enablePrivateCluster() = false
  )
select resource, "AKS cluster has public network access enabled, which can expose the cluster to unauthorized access."
