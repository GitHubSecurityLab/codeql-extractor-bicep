/**
 * Statement nodes in the AST.
 */

private import AstNodes
private import Idents
private import Expr
private import Calls
private import Misc
private import internal.AstNodes
private import internal.TreeSitter
private import internal.Stmts
private import internal.AssertStatement
private import internal.ForStatement
private import internal.IfStatement
private import internal.ImportStatement
private import internal.ImportWithStatement
private import internal.Infrastructure
private import internal.UsingStatement
private import internal.Parameter
private import internal.Parameters
private import internal.ParameterDeclaration
private import internal.OutputDeclaration
private import internal.UserDefinedFunction
// CFG
private import codeql.bicep.CFG
private import codeql.bicep.controlflow.internal.ControlFlowGraphImpl as CfgImpl

/**
 * The base class for all statements in the AST.
 * 
 * This class represents all types of statements in Bicep, including
 * declarations, control flow statements, and other top-level constructs.
 * Statements are the primary building blocks of Bicep programs.
 */
class Stmts extends AstNode instanceof StmtsImpl {
  /** 
   * Gets a control-flow node for this statement, if any.
   * 
   * Control-flow nodes represent this statement in the control-flow graph,
   * which models the flow of execution through the program.
   * 
   * @return A control-flow node for this statement
   */
  CfgImpl::AstCfgNode getAControlFlowNode() { result.getAstNode() = this }

  /** 
   * Gets a control-flow entry node for this statement, if any.
   * 
   * Entry nodes represent the point where execution enters this statement
   * in the control-flow graph.
   * 
   * @return A control-flow entry node for this statement
   */
  AstNode getAControlFlowEntryNode() { result = CfgImpl::getAControlFlowEntryNode(this) }
}

/**
 * A sequence of statements in the PHP AST.
 *
 * This represents a list of statements that appear together in sequence.
 */
class StmtSequence extends AstNode instanceof StmtSequenceImpl {
  /**
   * Gets all statements in this sequence.
   */
  Stmts getStmts() { none() }

  /**
   * Gets the statement at the specified index within this sequence.
   */
  Stmts getStmt(int index) { none() }

  /**
   * Get all callables defined in this program.
   */
  Callable getCallables() {
    result = this.getStmts()
  }

  /**
   * Get a callable by its name.
   */
  Callable getCallable(string name) {
    exists(Callable c | c = this.getCallables() and c.getName() = name | result = c)
  }

  /**
   * Gets the number of statements in this sequence.
   */
  int getNumberOfStatements() { result = count(int i | exists(this.getStmt(i))) }

  /**
   * Gets the last statement of the sequence
   */
  Stmts getLastStmt() { result = this.getStmt(this.getNumberOfStatements() - 1) }
}

/**
 * An assert statement in the AST.
 * 
 * Represents an assertion in Bicep, which checks a condition at runtime
 * and raises an error if the condition is false. Assert statements are
 * useful for validating assumptions and ensuring inputs meet expected criteria.
 */
final class AssertStatementStmt extends Stmts instanceof AssertStatementImpl { }

/**
 * A for statement in the AST.
 * 
 * Represents a for loop in Bicep, which iterates over a collection of items.
 * For loops are commonly used for creating multiple instances of resources
 * or for processing arrays of configuration data.
 */
final class ForStatementStmt extends Stmts instanceof ForStatementImpl { }

/**
 * An if statement in the AST.
 * 
 * Represents a conditional statement in Bicep that executes certain code
 * only when a specific condition is true. If statements enable conditional
 * resource creation or property setting based on input parameters or other factors.
 */
class IfStatement extends Stmts instanceof IfStatementImpl { 
  /** 
   * Gets the condition of the if statement.
   * 
   * This is the expression that is evaluated to determine whether
   * the body of the if statement should be executed.
   * 
   * @return The condition expression
   */
  Expr getCondition() { result = IfStatementImpl.super.getCondition() }

  /** 
   * Gets the body of the if statement.
   * 
   * This is the expression or block that will be executed if the
   * condition evaluates to true.
   * 
   * @return The body expression
   */
  Expr getBody() { result = IfStatementImpl.super.getBody() }
}

