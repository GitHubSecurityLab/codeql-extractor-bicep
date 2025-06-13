/**
 *  Internal implementation for ParameterDeclaration
 *
 *  WARNING: this file is generated, do not edit manually
 */

private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Identifier
private import Type
private import Expr

/**
 *  A ParameterDeclaration AST Node.
 */
class ParameterDeclarationImpl extends TParameterDeclaration, AstNode {
  private BICEP::ParameterDeclaration ast;

  override string getAPrimaryQlClass() { result = "ParameterDeclaration" }

  ParameterDeclarationImpl() { this = TParameterDeclaration(ast) }

  override string toString() { result = ast.toString() }

  IdentifierImpl getName() { toTreeSitter(result) = ast.getChild(0) }

  TypeImpl getType() { toTreeSitter(result) = ast.getChild(1) }

  ExprImpl getDefaultValue() { toTreeSitter(result) = ast.getChild(2) }
}
