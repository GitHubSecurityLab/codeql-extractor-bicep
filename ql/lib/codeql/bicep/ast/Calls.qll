private import AstNodes
private import Expr
private import Idents
private import internal.Arguments
private import internal.CallExpression
private import internal.Parameter
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
    result = this.getArguments().getArgument(index)
  }

  Arguments getArguments() {
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
class Parameter extends AstNode instanceof ParameterImpl { }

/**
 *  A ParameterDeclaration unknown AST node.
 */
class ParameterDeclaration extends AstNode instanceof ParameterDeclarationImpl { }

/**
 *  A UserDefinedFunction unknown AST node.
 */
class UserDefinedFunction extends AstNode instanceof UserDefinedFunctionImpl { }
