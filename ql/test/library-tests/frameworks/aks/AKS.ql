import bicep

query predicate mcr(AKS::ManagedContainerResource mcr) { any() }

query predicate mcrAgents(
  AKS::ManagedContainerResource mcr,
  AKS::ManagedContainerProperties::AgentPoolProfiles agents
) {
  mcr.getAgentPoolProfiles() = agents
}
