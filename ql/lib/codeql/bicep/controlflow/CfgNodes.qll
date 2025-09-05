/** Provides classes representing nodes in a control flow graph. */

private import bicep
private import codeql.bicep.ast.Calls
private import codeql.bicep.ast.Literals
private import codeql.bicep.ast.Resources
private import BasicBlocks
private import ControlFlowGraph
import internal.ControlFlowGraphImpl

/**
 * A class for mapping parent-child AST nodes to parent-child CFG nodes.
 */
abstract private class ChildMapping extends AstNode {
  /**
   * Holds if `child` is a (possibly nested) child of this expression
   * for which we would like to find a matching CFG child.
   */
  abstract predicate relevantChild(AstNode child);

  pragma[nomagic]
  abstract predicate reachesBasicBlock(AstNode child, CfgNode cfn, BasicBlock bb);

  /**
   * Holds if there is a control-flow path from `cfn` to `cfnChild`, where `cfn`
   * is a control-flow node for this expression, and `cfnChild` is a control-flow
   * node for `child`.
   *
   * The path never escapes the syntactic scope of this expression.
   */
  cached
  predicate hasCfgChild(AstNode child, CfgNode cfn, CfgNode cfnChild) {
    this.reachesBasicBlock(child, cfn, cfnChild.getBasicBlock()) and
    cfnChild.getAstNode() = child
  }
}

/**
 * A class for mapping parent-child AST nodes to parent-child CFG nodes.
 */
abstract private class ExprChildMapping extends Expr, ChildMapping {
  pragma[nomagic]
  override predicate reachesBasicBlock(AstNode child, CfgNode cfn, BasicBlock bb) {
    this.relevantChild(child) and
    cfn = this.getAControlFlowNode() and
    bb.getANode() = cfn
    or
    exists(BasicBlock mid |
      this.reachesBasicBlock(child, cfn, mid) and
      bb = mid.getAPredecessor() and
      not mid.getANode().getAstNode() = child
    )
  }
}

/** A control-flow node that wraps an AST expression. */
class ExprCfgNode extends AstCfgNode {
  string getAPrimaryQlClass() { result = "ExprCfgNode" }

  Expr e;

  ExprCfgNode() { e = this.getAstNode() }

  /** Gets the underlying expression. */
  Expr getExpr() { result = e }
}

/** A control-flow node that wraps an AST statement. */
class StmtsCfgNode extends AstCfgNode {
  string getAPrimaryQlClass() { result = "StmtsCfgNode" }

  Stmts s;

  StmtsCfgNode() { s = this.getAstNode() }

  /** Gets the underlying expression. */
  Stmts getStmt() { result = s }
}

/** A control-flow node that wraps an AST literal. */
class LiteralsCfgNode extends AstCfgNode {
  string getAPrimaryQlClass() { result = "LiteralsCfgNode" }

  Literals l;

  LiteralsCfgNode() { l = this.getAstNode() }

  /** Gets the underlying literal. */
  Literals getLiteral() { result = l }
}

class VariableCfgNode extends AstCfgNode {
  string getAPrimaryQlClass() { result = "VariableCfgNode" }

  Variable v;

  VariableCfgNode() { v.getAstNode() = this.getAstNode() }

  /**
   * Gets the underlying `Variable` expression.
   */
  Variable getExpr() { result = v }

  /** Gets the name of the variable. */
  string getName() { result = v.getName() }
}

/** A control-flow node that wraps a `VariableAccess` AST expression. */
class VariableAccessCfgNode extends AstCfgNode {
  string getAPrimaryQlClass() { result = "VariableAccessCfgNode" }

  VariableAccess v;

  VariableAccessCfgNode() { v.getAstNode() = this.getAstNode() }

  /**
   * Gets the underlying `VariableAccess` expression.
   */
  VariableAccess getExpr() { result = v }

  /** Gets the variable */
  VariableCfgNode getTarget() { result.getExpr() = v.getVariable() }
}

/** A control-flow node that wraps a `VariableReadAccess` AST expression. */
class VariableReadAccessCfgNode extends VariableAccessCfgNode {
  override string getAPrimaryQlClass() { result = "VariableReadAccessCfgNode" }

  override VariableReadAccess v;

  override VariableReadAccess getExpr() { result = super.getExpr() }

  Variable getVariable() { result = v.getVariable() }
}

class VariableWriteAccessCfgNode extends VariableAccessCfgNode {
  override string getAPrimaryQlClass() { result = "VariableWriteAccessCfgNode" }

  override VariableWriteAccess v;

  override VariableWriteAccess getExpr() { result.asExpr() = v.asExpr() }

  Variable getVariable() { result = v.getVariable() }

  final ExprCfgNode getReceiver() { result.getExpr() = v.asExpr() }
}

