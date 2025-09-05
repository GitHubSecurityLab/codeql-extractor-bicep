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
 * Represents a variable definition in the Bicep program.
 * 
 * This class models any named entity that can be referenced elsewhere in the code,
 * including parameters, variables, outputs, and resources. It provides a unified
 * interface for accessing information about variables regardless of their specific
 * declaration type.
 */
class Variable extends MkVariable {
  private AstNode node;
  private string name;

  Variable() { this = MkVariable(node, name) }

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
  VariableAccess getAnAccess() { result.getVariable() = this }

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
 * Represents an access to a variable in the code.
 * 
 * This class models any usage of a variable (parameter, declared variable, 
 * resource, output) within the Bicep code. It provides information about
 * where the variable is accessed and which variable is being accessed.
 */
class VariableAccess extends MkVariableAccess, TVariableAccess {
  private string name;
  private AstNode node;
  private Variable v;

  VariableAccess() { this = MkVariableAccess(node, v, name) }

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
  Variable getVariable() { result = v }

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
class VariableWriteAccess extends VariableAccess {
  VariableWriteAccess() {
    // Parameter
    this.getAstNode().getParent() instanceof ParameterDeclaration
    or
    // SET
    this.getAstNode().getParent() instanceof VariableDeclaration
    or
    this.getAstNode().getParent() instanceof ResourceDeclaration
    or
    // Output
    this.getAstNode().getParent() instanceof OutputDeclaration
  }

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
class VariableReadAccess extends VariableAccess {
  VariableReadAccess() { not this instanceof VariableWriteAccess }

  /**
   * Gets the primary QL class for this AST node.
   * 
   * @return The name of the QL class ("VariableRead")
   */
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
    TResource(Resource resource, string name) { resource.getIdentifier().getName() = name } or
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
