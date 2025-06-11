import bicep

query predicate mcr(ManagedContainers::ManagedContainerResource mcr) { any() }

query predicate mcrAgents(
  ManagedContainers::ManagedContainerResource mcr,
  ManagedContainers::ManagedContainerProperties::AgentPoolProfiles agents
) {
  mcr.getAgentPoolProfiles() = agents
}
