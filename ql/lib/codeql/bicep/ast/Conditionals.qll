/**
 * Loop statements are not supported in `bicep` code.
 */

private import Expr
private import Stmts
private import internal.Conditionals


 class Conditionals extends Stmts instanceof ConditionalsImpl {
  /**
   * Gets the condition expression of this conditional statement, if any.
   *
   * For if/elseif statements, this is the boolean expression in parentheses.
   * For switch statements, this is the expression being switched on.
   * For else clauses and default cases, this returns no result as they have no condition.
   */
  Expr getCondition() { result = ConditionalsImpl.super.getCondition() }

  /**
   * Gets the branch (statement sequence) executed when this conditional is satisfied.
   *
   * This represents the code that runs when the condition is true or when
   * this branch is selected in a switch/match statement.
   */
  StmtSequence getBranch() { result = ConditionalsImpl.super.getBranch() }
}