private import bicep
import codeql.bicep.frameworks.Microsoft.Web

query predicate webApps(Web::WebResource web) { any() }

query predicate webSites(Web::SitesResource sites) { any() }

query predicate webSlots(Web::SlotResource slots) { any() }

query predicate webServerFarms(Web::ServerFarmsResource serverFarm) { any() }
