/**
 *  Internal implementation for PropertyIdentifier
 */

private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Idents

/**
 *  A PropertyIdentifier AST Node.
 *  
 *  Represents the name part of a property in an object literal. PropertyIdentifier
 *  is a Token subtype in TreeSitter, which provides the getValue() method.
 */
class PropertyIdentifierImpl extends IdentsImpl, TPropertyIdentifier {
  private BICEP::PropertyIdentifier ast;

  override string getAPrimaryQlClass() { result = "PropertyIdentifier" }

  PropertyIdentifierImpl() { this = TPropertyIdentifier(ast) }

  override string toString() { result = ast.toString() }

  /**
   * Gets the name of this property identifier as a string.
   * 
   * @return The name of this property identifier
   */
  override string getName() { result = ast.getValue() }
}
