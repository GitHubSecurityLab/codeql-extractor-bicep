/**
 * @name AKS cluster with private API server enabled
 * @description Detects Azure Kubernetes Service (AKS) clusters where the API server is private (private cluster enabled).
 * @kind problem
 * @problem.severity recommendation
 * @id bicep/aks-private-api-server-enabled
 * @tags security
 *       kubernetes
 *       azure
 */
import codeql.bicep.frameworks.Microsoft.AKS

from AKS::ManagedContainerResource r, 
     AKS::ManagedContainerProperties::ApiServerAccessProfile api
where
  api = r.getProperties().getApiServerAccessProfile() and
  api.enablePrivateCluster() = true
select r, "AKS cluster API server is private (private cluster enabled)."
