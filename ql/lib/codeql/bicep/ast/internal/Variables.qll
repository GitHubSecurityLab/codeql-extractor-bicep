private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import codeql.bicep.AST
private import codeql.bicep.CFG
private import codeql.Locations
private import Expr

/**
 * A scope in a Bicep program.
 *
 * Represents a lexical scope in Bicep, which can contain variable declarations,
 * parameters, resources, and other scoped entities. Scopes can be nested, with
 * each scope having an outer scope (except for the global scope). Scopes are
 * used to determine the visibility and lifetime of variables and other entities.
 */
class ScopeImpl extends AstNode, TScopes {
  ScopeImpl() { not this.getParent() instanceof Callable }

  ScopeImpl getOuterScope() { result = this.getParent+() }
}

/**
 * Represents a variable definition in the Bicep program.
 *
 * This class models any named entity that can be referenced elsewhere in the code,
 * including parameters, variables, outputs, and resources. It provides a unified
 * interface for accessing information about variables regardless of their specific
 * declaration type.
 */
class VariableImpl extends MkVariable {
  private AstNode node;
  private string name;

  VariableImpl() { this = MkVariable(node, name) }

  /**
   * Gets the name of this variable.
   *
   * @return The name of the variable as a string
   */
  string getName() { result = name }

  /**
   * Gets a string representation of this variable.
   *
   * @return A string in the format "Variable[name]"
   */
  string toString() { result = "Variable[" + name + "]" }

  /**
   * Gets the AST node that defines this variable.
   *
   * This could be a parameter declaration, variable declaration, resource declaration, etc.
   *
   * @return The AST node that defines this variable
   */
  AstNode getAstNode() { result = node }

  ExprImpl asExpr() { result = node }

  /**
   * Gets the source location of this variable.
   *
   * This is the location of the AST node that defines the variable.
   *
   * @return The source location of the variable definition
   */
  Location getLocation() { result = node.getLocation() }

  /**
   * Gets an access to this variable.
   *
   * This returns any usage of the variable in the code.
   *
   * @return A variable access that refers to this variable
   */
  VariableAccessImpl getAnAccess() { result.getVariable() = this }

  ScopeImpl getScope() { result = any(ScopeImpl scope | this.getAstNode().getParent+() = scope) }

  ScopeImpl getScopes() { result = any(ScopeImpl scope | this.getAstNode().getParent*() = scope) }

  /**
   * Gets the type of this variable, if it can be determined.
   *
   * This method attempts to find the type by looking at the variable's declaration,
   * either as a parameter or an output.
   *
   * @return The type of the variable, if available
   */
  Type getType() {
    result = this.getParameter().getType()
    or
    result = this.getOutput().getType()
  }

  /**
   * Gets the parameter declaration for this variable, if it is a parameter.
   *
   * @return The parameter declaration for this variable, if any
   */
  ParameterDeclaration getParameter() {
    exists(ParameterDeclaration param |
      param.getName() = this.getName() and
      param.getEnclosingCfgScope() = this.getEnclosingCfgScope() and
      result = param
    )
  }

  /**
   * Gets the output declaration for this variable, if it is an output.
   *
   * @return The output declaration for this variable, if any
   */
  OutputDeclaration getOutput() {
    exists(OutputDeclaration output |
      output.getIdentifier().getName() = this.getName() and
      output.getEnclosingCfgScope() = this.getEnclosingCfgScope() and
      result = output
    )
  }

  /**
   *  Gets the enclosing scope of this variable, if any.
   */
  CfgScope getEnclosingCfgScope() { result = node.getEnclosingCfgScope() }

  // Expr getInitializer() { }
  string getAPrimaryQlClass() { result = "Variable" }
}

/**
 * Represents an access to a variable in the code.
 *
 * This class models any usage of a variable (parameter, declared variable,
 * resource, output) within the Bicep code. It provides information about
 * where the variable is accessed and which variable is being accessed.
 */
class VariableAccessImpl extends MkVariableAccess, TVariableAccess {
  private string name;
  private AstNode node;
  private VariableImpl v;

  VariableAccessImpl() { this = MkVariableAccess(node, v, name) }

  /**
   * Gets the name of the variable being accessed.
   *
   * @return The name of the variable as a string
   */
  string getName() { result = name }

  /**
   * Gets the AST node that represents this variable access.
   *
   * This is typically an identifier node in the syntax tree.
   *
   * @return The AST node for this variable access
   */
  AstNode getAstNode() { result = node }

  /**
   * Gets the variable being accessed.
   *
   * @return The variable that this access refers to
   */
  VariableImpl getVariable() { result = v }

  /**
   * Gets a string representation of this variable access.
   *
   * @return A string in the format "VariableAccess[name]"
   */
  string toString() { result = "VariableAccess[" + name + "]" }

