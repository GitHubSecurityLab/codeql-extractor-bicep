/**
 *  Internal implementation for Parameter
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Idents
private import Expr
private import Type

/**
 *  A Parameter AST Node.
 */
class ParameterImpl extends TParameter, AstNode {
  private BICEP::Parameter ast;

  override string getAPrimaryQlClass() { result = "Parameter" }

  ParameterImpl() { this = TParameter(ast) }

  override string toString() { result = ast.toString() }

  IdentsImpl getName() {
    toTreeSitter(result) = ast.getChild(0)
  }

  TypeImpl getType() {
    toTreeSitter(result) = ast.getChild(1)
  }
}