/**
 * @name Insecure CORS: All Headers Allowed
 * @description Flags CORS policies that allow all headers ("*"), which can increase attack surface.
 * @kind problem
 * @problem.severity error
 * @security-severity 4.0
 * @precision high
 * @id bicep/insecure-cors-all-headers
 * @tags security
 *       bicep
 */

import bicep

from Network::CorsPolicy cors, Containers::ContainerResource resource
where
  resource.getCorsPolicy() = cors and
  exists(Array headers | headers = cors.getAllowedHeaders() |
    exists(StringLiteral header | header = headers.getElements() | header.getValue() = "*")
  )
select cors.getAllowedHeaders(),
  "CORS policy allows all headers (\"*\"), which can increase attack surface."
