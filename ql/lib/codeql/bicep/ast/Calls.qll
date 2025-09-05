private import AstNodes
private import Expr
private import Idents
private import Misc
private import internal.Arguments
private import internal.CallExpression

/**
 * Represents a callable expression in the AST, such as a function or method call.
 * 
 * This abstract class serves as the base for any expression that represents
 * a call to a function or method. It provides common functionality for accessing
 * the name and identifier of the called entity.
 */
abstract class Callable extends Expr {
  /**
   * Gets the identifier of the callable expression.
   * 
   * This is the name token that identifies what function or method is being called.
   * 
   * @return The identifier node of the callable
   */
  abstract Idents getIdentifier();

  /**
   * Gets the name of the callable expression as a string.
   * 
   * This is a convenience method that returns the name from the identifier.
   *
   * @return The name of the callable
   */
  string getName() { result = this.getIdentifier().getName() }

  /**
   * Checks if the callable expression has a specific name.
   * 
   * This is useful for identifying calls to known functions by name.
   *
   * @param name The name to check against
   * @return True if the callable has the given name, false otherwise
   */
  predicate hasName(string name) { this.getName() = name }
}

/**
 * Represents a function or method call expression in the AST.
 * 
 * This class models a function call in Bicep, consisting of an identifier
 * (the function name) followed by arguments in parentheses. Function calls
 * invoke functions defined in the language, user-defined functions, or
 * module functions to compute values or perform operations.
 */
class CallExpression extends Expr instanceof CallExpressionImpl {
  /** 
   * Gets the identifier of the call expression.
   * 
   * This is the name token that identifies what function is being called.
   * 
   * @return The identifier node of the function being called
   */
  Idents getIdentifier() { result = CallExpressionImpl.super.getIdentifier() }

  /** 
   * Gets the name of the call expression as a string.
   * 
   * This is a convenience method that returns the name from the identifier.
   * 
   * @return The name of the function being called
   */
  string getName() { result = this.getIdentifier().getName() }

  /** 
   * Gets the argument at the specified index.
   * 
   * @param index The zero-based index of the argument to retrieve
   * @return The expression node of the argument at the specified index
   */
  Expr getArgument(int index) { result = this.getDeclaredArguments().getArgument(index) }

  /** 
   * Gets all arguments of the call expression.
   * 
   * @return All argument expressions passed to the function
   */
  Expr getArguments() { result = this.getDeclaredArguments().getArguments() }

  /** 
   * Gets the arguments collection node of the call expression.
   * 
   * This provides access to the AST node that contains all the arguments.
   * 
   * @return The arguments node of the call expression
   */
  Arguments getDeclaredArguments() { result = CallExpressionImpl.super.getArguments() }
}

/**
 * Represents a collection of arguments in a function call.
 * 
 * This class models the set of arguments passed to a function, allowing
 * access to individual arguments by index or to the complete set of arguments.
 */
class Arguments extends AstNode instanceof ArgumentsImpl {
  /** 
   * Gets the argument at the specified index.
   * 
   * @param index The zero-based index of the argument to retrieve
   * @return The expression node of the argument at the specified index
   */
  Expr getArgument(int index) { result = ArgumentsImpl.super.getArgument(index) }

  /** 
   * Gets all arguments in the collection.
   * 
   * @return All argument expressions in this arguments collection
   */
  Expr getArguments() { result = ArgumentsImpl.super.getArguments() }
}