/** Provides classes for control-flow nodes that wrap AST expressions. */
module ExprNodes {
  /** A mapping from a child of a literal to a literal. */
  abstract class LiteralChildMapping extends AstNode {
    /** Holds if `n` is a relevant child of this literal. */
    abstract predicate relevantChild(AstNode n);
  }

  /** A control-flow node that wraps an Array AST node. */
  class ArrayCfgNode extends LiteralsCfgNode {
    override string getAPrimaryQlClass() { result = "ArrayCfgNode" }

    Array e;

    ArrayCfgNode() { l = this.getLiteral() }

    /** Gets the underlying array literal. */
    Array getArray() { result = l }
  }

  /** A control-flow node that wraps a Boolean AST node. */
  class BooleanCfgNode extends LiteralsCfgNode {
    override string getAPrimaryQlClass() { result = "BooleanCfgNode" }

    Boolean e;

    BooleanCfgNode() { l = this.getLiteral() }

    /** Gets the underlying boolean literal. */
    Boolean getBoolean() { result = l }
  }

  /** A control-flow node that wraps a NullLiteral AST node. */
  class NullLiteralCfgNode extends LiteralsCfgNode {
    override string getAPrimaryQlClass() { result = "NullLiteralCfgNode" }

    NullLiteral e;

    NullLiteralCfgNode() { l = this.getLiteral() }

    /** Gets the underlying null literal. */
    NullLiteral getNullLiteral() { result = l }
  }

  /** A control-flow node that wraps a Number AST node. */
  class NumberCfgNode extends LiteralsCfgNode {
    override string getAPrimaryQlClass() { result = "NumberCfgNode" }

    Number e;

    NumberCfgNode() { l = this.getLiteral() }

    /** Gets the underlying number literal. */
    Number getNumber() { result = l }
  }

  /** A control-flow node that wraps a StringLiteral AST node. */
  class StringLiteralCfgNode extends LiteralsCfgNode {
    override string getAPrimaryQlClass() { result = "StringLiteralCfgNode" }

    StringLiteral e;

    StringLiteralCfgNode() { l = this.getLiteral() }

    /** Gets the underlying string literal. */
    StringLiteral getStringLiteral() { result = l }
  }

  /** A control-flow node that wraps a StringContentLiteral AST node. */
  class StringContentLiteralCfgNode extends LiteralsCfgNode {
    override string getAPrimaryQlClass() { result = "StringContentLiteralCfgNode" }

    StringContentLiteral e;

    StringContentLiteralCfgNode() { l = this.getLiteral() }

    /** Gets the underlying string content literal. */
    StringContentLiteral getStringContentLiteral() { result = l }
  }

