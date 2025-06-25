/**
 * @name AKS cluster with node auto-scaling disabled
 * @description Detects Azure Kubernetes Service (AKS) clusters with node auto-scaling disabled, which may lead to resource constraints during high load.
 * @kind problem
 * @problem.severity warning
 * @security-severity 4.0
 * @precision high
 * @id bicep/aks-node-auto-scaling-disabled
 * @tags security
 *       bicep
 *       azure
 *       CWE-400
 */

import codeql.bicep.frameworks.Microsoft.AKS

from AKS::ManagedContainerResource resource, AKS::ManagedContainerProperties::Properties properties,
     AKS::ManagedContainerProperties::AgentPoolProfile agentPool
where
  properties = resource.getProperties() and
  agentPool = properties.getAgentPoolProfiles() and
  (
    not exists(agentPool.getEnableAutoScaling()) or
    agentPool.getEnableAutoScaling().getBool() = false
  )
select agentPool, "AKS agent pool '" + agentPool.name() + "' has auto-scaling disabled, which may lead to resource constraints during high load."
