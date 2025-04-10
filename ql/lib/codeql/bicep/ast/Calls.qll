private import AstNodes
private import Expr
private import Idents

abstract class Callable extends Expr {
  /**
   *  Gets the identifier of the call expression.
   */
  abstract Idents getIdentifier();

  /**
   * Gets the name of the call expression.
   */
  string getName() { result = this.getIdentifier().getName() }

  /**
   * Checks if the call expression has a specific name.
   */
  predicate hasName(string name) { this.getName() = name }
}