/**
 * An import statement in the AST.
 * 
 * Represents an import statement in Bicep, which brings external modules,
 * namespaces, or resources into the current scope. Import statements enable
 * code reuse and modularization of Bicep templates.
 */
final class ImportStatementStmt extends Stmts instanceof ImportStatementImpl { }

/**
 * An infrastructure node in the AST.
 * 
 * Represents the root node of a Bicep file, which contains all the top-level
 * statements and declarations that define the infrastructure to be deployed.
 * This is essentially the entry point of a Bicep program.
 */
class Infrastructure extends StmtSequence instanceof InfrastructureImpl {
  override Stmts getStmts() { result = InfrastructureImpl.super.getStmts() }

  override Stmts getStmt(int index) { result = InfrastructureImpl.super.getStmt(index) }
}

/**
 * Represents a parameter declaration node in the AST.
 * 
 * Parameters in Bicep are used to accept input values when deploying the template.
 * They enable customization of deployments without modifying the template code.
 * A parameter declaration includes a name, a type, and optionally a default value
 * and/or allowed values.
 */
class ParameterDeclaration extends Stmts instanceof ParameterDeclarationImpl {
  /** 
   * Gets the identifier of the parameter declaration.
   * 
   * This is the name token of the parameter as it appears in the source code.
   * 
   * @return The identifier node of the parameter
   */
  Identifier getIdentifier() { result = ParameterDeclarationImpl.super.getName() }

  /** 
   * Gets the name of the parameter declaration as a string.
   * 
   * This is a convenience method that returns the name from the identifier.
   * 
   * @return The name of the parameter
   */
  string getName() { result = this.getIdentifier().getName() }

  /** 
   * Gets the type of the parameter declaration.
   * 
   * This specifies what kind of values are allowed for this parameter,
   * such as 'string', 'int', 'bool', or more complex types.
   * 
   * @return The type node of the parameter
   */
  Type getType() { result = ParameterDeclarationImpl.super.getType() }

  /** 
   * Gets the default value of the parameter declaration, if any.
   * 
   * If provided, this value will be used when no explicit value is 
   * provided during deployment.
   * 
   * @return The default value expression, if one exists
   */
  Expr getDefaultValue() { result = ParameterDeclarationImpl.super.getDefaultValue() }
}


/**
 * Represents an output declaration node in the AST.
 * 
 * Outputs in Bicep allow exposing values from the deployment, such as resource
 * properties, calculated values, or other results. They are typically used to
 * return information about deployed resources or to pass values to parent templates
 * in nested deployments.
 */
class OutputDeclaration extends Stmts instanceof OutputDeclarationImpl {
  /** 
   * Gets the identifier of the output declaration.
   * 
   * This is the name token of the output as it appears in the source code.
   * 
   * @return The identifier node of the output
   */
  Identifier getIdentifier() { result = OutputDeclarationImpl.super.getIdentifier() }

  /** 
   * Gets the name of the output declaration as a string.
   * 
   * This is a convenience method that returns the name from the identifier.
   * 
   * @return The name of the output
   */
  string getName() { result = this.getIdentifier().getName() }

  /** 
   * Gets the type of the output declaration.
   * 
   * This specifies what kind of value is being exposed by this output,
   * such as 'string', 'int', 'bool', or more complex types.
   * 
   * @return The type node of the output
   */
  Type getType() { result = OutputDeclarationImpl.super.getType() }

  /** 
   * Gets the value expression of the output declaration.
   * 
   * This is the expression that will be evaluated to determine the
   * value of the output when the template is deployed.
   * 
   * @return The value expression of the output
   */
  Expr getValue() { result = OutputDeclarationImpl.super.getValue() }
}

/**
 * Represents a user-defined function in the AST.
 * 
 * User-defined functions allow creating reusable pieces of logic in Bicep templates.
 * They encapsulate calculations or transformations that can be called from multiple
 * places in the template, promoting code reuse and maintainability.
 */