  /** A control-flow node that wraps a CallExpression AST node. */
  class CallCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "CallCfgNode" }

    override CallExpression e;

    override CallExpression getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of an Arguments expression to the expression. */
  abstract class ArgumentsChildMapping extends ExprChildMapping, Arguments {
    override predicate relevantChild(AstNode n) { n = this.getArgument(_) }
  }

  /** A control-flow node that wraps an Arguments AST node. */
  class ArgumentsCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ArgumentsCfgNode" }

    override Arguments e;

    override Arguments getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of an AssignmentExpression to the expression. */
  abstract class AssignmentExpressionChildMapping extends ExprChildMapping,
    AssignmentExpression
  {
    override predicate relevantChild(AstNode n) { n = this.getLeft() or n = this.getRight() }
  }

  /** A control-flow node that wraps an AssignmentExpression AST node. */
  class AssignmentExpressionCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "AssignmentExpressionCfgNode" }

    override AssignmentExpression e;

    override AssignmentExpression getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of a BinaryExpression to the expression. */
  abstract class BinaryExpressionChildMapping extends ExprChildMapping, BinaryExpression {
    override predicate relevantChild(AstNode n) { n = this.getLeft() or n = this.getRight() }
  }

  /** A control-flow node that wraps a BinaryExpression AST node. */
  class BinaryExpressionCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "BinaryExpressionCfgNode" }

    override BinaryExpression e;

    override BinaryExpression getExpr() { result = super.getExpr() }

    /** Gets the left operand CFG node */
    final ExprCfgNode getLeftOperand() {
      result = this.getAPredecessor().(ExprCfgNode) and
      result.getExpr() = this.getExpr().getLeft()
    }

    /** Gets the right operand CFG node */
    final ExprCfgNode getRightOperand() {
      result = this.getAPredecessor().(ExprCfgNode) and
      result.getExpr() = this.getExpr().getRight()
    }
  }

  /** A mapping from a child of an Interpolation to the expression. */
  abstract class InterpolationChildMapping extends ExprChildMapping, Interpolation {
    override predicate relevantChild(AstNode n) { n = this.getExpression() }
  }

  /** A control-flow node that wraps an Interpolation AST node. */
  class InterpolationCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "InterpolationCfgNode" }

    override Interpolation e;

    override Interpolation getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of a LambdaExpression to the expression. */
  abstract class LambdaExpressionChildMapping extends ExprChildMapping, LambdaExpression {
    override predicate relevantChild(AstNode n) { n = this.getAChild() }
  }

  /** A control-flow node that wraps a LambdaExpression AST node. */
  class LambdaExpressionCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "LambdaExpressionCfgNode" }

    override LambdaExpression e;

    override LambdaExpression getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of a MemberExpression to the expression. */
  abstract class MemberExpressionChildMapping extends ExprChildMapping, MemberExpression {
    override predicate relevantChild(AstNode n) { n = this.getNamespace() or n = this.getName() }
  }

  /** A control-flow node that wraps a MemberExpression AST node. */
  class MemberExpressionCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "MemberExpressionCfgNode" }

    override MemberExpression e;

    override MemberExpression getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of a NullableType to the expression. */
  abstract class NullableTypeChildMapping extends ExprChildMapping, NullableType {
    override predicate relevantChild(AstNode n) { n = this.getAChild() }
  }

  /** A control-flow node that wraps a NullableType AST node. */
  class NullableTypeCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "NullableTypeCfgNode" }

    override NullableType e;

    override NullableType getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of a ParenthesizedExpression to the expression. */
  abstract class ParenthesizedExpressionChildMapping extends ExprChildMapping,
    ParenthesizedExpression
  {
    override predicate relevantChild(AstNode n) { n = this.getExpression(_) }
  }

  /** A control-flow node that wraps a ParenthesizedExpression AST node. */
  class ParenthesizedExpressionCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ParenthesizedExpressionCfgNode" }

    override ParenthesizedExpression e;

    override ParenthesizedExpression getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of a ResourceExpression to the expression. */
  abstract class ResourceExpressionChildMapping extends ExprChildMapping, ResourceExpression {
    override predicate relevantChild(AstNode n) { n = this.getAChild() }
  }

  /** A control-flow node that wraps a ResourceExpression AST node. */
  class ResourceExpressionCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ResourceExpressionCfgNode" }

    override ResourceExpression e;

    override ResourceExpression getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of a TernaryExpression to the expression. */
  abstract class TernaryExpressionChildMapping extends ExprChildMapping, TernaryExpression {
    override predicate relevantChild(AstNode n) { n = this.getAChild() }
  }

  /** A control-flow node that wraps a TernaryExpression AST node. */
  class TernaryExpressionCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "TernaryExpressionCfgNode" }

    override TernaryExpression e;

    override TernaryExpression getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of a UnaryExpression to the expression. */
  abstract class UnaryExpressionChildMapping extends ExprChildMapping, UnaryExpression {
    override predicate relevantChild(AstNode n) { n = this.getAChild() }
  }

  /** A control-flow node that wraps a UnaryExpression AST node. */
  class UnaryExpressionCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "UnaryExpressionCfgNode" }

    override UnaryExpression e;

    override UnaryExpression getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of a Parameter to the expression. */
  abstract class ParameterChildMapping extends ExprChildMapping, Parameter {
    override predicate relevantChild(AstNode n) { n = this.getIdentifier() or n = this.getType() }
  }

  /** A control-flow node that wraps a Parameter AST node. */
  class ParameterCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ParameterCfgNode" }

    override Parameter e;

    override Parameter getExpr() { result = super.getExpr() }
  }

  /** A mapping from a child of Parameters to the expression. */
  abstract class ParametersChildMaping extends ExprChildMapping, Parameters {
    override predicate relevantChild(AstNode n) { n = this.getParameter(_) }
  }

  /** A control-flow node that wraps a Parameters AST node. */
  class ParametersCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ParametersCfgNode" }

    override Parameters e;

    override Parameters getExpr() { result = super.getExpr() }
  }
}

/** Provides classes for control-flow nodes that wrap AST statements. */
module StmtNodes {
  /** A mapping from a child of a statement to a statement. */
  abstract class StmtChildMapping extends Stmts {
    /** Holds if `n` is a relevant child of this statement. */
    abstract predicate relevantChild(AstNode n);
  }

  /** A control-flow node that wraps an AssertStatement AST node. */
  class AssertStatementCfgNode extends StmtsCfgNode {
    override string getAPrimaryQlClass() { result = "AssertStatementCfgNode" }

    override AssertStatement s;

    override AssertStatement getStmt() { result = super.getStmt() }
  }

  /** A control-flow node that wraps a ForStatement AST node. */
  class ForStatementCfgNode extends StmtsCfgNode {
    override string getAPrimaryQlClass() { result = "ForStatementCfgNode" }

