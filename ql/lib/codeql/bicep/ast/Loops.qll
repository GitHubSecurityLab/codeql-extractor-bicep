private import AstNodes
private import Expr
private import Idents
private import Stmts
private import internal.Loops
private import internal.ForStatement

class Loops extends Stmts instanceof LoopsImpl {
  /**
   * Gets the condition expression of the loop.
   *
   * This is the expression that determines whether the loop continues executing.
   * For while and for loops, this is the explicit condition expression.
   * For do-while loops, this is the condition evaluated after each iteration.
   * For foreach loops, this represents an implicit condition checking if there are more elements.
   */
  abstract Expr getCondition();

  /**
   * Gets the body of the loop.
   *
   * The body contains the statements that are executed in each iteration of the loop.
   * In the CFG, control typically flows back from the end of the body to the loop condition
   * or to the update expression (in for loops).
   */
  abstract Stmts getBody();

  /**
   * Gets the initializer of the loop, if any.
   *
   * For for loops, this includes the variables initialized before the loop starts.
   * For foreach loops, this includes the key and value variables declared for iteration.
   * Other loop types may not have initializers.
   */
  abstract Idents getInitializer();
}

/**
 * A for statement in Bicep.
 *
 * In Bicep, for loops are used to iterate over arrays, integer ranges, or object properties.
 * They can be used to create multiple instances of resources, modules, variables, or properties.
 *
 * Example:
 * ```bicep
 * // Creating multiple storage accounts using a for loop with range
 * resource storageAcct 'Microsoft.Storage/storageAccounts@2023-05-01' = [for i in range(0, storageCount): {
 *   name: '${i}storage${uniqueString(resourceGroup().id)}'
 *   location: location
 *   sku: {
 *     name: 'Standard_LRS'
 *   }
 *   kind: 'Storage'
 * }]
 * ```
 */
class ForStatement extends Loops instanceof ForStatementImpl {
  /** Gets the condition expression of this for loop. */
  override Expr getCondition() {
    result = ForStatementImpl.super.getCondition()
  }

  /** Gets the body of this for loop. */
  override Stmts getBody() {
    result = ForStatementImpl.super.getBody()
  }

  /** Gets the initializer of this for loop. */
  override Idents getInitializer() {
    result = ForStatementImpl.super.getInitializer()
  }
}
