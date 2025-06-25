import bicep

query predicate mcr(AKS::ManagedContainerResource mcr) { any() }

query predicate mcrAgents(
  AKS::ManagedContainerResource mcr, AKS::ManagedContainerProperties::AgentPoolProfile agents
) {
  mcr.getAgentPoolProfiles() = agents
}

query predicate mcrOsProfile(AKS::ManagedContainerResource mcr, OsProfiles::OsProfile osProfile) {
  mcr.getOsProfile() = osProfile
}

query predicate mcrNetworkProfiles(
  AKS::ManagedContainerResource mcr, NetworkingProfiles::NetworkProfile networkProfile
) {
  mcr.getNetworkProfile() = networkProfile
}