  /**
   * Gets the source location of this variable access.
   *
   * This is the location in the source code where the variable is referenced.
   *
   * @return The source location of the variable access
   */
  Location getLocation() { result = node.getLocation() }

  /**
   * Gets the type of the variable being accessed, if it can be determined.
   *
   * @return The type of the variable, if available
   */
  Type getType() { result = this.getVariable().getType() }

  /**
   * Gets the enclosing CFG scope of this variable access.
   *
   * This is the control flow graph scope that contains this access.
   *
   * @return The enclosing CFG scope
   */
  CfgScope getEnclosingCfgScope() { result = v.getEnclosingCfgScope() }

  ScopeImpl getScope() { result = v.getScope() }

  ScopeImpl getScopes() { result = v.getScopes() }

  /**
   * Gets the primary QL class for this AST node.
   *
   * @return The name of the QL class ("VariableAccess")
   */
  string getAPrimaryQlClass() { result = "VariableAccess" }
}

/**
 * Represents a write access to a variable.
 *
 * This class models places in the code where a variable's value is being
 * defined or assigned. This includes declarations of parameters, variables,
 * resources, and outputs.
 */
class VariableWriteAccessImpl extends VariableAccessImpl {
  VariableWriteAccessImpl() { writeAccess(this) }

  /**
   * Gets the primary QL class for this AST node.
   *
   * @return The name of the QL class ("VariableWrite")
   */
  override string getAPrimaryQlClass() { result = "VariableWrite" }
}

/**
 * Represents a read access to a variable.
 *
 * This class models places in the code where a variable's value is being
 * used but not modified. This includes using the variable in expressions,
 * passing it as an argument to functions, or referencing it in other contexts.
 */
class VariableReadAccessImpl extends VariableAccessImpl {
  VariableReadAccessImpl() { not this instanceof VariableWriteAccessImpl }

  /**
   * Gets the primary QL class for this AST node.
   *
   * @return The name of the QL class ("VariableRead")
   */
  override string getAPrimaryQlClass() { result = "VariableRead" }
}

/**
 * Implements all of the Variable declarations for a Bicep project
 */
private predicate decl(AstNode node, string name) {
  exists(ParameterDeclaration param |
    param.getName() = name and
    node = param
  )
  or
  exists(VariableDeclaration vardelc |
    vardelc.getIdentifier().getName() = name and
    node = vardelc
  )
  or
  exists(Resource resource |
    resource.getIdentifier().getName() = name and
    node = resource.getResourceDeclaration()
  )
  or
  exists(OutputDeclaration output |
    output.getIdentifier().getName() = name and
    node = output
  )
}

/**
 * Implements all of the Variable access (reads / writes) for a Bicep project
 */
private predicate access(AstNode node, VariableImpl v, string name) {
  exists(Identifier ident |
    ident.getName() = name and
    // Make sure they are not in a declare statement
    not ident.getParent() instanceof VariableDeclaration and
    // not ident.getParent() instanceof ParameterDeclaration and
    // not ident.getParent() instanceof OutputDeclaration and
    // Make sure they are in the same scope
    ident.getName() = v.getName() and
    ident.getEnclosingCfgScope() = v.getEnclosingCfgScope() and
    ident = node
  )
}

/**
 * Holds if the variable is written too.
 */
private predicate write(VariableAccessImpl node) {
  // Parameter
  node.getAstNode().getParent() instanceof ParameterDeclaration
  or
  // SET
  node.getAstNode().getParent() instanceof VariableDeclaration
  or
  node.getAstNode().getParent() instanceof ResourceDeclaration
  or
  // Output
  node.getAstNode().getParent() instanceof OutputDeclaration
}

cached
private module Cached {
  cached
  newtype TVariable =
    TResource(Resource resource, string name) { resource.getIdentifier().getName() = name } or
    TVariableDecl(VariableDeclaration varDecl, string name) {
      varDecl.getIdentifier().getName() = name
    } or
    TParameterDecl(ParameterDeclaration param, string name) { param.getName() = name } or
    TOutput(OutputDeclaration output, string name) { output.getIdentifier().getName() = name } or
    MkVariable(AstNode definingNode, string name) { variableDecl(definingNode, name) }

  cached
  newtype TVariableAccess =
    TIdent(Identifier ident, string name) { ident.getName() = name } or
    MkVariableAccess(AstNode node, VariableImpl v, string name) { variableAccess(node, v, name) }

  cached
  predicate variableDecl(AstNode node, string name) { decl(node, name) }

  cached
  predicate variableAccess(AstNode node, VariableImpl v, string name) { access(node, v, name) }

  cached
  predicate writeAccess(VariableAccessImpl node) { write(node) }
}

private import Cached
