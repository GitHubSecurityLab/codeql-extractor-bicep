import bicep

query predicate resolveIdentifier(Network::VirtualNetworks vn, Network::VirtualNetworkSubnets vns) {
  vns.getParent() = vn
}

query predicate resolveResource(Compute::VirtualMachines vm, Network::NetworkInterfaces ni) {
  ni = vm.getNetworkInterfaces()
}

query predicate resolveProperties(Compute::VirtualMachines vm, Object subnet) {
  subnet = vm.getProperties().getNetworkProfile().getProperty("subnet")
  
}
