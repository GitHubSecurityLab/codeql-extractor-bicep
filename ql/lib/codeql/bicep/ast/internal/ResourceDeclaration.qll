/**
 *  Internal implementation for ResourceDeclaration
 *
 *  WARNING: this file is generated, do not edit manually
 */

private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import String
private import Object
private import Idents

/**
 *  A ResourceDeclaration AST Node.
 */
class ResourceDeclarationImpl extends TResourceDeclaration, AstNode {
  private BICEP::ResourceDeclaration ast;

  override string getAPrimaryQlClass() { result = "ResourceDeclaration" }

  ResourceDeclarationImpl() { this = TResourceDeclaration(ast) }

  override string toString() { result = ast.toString() }

  IdentsImpl getIdentifier() { toTreeSitter(result) = ast.getChild(0) }

  StringImpl getName() { toTreeSitter(result) = ast.getChild(1) }

  ObjectImpl getObject() { toTreeSitter(result) = ast.getChild(2) }
}
