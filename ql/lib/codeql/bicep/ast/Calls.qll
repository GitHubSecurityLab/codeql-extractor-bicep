private import AstNodes
private import Expr
private import Idents
private import Misc
private import internal.Arguments
private import internal.CallExpression

/**
 * Represents a callable expression in the AST, such as a function or method call.
 * Provides access to the identifier and name of the call expression.
 */
abstract class Callable extends Expr {
  /**
   *  Gets the identifier of the call expression.
   */
  abstract Idents getIdentifier();

  /**
   * Gets the name of the call expression.
   *
   * @return The name as a string.
   */
  string getName() { result = this.getIdentifier().getName() }

  /**
   * Checks if the call expression has a specific name.
   *
   * @param name The name to check against.
   * @return True if the call expression has the given name.
   */
  predicate hasName(string name) { this.getName() = name }
}

/**
 * Represents a call expression node in the AST.
 * Provides access to the identifier, arguments, and declared arguments.
 */
class CallExpression extends Expr instanceof CallExpressionImpl {
  /** Gets the identifier of the call expression. */
  Idents getIdentifier() { result = CallExpressionImpl.super.getIdentifier() }

  /** Gets the name of the call expression. */
  string getName() { result = this.getIdentifier().getName() }

  /** Gets the argument at the specified index. */
  Expr getArgument(int index) { result = this.getDeclaredArguments().getArgument(index) }

  /** Gets all arguments of the call expression. */
  Expr getArguments() { result = this.getDeclaredArguments().getArguments() }

  /** Gets the declared arguments node. */
  Arguments getDeclaredArguments() { result = CallExpressionImpl.super.getArguments() }
}

/**
 * Represents the arguments node in the AST.
 * Provides access to individual and all arguments.
 */
class Arguments extends AstNode instanceof ArgumentsImpl {
  /** Gets the argument at the specified index. */
  Expr getArgument(int index) { result = ArgumentsImpl.super.getArgument(index) }

  /** Gets all arguments. */
  Expr getArguments() { result = ArgumentsImpl.super.getArguments() }
}
