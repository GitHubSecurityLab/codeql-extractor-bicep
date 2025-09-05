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
class InfrastructureImpl extends TInfrastructure, StmtSequenceImpl {
  private BICEP::Infrastructure ast;

  override string getAPrimaryQlClass() { result = "Infrastructure" }

  InfrastructureImpl() { this = TInfrastructure(ast) }

  override string toString() { result = ast.toString() }

  override StmtsImpl getStmt(int index) { result = this.getStatement(index) }

  override StmtsImpl getStmts() { result = this.getStatement(_) }

  StatementImpl getStatement(int index) { toTreeSitter(result) = ast.getChild(index) }
}
