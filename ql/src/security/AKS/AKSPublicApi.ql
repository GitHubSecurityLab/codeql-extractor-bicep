/**
 * @name AKS cluster with public API server
 * @description Detects Azure Kubernetes Service (AKS) clusters where the API server is publicly accessible (private cluster not enabled).
 * @kind problem
 * @problem.severity warning
 * @id bicep/aks-public-api-server
 * @tags security
 *       azure
 *       kubernetes
 */
import bicep

from AKS::ManagedContainerResource r, 
     AKS::ManagedContainerProperties::ApiServerAccessProfile api
where
  api = r.getProperties().getApiServerAccessProfile() and
  (
    // enablePrivateCluster is missing or set to false
    not exists(api.getEnablePrivateCluster()) or
    api.enablePrivateCluster() = false
  )
select r, "AKS cluster API server is publicly accessible (private cluster not enabled)."
