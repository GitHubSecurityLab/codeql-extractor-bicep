/**
 * @name Weak TLS Version
 * @description Weak TLS versions (1.0 and 1.1) should not be used as they are considered insecure.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision high
 * @id bicep/weak-tls-version
 * @tags security
 *       bicep
 *       azure
 *       cryptography
 */
import bicep

from Cryptography::WeakTlsVersion resource
where
    resource.hasWeakTlsVersion()
select resource.getWeakTlsVersionProperty(), "Weak TLS version detected"