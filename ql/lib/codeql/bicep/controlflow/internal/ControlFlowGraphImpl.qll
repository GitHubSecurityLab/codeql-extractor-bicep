/**
 * Internal: Control flow graph construction for Bicep.
 */

private import bicep
// CFG
import codeql.controlflow.Cfg
import Completion
private import Scope as Scope
private import codeql.bicep.controlflow.ControlFlowGraph as Cfg

// private import codeql.Locations
private module Implementation implements InputSig<Location> {
  private import bicep as Bicep
  private import Completion as C
  private import Splitting as S

  class AstNode = Bicep::AstNode;

  class Completion = C::Completion;

  predicate completionIsNormal = C::completionIsNormal/1;

  predicate completionIsSimple = C::completionIsSimple/1;

  predicate completionIsValidFor = C::completionIsValidFor/2;

  /** An AST node with an associated control-flow graph. */
  class CfgScope = Scope::CfgScope;

  class SplitKindBase = S::TSplitKind;

  class Split = S::Split;

  class SuccessorType = Cfg::SuccessorType;

  CfgScope getCfgScope(AstNode e) {
    exists(AstNode p | p = e.getParent() |
      result = p
      or
      not p instanceof CfgScope and result = getCfgScope(p)
    )
  }

  int maxSplits() { result = 0 }

  /** Holds if `first` is first executed when entering `scope`. */
  predicate scopeFirst(CfgScope scope, AstNode first) { scope.scopeFirst(first) }

  /** Holds if `scope` is exited when `last` finishes with completion `c`. */
  predicate scopeLast(CfgScope scope, AstNode last, Completion c) { scope.scopeLast(last, c) }

  predicate successorTypeIsSimple(SuccessorType t) { t instanceof Cfg::NormalSuccessor }

  predicate successorTypeIsCondition(SuccessorType t) { t instanceof Cfg::BooleanSuccessor }

  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  predicate isAbnormalExitType(SuccessorType t) { none() }
}

private module CfgImpl = Make<Location, Implementation>;

import CfgImpl

module Trees {
  private class InfrastructureScopeTree extends StandardTree, PreOrderTree, PostOrderTree,
    Scope::InfrastructureScope
  {
    override AstNode getChildNode(int i) { result = super.getStmt(i) }
  }

  private class StmtsTree extends StandardPostOrderTree instanceof Stmts {
    override AstNode getChildNode(int i) {
      //
      i = 0 and result = super.getAChild()
    }
  }

