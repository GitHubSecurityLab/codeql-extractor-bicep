/**
 *  Internal implementation for CallExpression
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Expr
private import Calls
private import Expression
private import Idents
private import Arguments
private import NullableReturnType

/**
 *  A CallExpression AST Node.
 */
class CallExpressionImpl extends TCallExpression, CallImpl {
  private BICEP::CallExpression ast;

  override string getAPrimaryQlClass() { result = "CallExpression" }

  CallExpressionImpl() { this = TCallExpression(ast) }

  override string toString() { result = ast.toString() }

  override IdentsImpl getIdentifier() {
    toTreeSitter(result) = ast.getFunction()
  }

  override ArgumentsImpl getArguments() {
    toTreeSitter(result) = ast.getArguments()
  }

  override ExprImpl getArgument(int n) {
    result = this.getArguments().getArgument(n)
  }

  override ExprImpl getArgumentByName(string name) {
    result = this.getArguments().getArgumentByName(name)
  }

  override IdentsImpl getReceiver() { none() }

  override int getNumberOfArguments() { result = this.getArguments().getNumberOfArguments() }

  NullableReturnTypeImpl getReturnType() {
    toTreeSitter(result) = ast.getChild()
  }
}