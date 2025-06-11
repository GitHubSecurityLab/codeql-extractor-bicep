/**
 * @name Insecure CORS: Wildcard Origin
 * @description Flags CORS policies that allow any origin ("*"), which is insecure for sensitive APIs.
 * @kind problem
 * @problem.severity error
 * @security-severity 4.0
 * @precision high
 * @id bicep/insecure-cors-wildcard-origin
 * @tags security
 *       bicep
 */

import bicep

from Network::CorsPolicy cors, Network::Ingress ingress, Resource resource
where
  ingress.getCorsPolicy() = cors and
  exists(Array origins | origins = cors.getAllowedOrigins() |
    exists(StringLiteral origin | origin = origins.getElements() | origin.getValue() = "*")
  )
select resource, "CORS policy allows any origin (\"*\"), which is insecure for sensitive APIs."
