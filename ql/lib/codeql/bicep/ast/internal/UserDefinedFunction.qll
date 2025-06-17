/**
 *  Internal implementation for UserDefinedFunction
 *
 *  WARNING: this file is generated, do not edit manually
 */

private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Stmts
private import Identifier
private import Stmts
private import Type
private import Parameter
private import Parameters

/**
 *  A UserDefinedFunction AST Node.
 */
class UserDefinedFunctionImpl extends TUserDefinedFunction, StmtsImpl {
  private BICEP::UserDefinedFunction ast;

  override string getAPrimaryQlClass() { result = "UserDefinedFunction" }

  UserDefinedFunctionImpl() { this = TUserDefinedFunction(ast) }

  override string toString() { result = ast.toString() }

  IdentifierImpl getName() { toTreeSitter(result) = ast.getName() }

  ParametersImpl getParameters() { toTreeSitter(result) = ast.getChild(0) }

  TypeImpl getReturnType() { toTreeSitter(result) = ast.getReturns() }

  StmtsImpl getBody() { toTreeSitter(result) = ast.getChild(1) }
}
