private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes


/**
 * Literal statements.
 */
class IdentsImpl extends AstNode, TIdents {
  override string getAPrimaryQlClass() { result = "Idents" }

  /** 
   * Get the value of the literal 
   */
  abstract string getName();
}
