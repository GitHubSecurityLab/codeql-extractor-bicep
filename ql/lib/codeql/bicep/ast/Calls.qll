private import AstNodes
private import Expr
private import Idents
private import Misc
private import internal.Arguments
private import internal.CallExpression
private import internal.Parameter
private import internal.Parameters
private import internal.ParameterDeclaration
private import internal.OutputDeclaration
private import internal.UserDefinedFunction

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

/**
 * Represents a parameter node in the AST.
 * Provides access to the parameter's name and type.
 */
class Parameter extends AstNode instanceof ParameterImpl {
  /** Gets the name of the parameter. */
  Idents getName() { result = ParameterImpl.super.getName() }

  /** Gets the type of the parameter. */
  Type getType() { result = ParameterImpl.super.getType() }
}

/**
 * Represents a parameters node in the AST.
 * Provides access to individual parameters by index.
 */
class Parameters extends AstNode instanceof ParametersImpl {
  /** Gets the parameter at the specified index. */
  Parameter getParameter(int index) { result = ParametersImpl.super.getParameter(index) }
}

/**
 * Represents a parameter declaration node in the AST.
 * Provides access to the identifier, name, type, and default value of the parameter.
 */
class ParameterDeclaration extends AstNode instanceof ParameterDeclarationImpl {
  /** Gets the identifier of the parameter declaration. */
  Identifier getIdentifier() { result = ParameterDeclarationImpl.super.getName() }

  /** Gets the name of the parameter declaration. */
  string getName() { result = this.getIdentifier().getName() }

  /** Gets the type of the parameter declaration. */
  Type getType() { result = ParameterDeclarationImpl.super.getType() }

  /** Gets the default value of the parameter declaration, if any. */
  Expr getDefaultValue() { result = ParameterDeclarationImpl.super.getDefaultValue() }
}

/**
 * Represents an output declaration node in the AST.
 * Provides access to the identifier, name, type, and value of the output.
 */
class OutputDeclaration extends AstNode instanceof OutputDeclarationImpl {
  /** Gets the identifier of the output declaration. */
  Identifier getIdentifier() { result = OutputDeclarationImpl.super.getIdentifier() }

  /** Gets the name of the output declaration. */
  string getName() { result = this.getIdentifier().getName() }

  /** Gets the type of the output declaration. */
  Type getType() { result = OutputDeclarationImpl.super.getType() }

  /** Gets the value of the output declaration. */
  Expr getValue() { result = OutputDeclarationImpl.super.getValue() }
}

/**
 * Represents a user-defined function node in the AST.
 * Provides access to the identifier, name, return type, parameters, and body of the function.
 */
class UserDefinedFunction extends AstNode instanceof UserDefinedFunctionImpl {
  /** Gets the identifier of the user-defined function. */
  Identifier getIdentifier() { result = UserDefinedFunctionImpl.super.getName() }

  /** Gets the name of the user-defined function. */
  string getName() { result = this.getIdentifier().getName() }

  /** Gets the return type of the user-defined function. */
  Type getReturnType() { result = UserDefinedFunctionImpl.super.getReturnType() }

  /** Gets the declared parameters of the user-defined function. */
  Parameters getDeclaredParameters() { result = UserDefinedFunctionImpl.super.getParameters() }

  /** Gets all parameters of the user-defined function. */
  Parameter getParameters() { result = this.getDeclaredParameters().getParameter(_) }

  /** Gets the parameter at the specified index. */
  Parameter getParameter(int index) { result = this.getDeclaredParameters().getParameter(index) }

  /** Gets the body of the user-defined function. */
  Expr getBody() { result = UserDefinedFunctionImpl.super.getBody() }
}
