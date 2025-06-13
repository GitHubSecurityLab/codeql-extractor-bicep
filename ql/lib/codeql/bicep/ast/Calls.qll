private import AstNodes
private import Expr
private import Idents
private import Misc
private import internal.Arguments
private import internal.CallExpression
private import internal.Parameter
private import internal.Parameters
private import internal.ParameterDeclaration
private import internal.UserDefinedFunction

abstract class Callable extends Expr {
  /**
   *  Gets the identifier of the call expression.
   */
  abstract Idents getIdentifier();

  /**
   * Gets the name of the call expression.
   */
  string getName() { result = this.getIdentifier().getName() }

  /**
   * Checks if the call expression has a specific name.
   */
  predicate hasName(string name) { this.getName() = name }
}

/**
 * A CallExpression expression in the AST.
 */
class CallExpression extends Callable instanceof CallExpressionImpl {
  override Idents getIdentifier() {
    result = CallExpressionImpl.super.getIdentifier()
  }

  Expr getArgument(int index) {
    result = this.getDeclaredArguments().getArgument(index)
  }

  Expr getArguments() {
    result = this.getDeclaredArguments().getArguments()
  }

  Arguments getDeclaredArguments() {
    result = CallExpressionImpl.super.getArguments()
  }
}


/**
 *  A Arguments unknown AST node.
 */
class Arguments extends AstNode instanceof ArgumentsImpl {

  Expr getArgument(int index) {
    result = ArgumentsImpl.super.getArgument(index)
  }

  Expr getArguments() {
    result = ArgumentsImpl.super.getArguments()
  }
}

/**
 *  A Parameter unknown AST node.
 */
class Parameter extends AstNode instanceof ParameterImpl {

  Idents getName() {
    result = ParameterImpl.super.getName()
  }

  Type getType() {
    result = ParameterImpl.super.getType()
  }
}

/**
 *  A Parameters unknown AST node.
 */
class Parameters extends AstNode instanceof ParametersImpl {
  Parameter getParameter(int index) {
    result = ParametersImpl.super.getParameter(index)
  }
}


/**
 *  A ParameterDeclaration unknown AST node.
 */
class ParameterDeclaration extends AstNode instanceof ParameterDeclarationImpl { 
  Identifier getName() {
    result = ParameterDeclarationImpl.super.getName()
  }

  Type getType() {
    result = ParameterDeclarationImpl.super.getType()
  }

  Expr getDefaultValue() {
    result = ParameterDeclarationImpl.super.getDefaultValue()
  }
}

/**
 *  A UserDefinedFunction unknown AST node.
 */
class UserDefinedFunction extends AstNode instanceof UserDefinedFunctionImpl {
  Identifier getIdentifier() {
    result = UserDefinedFunctionImpl.super.getName()
  }

  string getName() {
    result = this.getIdentifier().getName()
  }

  Type getReturnType() {
    result = UserDefinedFunctionImpl.super.getReturnType()
  }

  Parameters getDeclaredParameters() {
    result = UserDefinedFunctionImpl.super.getParameters()
  }

  Parameter getParameters() {
    result = this.getDeclaredParameters().getParameter(_)
  }

  Parameter getParameter(int index) {
    result = this.getDeclaredParameters().getParameter(index)
  }

  Expr getBody() {
    result = UserDefinedFunctionImpl.super.getBody()
  }
}
