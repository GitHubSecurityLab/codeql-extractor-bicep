import bicep

query predicate containers(Containers::ContainerResource container) { any() }

query predicate containerConfig(
  Containers::ContainerResource container,
  Containers::ContainerProperties::ContainerConfiguration config
) {
  container.getConfiguration() = config
}

query predicate containerIngress(Containers::ContainerResource container, Network::Ingress ingress) {
  container.getNetworkIngress() = ingress
}

query predicate containerSecrets(
  Containers::ContainerResource container, Containers::ContainerProperties::ContainerSecret secrets
) {
  container.getConfiguration().getSecrets() = secrets
}

query predicate containerReg(
  Containers::ContainerResource container, Containers::ContainerProperties::ContainerRegistry reg
) {
  reg = container.getConfiguration().getRegistries()
}
