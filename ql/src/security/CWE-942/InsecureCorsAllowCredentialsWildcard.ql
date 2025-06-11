/**
 * @name Insecure CORS: AllowCredentials with Wildcard Origin
 * @description Flags CORS policies that allow credentials with a wildcard origin, which is insecure.
 * @kind problem
 * @problem.severity error
 * @id bicep/insecure-cors-allowcredentials-wildcard
 */
import bicep

from
  Network::CorsPolicy cors,
  Network::Ingress ingress,
  Resource resource
where
  ingress.getCorsPolicy() = cors and
  cors.allowCredentials() = true and
  exists(Array origins | origins = cors.getAllowedOrigins() |
    exists(StringLiteral origin | origin = origins.getElements() | origin.getValue() = "*" )
  )
select resource, "CORS policy allows credentials with a wildcard origin, which is insecure."