  private class ExprTree extends StandardPostOrderTree instanceof Expr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getAChild() }
  }

  /**
   * A tree for Arguments in a Bicep program.
   */
  private class ArgumentsTree extends StandardPostOrderTree instanceof Arguments {
    override AstNode getChildNode(int i) { result = super.getArgument(i) }
  }

  /**
   * A tree for AssignmentExpression in a Bicep program.
   */
  private class AssignmentExpressionTree extends StandardPostOrderTree instanceof AssignmentExpression {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getLeft()
      or
      i = 1 and result = super.getRight()
    }
  }

  /**
   * A tree for BinaryExpression in a Bicep program.
   */
  private class BinaryExpressionTree extends StandardPostOrderTree instanceof BinaryExpression {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getLeft()
      or
      i = 1 and result = super.getRight()
    }
  }

  /**
   * A tree for Interpolation in a Bicep program.
   */
  private class InterpolationTree extends StandardPostOrderTree instanceof Interpolation {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpression() }
  }

  /**
   * A tree for LambdaExpression in a Bicep program.
   */
  private class LambdaExpressionTree extends StandardPostOrderTree instanceof LambdaExpression {
    override AstNode getChildNode(int i) { i = 0 and result = super.getAChild() }
  }

  /**
   * A tree for MemberExpression in a Bicep program.
   */
  private class MemberExpressionTree extends StandardPostOrderTree instanceof MemberExpression {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getNamespace()
      or
      i = 1 and result = super.getName()
    }
  }

  /**
   * A tree for NullableType in a Bicep program.
   */
  private class NullableTypeTree extends StandardPostOrderTree instanceof NullableType {
    override AstNode getChildNode(int i) { i = 0 and result = super.getAChild() }
  }

  /**
   * A tree for ParenthesizedExpression in a Bicep program.
   */
  private class ParenthesizedExpressionTree extends StandardPostOrderTree instanceof ParenthesizedExpression
  {
    override AstNode getChildNode(int i) { result = super.getExpression(i) }
  }

  /**
   * A tree for ResourceExpression in a Bicep program.
   */
  private class ResourceExpressionTree extends StandardPostOrderTree instanceof ResourceExpression {
    override AstNode getChildNode(int i) { i = 0 and result = super.getAChild() }
  }

  /**
   * A tree for TernaryExpression in a Bicep program.
   */
  private class TernaryExpressionTree extends StandardPostOrderTree instanceof TernaryExpression {
    override AstNode getChildNode(int i) { i = 0 and result = super.getAChild() }
  }

  /**
   * A unary expression in the CFG.
   */
  private class UnaryExpressionTree extends StandardPostOrderTree instanceof UnaryExpression {
    override AstNode getChildNode(int i) { i = 0 and result = super.getAChild() }
  }

  /**
   * A tree for Object in a Bicep program.
   */
  private class ObjectTree extends StandardPostOrderTree instanceof Object {
    override AstNode getChildNode(int i) { result = super.getProp(i) }
  }

  /**
   * A tree for ObjectProperty in a Bicep program.
   */
  private class ObjectPropertyTree extends StandardPostOrderTree instanceof ObjectProperty {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getName()
      or
      i = 1 and result = super.getValue()
    }
  }

  /**
   * A tree for SubscriptExpression in a Bicep program.
   */
  private class SubscriptExpressionTree extends StandardPostOrderTree instanceof SubscriptExpression {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getIdentifier()
      or
      i = 1 and result = super.getIndex()
    }
  }

  /**
   * A tree for Array in a Bicep program.
   */
  private class ArrayTree extends StandardPostOrderTree instanceof Array {
    override AstNode getChildNode(int i) { result = super.getElement(i) }
  }

  /**
   * A tree for Boolean literals in a Bicep program.
   */
  private class BooleanTree extends LeafTree instanceof Boolean { }

  /**
   * A tree for NullLiteral in a Bicep program.
   */
  private class NullLiteralTree extends LeafTree instanceof NullLiteral { }

  /**
   * A tree for Number literals in a Bicep program.
   */
  private class NumberTree extends LeafTree instanceof Number { }

  /**
   * A tree for String literals in a Bicep program.
   */
  private class StringLiteralTree extends StandardPostOrderTree instanceof StringLiteral {
    override AstNode getChildNode(int i) { result = super.getInterpolation(i) }
  }

  /**
   * A tree for StringContentLiteral in a Bicep program.
   */
  private class StringContentLiteralTree extends LeafTree instanceof StringContentLiteral { }

  /**
   * A literal value in a Bicep program.
   */
  private class LiteralTree extends LeafTree instanceof Literals { }

  /**
   * A NullableReturnType literal value in a Bicep program.
   */
  private class NullableReturnTypeLiteralTree extends LeafTree instanceof NullableReturnTypeLiteral { }

  /**
   *  ParameterDeclarationTree represents a parameter declaration in a Bicep program.
   */
  private class ParameterDeclarationTree extends PreOrderTree instanceof ParameterDeclaration {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getIdentifier() }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Start with the identifier
      pred = this and first(super.getIdentifier(), succ) and completionIsSimple(c)
      or
      last(super.getIdentifier(), pred, c) and
      first(super.getDefaultValue(), succ) and
      completionIsNormal(c)
    }

    override predicate last(AstNode node, Completion c) {
      node = super.getDefaultValue() and completionIsNormal(c)
    }
  }

  private class UserDefinedFunctionTree extends StandardPostOrderTree instanceof UserDefinedFunction {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getIdentifier()
      or
      i = 1 and result = super.getParameters()
      or
      i = 2 and result = super.getReturnType()
      or
      i = 3 and result = super.getBody()
    }
  }

  private class OutputDeclarationTree extends PreOrderTree instanceof OutputDeclaration {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getIdentifier() }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Start with the identifier
      pred = this and first(super.getIdentifier(), succ) and completionIsSimple(c)
      or
      last(super.getIdentifier(), pred, c) and
      first(super.getValue(), succ) and
      completionIsNormal(c)
    }

    override predicate last(AstNode node, Completion c) {
      node = super.getValue() and completionIsNormal(c)
    }
  }
}
