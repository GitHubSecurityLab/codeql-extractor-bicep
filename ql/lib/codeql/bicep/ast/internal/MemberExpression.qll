/**
 *  Internal implementation for MemberExpression
 *
 *  WARNING: this file is generated, do not edit manually
 */

private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Expr
private import PropertyIdentifier

/**
 *  A MemberExpression AST Node.
 */
class MemberExpressionImpl extends TMemberExpression, ExprImpl {
  private BICEP::MemberExpression ast;

  override string getAPrimaryQlClass() { result = "MemberExpression" }

  MemberExpressionImpl() { this = TMemberExpression(ast) }

  override string toString() { result = ast.toString() }

  ExprImpl getObject() { toTreeSitter(result) = ast.getObject() }

  PropertyIdentifierImpl getProperty() { toTreeSitter(result) = ast.getProperty() }
}
