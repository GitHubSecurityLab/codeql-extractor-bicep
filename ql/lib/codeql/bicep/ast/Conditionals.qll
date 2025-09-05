/**
 * Loop statements are not supported in `bicep` code.
 */

private import Expr
private import Stmts
private import internal.Conditionals
private import internal.IfStatement


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


/**
 * An if statement in the AST.
 * 
 * Represents a conditional statement in Bicep that executes certain code
 * only when a specific condition is true. If statements enable conditional
 * resource creation or property setting based on input parameters or other factors.
 */
class IfStatement extends Stmts instanceof IfStatementImpl { 
  /** 
   * Gets the condition of the if statement.
   * 
   * This is the expression that is evaluated to determine whether
   * the body of the if statement should be executed.
   * 
   * @return The condition expression
   */
  Expr getCondition() { result = IfStatementImpl.super.getCondition() }

  /** 
   * Gets the body of the if statement.
   * 
   * This is the expression or block that will be executed if the
   * condition evaluates to true.
   * 
   * @return The body expression
   */
  Expr getBody() { result = IfStatementImpl.super.getBody() }
}