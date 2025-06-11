/**
 * @name TLS Disabled
 * @description Detects resources where TLS is disabled, which is insecure.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.5
 * @precision high
 * @id bicep/tls-disabled
 * @tags security
 *       bicep
 *       azure
 *       cryptography
 */
import bicep

from Cryptography::TlsDisabled resource
where resource.isTlsDisabled() = true
select resource, "TLS is disabled for this resource"
