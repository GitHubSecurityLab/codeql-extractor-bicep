/**
 * Statement nodes in the AST.
 */

private import AstNodes
private import Idents
private import Expr
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
private import internal.Statement
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
 * A Stmt block
 */
class Stmts extends AstNode instanceof StmtsImpl {
  /** Gets a control-flow node for this statement, if any. */
  CfgImpl::AstCfgNode getAControlFlowNode() { result.getAstNode() = this }

  /** Gets a control-flow entry node for this statement, if any */
  AstNode getAControlFlowEntryNode() { result = CfgImpl::getAControlFlowEntryNode(this) }
}

/**
 * A AssertStatement statement
 */
final class AssertStatementStmt extends Stmts instanceof AssertStatementImpl { }

/**
 * A ForStatement statement
 */
final class ForStatementStmt extends Stmts instanceof ForStatementImpl { }

/**
 * A IfStatement statement
 */
final class IfStatementStmt extends Stmts instanceof IfStatementImpl { }

/**
 * A ImportStatement statement
 */
final class ImportStatementStmt extends Stmts instanceof ImportStatementImpl { }

/**
 *  A Infrastructure unknown AST node.
 */
class Infrastructure extends AstNode instanceof InfrastructureImpl {
  /** Gets the first statement in the infrastructure. */
  Stmts getStatement(int index) { result = InfrastructureImpl.super.getStatement(index) }
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
 * A ImportWithStatement statement
 */
final class ImportWithStatementStmt extends Stmts instanceof ImportWithStatementImpl { }

/**
 * A Statement statement
 */
final class StatementStmt extends Stmts instanceof StatementImpl { }

/**
 * A UsingStatement statement
 */
final class UsingStatementStmt extends Stmts instanceof UsingStatementImpl { }
