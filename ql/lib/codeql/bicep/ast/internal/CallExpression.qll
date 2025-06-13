/**
 *  Internal implementation for CallExpression
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Expr
private import Expression
private import Idents
private import Arguments
private import NullableReturnType

/**
 *  A CallExpression AST Node.
 */
class CallExpressionImpl extends TCallExpression, ExprImpl {
  private BICEP::CallExpression ast;

  override string getAPrimaryQlClass() { result = "CallExpression" }

  CallExpressionImpl() { this = TCallExpression(ast) }

  override string toString() { result = ast.toString() }

  IdentsImpl getIdentifier() {
    toTreeSitter(result) = ast.getFunction()
  }

  ArgumentsImpl getArguments() {
    toTreeSitter(result) = ast.getArguments()
  }

  NullableReturnTypeImpl getReturnType() {
    toTreeSitter(result) = ast.getChild()
  }
}