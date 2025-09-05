/**
 *  Bicep variable declarations.
 */

private import bicep
private import AstNodes
private import Calls
private import Idents
private import Stmts
private import internal.Variables
private import codeql.bicep.controlflow.BasicBlocks as BasicBlocks
private import codeql.bicep.controlflow.ControlFlowGraph
// Internal
private import internal.VariableDeclaration

/**
 * Represents a variable declaration in the AST.
 *
 * This class models a variable declaration in Bicep, which associates a name
 * with a value. Variable declarations allow storing and reusing values throughout
 * a template, making the template more readable and maintainable. They can refer
 * to literals, expressions, or other variables and resources.
 */
class VariableDeclaration extends AstNode instanceof VariableDeclarationImpl {
  /**
   * Gets the identifier of the variable declaration.
   *
   * This is the name token of the variable as it appears in the source code.
   *
   * @return The identifier node of the variable
   */
  Idents getIdentifier() { result = VariableDeclarationImpl.super.getIdentifier() }

  /**
   * Gets the initializer expression of the variable declaration.
   *
   * This is the expression that provides the value for the variable.
   * It could be a literal, a reference to another variable, a complex
   * expression, or any other expression that produces a value.
   *
   * @return The initializer expression of the variable
   */
  Expr getInitializer() { result = VariableDeclarationImpl.super.getInitializer() }
}

class Scope extends AstNode instanceof ScopeImpl {
  override string getAPrimaryQlClass() { result = "Scope" }

  /**
   * Gets the name of this scope.
   */
  string getName() { result = this.getAPrimaryQlClass() }

  /**
   * Gets the enclosing scope, if any.
   */
  Scope getOuterScope() { result = super.getOuterScope() }

  /**
   * Gets a variable declared in this scope.
   */
  Variable getVariables() { exists(Variable v | v.getScope() = this | result = v) }

  /**
   * Gets a callable (function or method) declared in this scope.
   */
  Callable getCallables() { exists(Callable c | c.getScope() = this | result = c) }

  /**
   * Gets a variable with the given name in this scope.
   */
  Variable getVariable(string name) {
    exists(Variable v | v.getName() = name and v.getScope() = this | result = v)
  }
}

class Variable instanceof VariableImpl {
  /**
   * Gets the name of this variable.
   */
  string getName() { result = super.getName() }

  string toString() { result = "Variable[" + this.getName() + "]" }

  /**
   * Gets the AST node corresponding to this variable.
   */
  final AstNode getAstNode() { result = super.getAstNode() }

  /**
   * Gets the location of this variable in the source code.
   */
  Location getLocation() { result = super.getLocation() }

  /**
   * Gets this variable as an expression, if it can be represented as one.
   */
  Expr asExpr() { result = super.asExpr() }

  /**
   * Gets an access to this variable in the program.
   */
  VariableAccess getAnAccess() { result.getVariable() = this }

  /**
   * Gets the type of this variable, if any.
   */
  Type getType() { result = super.getType() }

  /**
   * Gets the parameter associated with this variable, if it represents a function parameter.
   */
  ParameterDeclaration getParameter() { result = super.getParameter() }

  /**
   * Gets the control flow scope containing this variable.
   */
  CfgScope getCfgScope() { result = this.getAstNode().getEnclosingCfgScope() }

  /**
   * Gets the scope containing this variable.
   */
  Scope getScope() { result = super.getScope() }

  /**
   * Gets the parent scopes
   */
  Scope getScopes() { result = super.getScopes() }

  string getAPrimaryQlClass() { result = "Variable" }

  /**
   * Holds if this variable is captured by a closure or similar construct.
   * A variable is captured when it's accessed in a scope different from its definition scope.
   */
  final predicate isCaptured() { this.getAnAccess().isCapturedAccess() }
}

class VariableAccess instanceof VariableAccessImpl {
  /**
   * Gets the name of the accessed variable.
   */
  string getName() { result = super.getName() }

  /**
   * Gets the AST node corresponding to this variable access.
   */
  final AstNode getAstNode() { result = super.getAstNode() }

  /**
   * Gets the variable being accessed.
   */
  Variable getVariable() { result = super.getVariable() }

  string toString() { result = "VariableAccess[" + this.getName() + "]" }

  /**
   * Gets the location of this variable access in the source code.
   */
  Location getLocation() { result = super.getLocation() }

  /**
   * Gets this variable access as an expression.
   */
  Expr asExpr() { result = this.getAstNode() }

  /**
   * Gets the type of the accessed variable, if any.
   */
  Type getType() {
    // Get type from the variable itself
    result = this.getVariable().getType()
  }

  /**
   * Gets the control flow scope containing this variable access.
   */
  CfgScope getCfgScope() { result = super.getAstNode().getEnclosingCfgScope() }

  /**
   * Gets the scope containing this variable access.
   */
  Scope getScope() { result = super.getScope() }

  Scope getScopes() { result = super.getScopes() }

  /**
   * Holds if this access captures a variable from an outer scope.
   *
   * An access captures a variable when it occurs in a scope different
   * from the variable's definition scope.
   */
  final predicate isCapturedAccess() {
    exists(Scope scope1, CfgScope scope2 |
      scope1 = this.getVariable().getScopes() and
      scope2 = this.getCfgScope() and
      scope1 != scope2
    )
  }

  /**
   * Gets the primary QL class for this AST node.
   *
   * @return The name of the QL class ("VariableAccess")
   */
  string getAPrimaryQlClass() { result = "VariableAccess" }
}

class VariableWriteAccess extends VariableAccess instanceof VariableWriteAccessImpl {
  override string getAPrimaryQlClass() { result = "VariableWrite" }

  override string toString() { result = "VariableWrite[" + this.getName() + "]" }

  /**
   * Gets this variable write access as an expression.
   */
  override Expr asExpr() { result = this.getAstNode() }
}

class VariableReadAccess extends VariableAccess instanceof VariableReadAccessImpl {
  VariableReadAccess() { not this instanceof VariableWriteAccess }

  /**
   * Gets the primary QL class for this AST node.
   *
   * @return The name of the QL class ("VariableRead")
   */
  override string getAPrimaryQlClass() { result = "VariableRead" }

  override string toString() { result = "VariableRead[" + this.getName() + "]" }

  /**
   * Gets this variable read access as an expression.
   */
  override Expr asExpr() { result = this.getAstNode() }
}
