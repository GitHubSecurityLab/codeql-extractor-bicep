/**
 *  Internal implementation for UserDefinedFunction
 */

private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Calls
private import Stmts
private import Identifier
private import Type
private import Parameter
private import Parameters
private import Expr

/**
 *  A UserDefinedFunction AST Node.
 */
class UserDefinedFunctionImpl extends TUserDefinedFunction, CallableImpl {
  private BICEP::UserDefinedFunction ast;

  override string getAPrimaryQlClass() { result = "UserDefinedFunction" }

  UserDefinedFunctionImpl() { this = TUserDefinedFunction(ast) }

  override string toString() { result = ast.toString() }

  override IdentifierImpl getIdentifier() { toTreeSitter(result) = ast.getName() }

  override ParametersImpl getParameters() { toTreeSitter(result) = ast.getChild(0) }

  override ParameterImpl getParameter(int n) {
    exists(ParametersImpl params |
      params = this.getParameters() and
      result = params.getParameter(n)
    )
  }

  TypeImpl getReturnType() { toTreeSitter(result) = ast.getReturns() }

  override StmtSequenceImpl getBody() { toTreeSitter(result) = ast.getChild(1) }

  override TypeImpl getType() { result = this.getReturnType() }
}
