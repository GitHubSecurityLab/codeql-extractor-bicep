/**
 * @name AKS cluster with kubeDashboard enabled
 * @description Detects Azure Kubernetes Service (AKS) clusters where the kubeDashboard addon is enabled (insecure configuration).
 * @kind problem
 * @problem.severity warning
 * @id bicep/aks-kubedashboard-enabled
 * @tags security, kubernetes, azure, aks
 */
import codeql.bicep.frameworks.Microsoft.AKS

from AKS::ManagedContainerResource r, 
     AKS::ManagedContainerProperties::AddonProfiles addons, 
     AKS::ManagedContainerProperties::AddonKubeDashboard dashboard
where
  addons = r.getProperties().getAddonProfiles() and
  dashboard = addons.getKubeDashboard() and
  dashboard.enabled() = true
select r, "AKS cluster has kubeDashboard addon enabled (insecure configuration)."