    override ForStatement s;

    override ForStatement getStmt() { result = super.getStmt() }
  }

  /** A mapping from a child of an IfStatement to the statement. */
  abstract class IfStatementChildMapping extends StmtChildMapping, IfStatement {
    override predicate relevantChild(AstNode n) { n = this.getCondition() or n = this.getBody() }
  }

  /** A control-flow node that wraps an IfStatement AST node. */
  class IfStatementCfgNode extends StmtsCfgNode {
    override string getAPrimaryQlClass() { result = "IfStatementCfgNode" }

    override IfStatement s;

    override IfStatement getStmt() { result = super.getStmt() }

    /** Gets the condition CFG node */
    final ExprCfgNode getCondition() {
      result = this.getAPredecessor().(ExprCfgNode) and
      result.getExpr() = this.getStmt().getCondition()
    }

    /** Gets the body CFG node */
    final ExprCfgNode getBody() {
      result = this.getAPredecessor().(ExprCfgNode) and
      result.getExpr() = this.getStmt().getBody()
    }
  }

  /** A control-flow node that wraps an ImportStatement AST node. */
  class ImportStatementCfgNode extends StmtsCfgNode {
    override string getAPrimaryQlClass() { result = "ImportStatementCfgNode" }

    override ImportStatement s;

    override ImportStatement getStmt() { result = super.getStmt() }
  }

  /** A control-flow node that wraps an Infrastructure AST node. */
  class InfrastructureCfgNode extends AstCfgNode {
    string getAPrimaryQlClass() { result = "InfrastructureCfgNode" }

    Infrastructure i;

    InfrastructureCfgNode() { i = this.getAstNode() }

    /** Gets the underlying Infrastructure. */
    Infrastructure getInfrastructure() { result = i }
  }

  /** A mapping from a child of a ParameterDeclaration to the statement. */
  abstract class ParameterDeclarationChildMapping extends StmtChildMapping, ParameterDeclaration {
    override predicate relevantChild(AstNode n) {
      n = this.getIdentifier() or n = this.getDefaultValue()
    }
  }

  /** A control-flow node that wraps a ParameterDeclaration AST node. */
  class ParameterDeclarationCfgNode extends StmtsCfgNode {
    override string getAPrimaryQlClass() { result = "ParameterDeclarationCfgNode" }

    override ParameterDeclaration s;

    override ParameterDeclaration getStmt() { result = super.getStmt() }
  }

  /** A mapping from a child of an OutputDeclaration to the statement. */
  abstract class OutputDeclarationChildMapping extends StmtChildMapping, OutputDeclaration {
    override predicate relevantChild(AstNode n) { n = this.getIdentifier() or n = this.getValue() }
  }

  /** A control-flow node that wraps an OutputDeclaration AST node. */
  class OutputDeclarationCfgNode extends StmtsCfgNode {
    override string getAPrimaryQlClass() { result = "OutputDeclarationCfgNode" }

    override OutputDeclaration s;

    override OutputDeclaration getStmt() { result = super.getStmt() }
  }

  /** A mapping from a child of a UserDefinedFunction to the statement. */
  abstract class UserDefinedFunctionChildMapping extends StmtChildMapping, UserDefinedFunction {
    override predicate relevantChild(AstNode n) {
      n = this.getIdentifier() or
      n = this.getParameters() or
      n = this.getReturnType() or
      n = this.getBody()
    }
  }

  /** A control-flow node that wraps a UserDefinedFunction AST node. */
  class UserDefinedFunctionCfgNode extends StmtsCfgNode {
    override string getAPrimaryQlClass() { result = "UserDefinedFunctionCfgNode" }

    override UserDefinedFunction s;

    override UserDefinedFunction getStmt() { result = super.getStmt() }
  }

  /** A control-flow node that wraps an ImportWithStatement AST node. */
  class ImportWithStatementCfgNode extends StmtsCfgNode {
    override string getAPrimaryQlClass() { result = "ImportWithStatementCfgNode" }

    override ImportWithStatement s;

    override ImportWithStatement getStmt() { result = super.getStmt() }
  }

  /** A control-flow node that wraps a UsingStatement AST node. */
  class UsingStatementCfgNode extends StmtsCfgNode {
    override string getAPrimaryQlClass() { result = "UsingStatementCfgNode" }

    override UsingStatement s;

    override UsingStatement getStmt() { result = super.getStmt() }
  }

  /** A control-flow node that wraps a UserDefinedFunction AST node. */
  class CallCfgNode extends StmtsCfgNode {
    override string getAPrimaryQlClass() { result = "CallCfgNode" }

    override UserDefinedFunction s;

    override UserDefinedFunction getStmt() { result = super.getStmt() }
  }
}
