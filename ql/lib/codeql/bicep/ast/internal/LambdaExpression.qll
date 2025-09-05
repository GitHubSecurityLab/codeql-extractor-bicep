/**
 *  Internal implementation for LambdaExpression
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Calls
private import Expr
private import Idents
private import Stmts
private import Parameter
private import Parameters
private import Type


/**
 *  A LambdaExpression AST Node.
 */
class LambdaExpressionImpl extends TLambdaExpression, CallableImpl {
  private BICEP::LambdaExpression ast;

  override string getAPrimaryQlClass() { result = "LambdaExpression" }

  LambdaExpressionImpl() { this = TLambdaExpression(ast) }

  override string toString() { result = ast.toString() }
  
  override AstNode getIdentifier() {
    // LambdaExpression doesn't have a direct identifier, so we return nothing
    none()
  }
  
  override ParametersImpl getParameters() {
    toTreeSitter(result) = ast.getChild(0)
  }
  
  override ParameterImpl getParameter(int n) {
    result = this.getParameters().getParameter(n)
  }
  
  override StmtSequenceImpl getBody() {
    // Return the body of the lambda expression
    toTreeSitter(result) = ast.getChild(1)
  }
  
  override TypeImpl getType() {
    // For LambdaExpression, we might not have a direct type
    none()
  }
  
  override int getNumberOfParameters() { result = count(int i | exists(this.getParameter(i))) }
}