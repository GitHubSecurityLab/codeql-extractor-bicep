/**
 *  Internal implementation for Arguments
 */

private import AstNodes
private import TreeSitter
private import Expr

/**
 *  A Arguments AST Node representing a collection of function call arguments.
 */
class ArgumentsImpl extends TArguments, ExprImpl {
  private BICEP::Arguments ast;

  override string getAPrimaryQlClass() { result = "Arguments" }

  ArgumentsImpl() { this = TArguments(ast) }

  override string toString() { result = ast.toString() }

  /**
   * Gets the argument at the specified index.
   */
  ExprImpl getArgument(int index) { toTreeSitter(result) = ast.getChild(index) }

  ExprImpl getArgumentByName(string name) { none() }

  /**
   * Gets all arguments in the collection.
   */
  ExprImpl getArguments() { toTreeSitter(result) = ast.getChild(_) }

  int getNumberOfArguments() { result = count(int i | exists(this.getArgument(i))) }
}
