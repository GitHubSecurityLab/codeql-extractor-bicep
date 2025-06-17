private import codeql.bicep.AST
private import codeql.bicep.CFG
private import codeql.bicep.DataFlow
private import codeql.threatmodels.ThreatModels


/**
 * A data flow source for a specific threat-model.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `ThreatModelSource::Range` instead.
 */
final class ThreatModelSource = ThreatModelSource::Range;

/**
 * Provides a class for modeling new sources for specific threat-models.
 */
module ThreatModelSource {
  /**
   * A data flow source, for a specific threat-model.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets a string that represents the source kind with respect to threat modeling.
     *
     * See
     * - https://github.com/github/codeql/blob/main/docs/codeql/reusables/threat-model-description.rst
     * - https://github.com/github/codeql/blob/main/shared/threat-models/ext/threat-model-grouping.model.yml
     */
    abstract string getThreatModel();

    /**
     * Gets a string that describes the type of this threat-model source.
     */
    abstract string getSourceType();
  }
}

/**
 * A data flow source that is enabled in the current threat model configuration.
 */
class ActiveThreatModelSource extends ThreatModelSource {
  ActiveThreatModelSource() { currentThreatModel(this.getThreatModel()) }
}

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
  abstract class TlsDisabled extends Resource {
    abstract boolean isTlsDisabled();
  }

  abstract class WeakTlsVersion extends Resource {
    abstract StringLiteral getWeakTlsVersionProperty();

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
