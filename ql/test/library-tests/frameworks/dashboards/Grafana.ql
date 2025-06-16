private import bicep

query predicate grafana(Dashboards::GrafanaResource grafana) { any() }

query predicate publicGrafana(Dashboards::PublicGrafanaResource publicGrafana) { any() }

query predicate grafanaProperties(
  Dashboards::GrafanaResource grafana, Dashboards::GrafanaProperties::Properties properties
) {
  grafana.getProperties() = properties
}

query predicate grafanaEnterpriseConfig(
  Dashboards::GrafanaResource grafana,
  Dashboards::GrafanaProperties::EnterpriseConfigurations enterpriseConfig
) {
  grafana.getProperties().getEnterpriseConfigurations() = enterpriseConfig
}