class UserDefinedFunction extends Stmts instanceof UserDefinedFunctionImpl {
  /** 
   * Gets the identifier of the user-defined function.
   * 
   * This is the name token of the function as it appears in the source code.
   * 
   * @return The identifier node of the function
   */
  Identifier getIdentifier() { result = UserDefinedFunctionImpl.super.getName() }

  /** 
   * Gets the name of the user-defined function as a string.
   * 
   * This is a convenience method that returns the name from the identifier.
   * 
   * @return The name of the function
   */
  string getName() { result = this.getIdentifier().getName() }

  /** 
   * Gets the return type of the user-defined function.
   * 
   * This specifies what kind of value the function returns,
   * such as 'string', 'int', 'bool', or more complex types.
   * 
   * @return The return type node of the function
   */
  Type getReturnType() { result = UserDefinedFunctionImpl.super.getReturnType() }

  /** 
   * Gets the declared parameters node of the user-defined function.
   * 
   * This contains all the parameter declarations for the function.
   * 
   * @return The parameters node of the function
   */
  Parameters getDeclaredParameters() { result = UserDefinedFunctionImpl.super.getParameters() }

  /** 
   * Gets all individual parameters of the user-defined function.
   * 
   * @return All parameter nodes of the function
   */
  Parameter getParameters() { result = this.getDeclaredParameters().getParameter(_) }

  /** 
   * Gets the parameter at the specified index.
   * 
   * @param index The index of the parameter to retrieve
   * @return The parameter at the specified index
   */
  Parameter getParameter(int index) { result = this.getDeclaredParameters().getParameter(index) }

  /** 
   * Gets the body of the user-defined function.
   * 
   * This is the expression that defines the computation performed by the function.
   * When the function is called, this expression is evaluated with the provided
   * argument values bound to the function parameters.
   * 
   * @return The body expression of the function
   */
  Expr getBody() { result = UserDefinedFunctionImpl.super.getBody() }
}

/**
 * Represents a function parameter node in the AST.
 * 
 * Parameters define the inputs that a function accepts. Each parameter has a name
 * and a type, which constrains the kind of values that can be passed to the function
 * for that parameter.
 */
class Parameter extends Expr instanceof ParameterImpl {
  /** 
   * Gets the identifier of the parameter.
   * 
   * This is the name token of the parameter as it appears in the function declaration.
   * 
   * @return The identifier node of the parameter
   */
  Idents getIdentifier() { result = ParameterImpl.super.getName() }

  /** 
   * Gets the name of the parameter as a string.
   * 
   * This is a convenience method that returns the name from the identifier.
   * 
   * @return The name of the parameter
   */
  string getName() { result = this.getIdentifier().getName() }

  /** 
   * Gets the type of the parameter.
   * 
   * This specifies what kind of values are allowed for this parameter,
   * such as 'string', 'int', 'bool', or more complex types.
   * 
   * @return The type node of the parameter
   */
  Type getType() { result = ParameterImpl.super.getType() }
}

/**
 * Represents a parameters collection node in the AST.
 * 
 * This class represents the collection of parameters in a function declaration,
 * allowing access to the individual parameter nodes.
 */
class Parameters extends Expr instanceof ParametersImpl {
  /** 
   * Gets the parameter at the specified index.
   * 
   * @param index The zero-based index of the parameter to retrieve
   * @return The parameter node at the specified index
   */
  Parameter getParameter(int index) { result = ParametersImpl.super.getParameter(index) }
}


/**
 * An import-with statement in the AST.
 * 
 * Represents an import statement with additional configuration options in Bicep.
 * Import-with statements allow importing external modules with specific settings
 * or transformations applied to the imported items.
 */
final class ImportWithStatementStmt extends Stmts instanceof ImportWithStatementImpl { }

/**
 * A using statement in the AST.
 * 
 * Represents a using statement in Bicep, which introduces a local name for
 * an imported module or namespace. Using statements help improve readability
 * by allowing shorter references to external resources.
 */
final class UsingStatementStmt extends Stmts instanceof UsingStatementImpl { }
