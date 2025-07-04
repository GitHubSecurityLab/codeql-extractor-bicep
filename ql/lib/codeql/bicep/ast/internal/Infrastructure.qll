/**
 *  Internal implementation for Infrastructure
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Stmts
private import Statement


/**
 *  A Infrastructure AST Node.
 */
class InfrastructureImpl extends TInfrastructure, AstNode {
  private BICEP::Infrastructure ast;

  override string getAPrimaryQlClass() { result = "Infrastructure" }

  InfrastructureImpl() { this = TInfrastructure(ast) }

  override string toString() { result = ast.toString() }

  StatementImpl getStatement(int index) {
    toTreeSitter(result) = ast.getChild(index)
  }
}