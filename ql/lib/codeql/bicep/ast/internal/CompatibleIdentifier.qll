/**
 *  Internal implementation for CompatibleIdentifier
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Idents
private import Identifier

/**
 *  A CompatibleIdentifier AST Node.
 */
class CompatibleIdentifierImpl extends IdentsImpl, TCompatibleIdentifier {
  private BICEP::CompatibleIdentifier ast;

  override string getAPrimaryQlClass() { result = "CompatibleIdentifier" }

  CompatibleIdentifierImpl() { this = TCompatibleIdentifier(ast) }

  override string toString() { result = ast.toString() }
  
  /**
   * Gets the underlying identifier.
   */
  IdentifierImpl getIdentifier() { 
    toTreeSitter(result) = ast.getChild() 
  }
  
  override string getName() { 
    result = this.getIdentifier().getName()
  }
}