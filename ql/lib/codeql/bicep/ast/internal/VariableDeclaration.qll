/**
 *  Internal implementation for VariableDeclaration
 *
 *  WARNING: this file is generated, do not edit manually
 */

private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Stmts
private import Idents
private import Expr

/**
 *  A VariableDeclaration AST Node.
 */
class VariableDeclarationImpl extends TVariableDeclaration, StmtsImpl {
  private BICEP::VariableDeclaration ast;

  override string getAPrimaryQlClass() { result = "VariableDeclaration" }

  VariableDeclarationImpl() { this = TVariableDeclaration(ast) }

  override string toString() { result = ast.toString() }

  IdentsImpl getIdentifier() { toTreeSitter(result) = ast.getChild(0) }

  ExprImpl getInitializer() { toTreeSitter(result) = ast.getChild(1) }
}
