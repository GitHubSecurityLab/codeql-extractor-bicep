
/**
 * Conditional statements.
 */
private import codeql.bicep.ast.AstNodes
private import AstNodes
private import TreeSitter
private import Expr
private import Stmts
// Re-exports
import ForStatement

/**
 * Conditional statements.
 */
class ConditionalsImpl extends StmtsImpl, TConditionals {
  override string getAPrimaryQlClass() { result = "Conditional" }

  abstract ExprImpl getCondition();

  abstract StmtSequenceImpl getBranch();
}