/**
 *  Bicep variable declarations.
 */

private import bicep
private import AstNodes
private import Calls
private import Idents
private import Stmts
private import codeql.bicep.controlflow.BasicBlocks as BasicBlocks
private import codeql.bicep.controlflow.ControlFlowGraph
// Internal
private import internal.VariableDeclaration

/**
 *  A VariableDeclaration unknown AST node.
 */
class VariableDeclaration extends AstNode instanceof VariableDeclarationImpl {
  /**
   * Gets the identifier of the variable declaration.
   */
  Idents getIdentifier() { result = VariableDeclarationImpl.super.getIdentifier() }

  /**
   * Gets the initializer expression of the variable declaration.
   */
  Expr getInitializer() { result = VariableDeclarationImpl.super.getInitializer() }
}

private predicate variableDecl(AstNode node, string name) {
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
  exists(OutputDeclaration output |
    output.getIdentifier().getName() = name and
    node = output
  )
}

/**
 * Variable represents a variable defination.
 */
class Variable extends MkVariable {
  private AstNode node;
  private string name;

  Variable() { this = MkVariable(node, name) }

  string getName() { result = name }

  string toString() { result = "Variable[" + name + "]" }

  AstNode getAstNode() { result = node }

  /**
   *  Get the location of this variable.
   */
  Location getLocation() { result = node.getLocation() }

  /**
   * Geta the inner variable of this variable.
   */
  VariableAccess getAnAccess() { result.getVariable() = this }

  /**
   *  Gets the type of this variable, if any.
   */
  Type getType() {
    result = this.getParameter().getType()
    or
    result = this.getOutput().getType() 
  }
  
  /**
   * Gets the parameter of this variable, if any.
   */
  ParameterDeclaration getParameter() {
    exists(ParameterDeclaration param |
      param.getName() = this.getName() and
      param.getEnclosingCfgScope() = this.getEnclosingCfgScope() and
      result = param
    )
  }

  /**
   * Gets the variable declaration of this variable, if any.
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

private predicate access(AstNode node, Variable v, string name) {
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
 *  VariableAccess is a class that represents the access to a variable.
 */
class VariableAccess extends MkVariableAccess, TVariableAccess {
  private string name;
  private AstNode node;
  private Variable v;

  VariableAccess() { this = MkVariableAccess(node, v, name) }

  string getName() { result = name }

  AstNode getAstNode() { result = node }

  Variable getVariable() { result = v }

  string toString() { result = "VariableAccess[" + name + "]" }

  /**
   *  Get the location of this variable.
   */
  Location getLocation() { result = node.getLocation() }

  /**
   *  Gets the type of this variable, if any.
   */
  Type getType() { result = this.getVariable().getType() }

  /**
   *  Gets the enclosing scope of this variable, if any.
   */
  CfgScope getEnclosingCfgScope() { result = v.getEnclosingCfgScope() }

  string getAPrimaryQlClass() { result = "VariableAccess" }
}

class VariableWriteAccess extends VariableAccess {
  VariableWriteAccess() {
    // Parameter
    this.getAstNode().getParent() instanceof ParameterDeclaration
    or
    // SET
    this.getAstNode().getParent() instanceof VariableDeclaration
    or
    // Output
    this.getAstNode().getParent() instanceof OutputDeclaration
  }

  override string getAPrimaryQlClass() { result = "VariableWrite" }
}

class VariableReadAccess extends VariableAccess {
  VariableReadAccess() { not this instanceof VariableWriteAccess }

  override string getAPrimaryQlClass() { result = "VariableRead" }
}

/**
 * Holds if the variable is written too.
 */
// private predicate variableWrite(Variable node) {
//   exists(Parameter param |
//     param.getName() = node.getName() and
//     param.getEnclosingCfgScope() = node.getEnclosingCfgScope()
//   )
// }
cached
private module Cached {
  cached
  newtype TVariable =
    TResource(Resource resource, string name) { resource.getName() = name } or
    TVariableDecl(VariableDeclaration varDecl, string name) {
      varDecl.getIdentifier().getName() = name
    } or
    TParameter(ParameterDeclaration param, string name) { param.getName() = name } or
    TOutput(OutputDeclaration output, string name) { output.getIdentifier().getName() = name } or
    MkVariable(AstNode definingNode, string name) { variableDecl(definingNode, name) }

  cached
  newtype TVariableAccess =
    TIdent(Identifier ident, string name) { ident.getName() = name } or
    MkVariableAccess(AstNode node, Variable v, string name) { variableAccess(node, v, name) }

  cached
  predicate variableAccess(AstNode node, Variable v, string name) { access(node, v, name) }
}

private import Cached
