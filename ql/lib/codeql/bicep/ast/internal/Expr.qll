private import codeql.bicep.ast.AstNodes
private import AstNodes
private import TreeSitter
private import Stmts

/**
 * A Bicep expression.
 */
class ExprImpl extends StmtsImpl, TExpr {
  override string getAPrimaryQlClass() { result = "Expr" }
}
