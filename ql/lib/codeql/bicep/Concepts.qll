private import codeql.bicep.AST
private import codeql.bicep.CFG

/**
 *  A Public Resource is a resource that is publicly accessible to the Internet.
 */
abstract class PublicResource extends Resource {
  /**
   *  Returns the property that indicates public access.
   */
  abstract Expr getPublicAccessProperty();
}

module Cryptography {
  abstract class WeakTlsVersion extends Resource {
    abstract Expr getWeakTlsVersionProperty();

    /**
     *  Returns true if the resource has a weak TLS version.
     * 
     *  1.0 and 1.1 are considered weak TLS versions.
     */
    predicate hasWeakTlsVersion() {
      exists(StringLiteral literal |
        literal = this.getWeakTlsVersionProperty() and
        literal.getValue().regexpMatch("^(1\\.0|1\\.1)$")
      )
    }
  }
}
