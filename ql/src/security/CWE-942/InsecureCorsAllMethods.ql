/**
 * @name Insecure CORS: All Methods Allowed
 * @description Flags CORS policies that allow all HTTP methods ("*") which can expose APIs to abuse.
 * @kind problem
 * @problem.severity warning
 * @id bicep/insecure-cors-all-methods
 */

import bicep

from Network::CorsPolicy cors, Network::Ingress ingress, Resource resource
where
  ingress.getCorsPolicy() = cors and
  exists(Array methods | methods = cors.getAllowedMethods() |
    exists(StringLiteral method | method = methods.getElements() | method.getValue() = "*")
  )
select resource, "CORS policy allows all HTTP methods (\"*\"), which can expose APIs to abuse."
