/**
 *  Bicep AST expressions.
 */

private import AstNodes
private import internal.AstNodes
private import internal.TreeSitter
private import internal.Expr
private import internal.AssignmentExpression
private import internal.BinaryExpression
private import internal.Expression
private import internal.Interpolation
private import internal.LambdaExpression
private import internal.MemberExpression
private import internal.NullableType
private import internal.ParenthesizedExpression
private import internal.PrimaryExpression
private import internal.ResourceExpression
private import internal.SubscriptExpression
private import internal.TernaryExpression
private import internal.UnaryExpression
private import Idents
private import Resources

/**
 * An expression in the AST.
 */
final class Expr extends AstNode instanceof ExprImpl { }

/**
 * A AssignmentExpression expression in the AST.
 */
class AssignmentExpression extends Expr instanceof AssignmentExpressionImpl {
  /**
   * Gets the left operand of the assignment expression.
   */
  Expr getLeft() { result = AssignmentExpressionImpl.super.getLeft() }

  /**
   * Gets the right operand of the assignment expression.
   */
  Expr getRight() { result = AssignmentExpressionImpl.super.getRight() }
}

/**
 * A BinaryExpression expression in the AST.
 */
class BinaryExpression extends Expr instanceof BinaryExpressionImpl {
  /**
   * Gets the left operand of the binary expression.
   */
  Expr getLeft() { result = BinaryExpressionImpl.super.getLeft() }

  /**
   * Gets the right operand of the binary expression.
   */
  Expr getRight() { result = BinaryExpressionImpl.super.getRight() }

  /**
   * Gets the operator of the binary expression.
   */
  string getOperator() { result = BinaryExpressionImpl.super.getOperator() }
}

/**
 * A Expression expression in the AST.
 */
final class Expression extends Expr instanceof ExpressionImpl { }

/**
 * A Interpolation literal in the AST.
 */
final class Interpolation extends Expr instanceof InterpolationImpl {
  /**
   *  Gets the expression contained within the interpolation.
   */
  Expr getExpression() {
    result = InterpolationImpl.super.getExpression()
  }

  string getValue() {
    result = "${" + this.getExpression().toString() + "}"
  }
}

/**
 * A LambdaExpression expression in the AST.
 */
final class LambdaExpression extends Expr instanceof LambdaExpressionImpl { }

/**
 * A MemberExpression expression in the AST.
 */
class MemberExpression extends Expr instanceof MemberExpressionImpl {
  /**
   * The namespace of the member expression.
   */
  Idents getNamespace() { result = MemberExpressionImpl.super.getObject() }

  /**
   * The member of the member expression.
   */
  Idents getName() { result = MemberExpressionImpl.super.getProperty() }

  /**
   * Gets the full name of the member expression, which includes the namespace and the member name.
   */
  string getFullName() { result = this.getNamespace().getName() + "." + this.getName().getName() }
}

/**
 * An alias for MemberExpression.
 */
final class MemberExpr = MemberExpression;

/**
 * A NullableType literal in the AST.
 */
final class NullableType extends Expr instanceof NullableTypeImpl { }

/**
 * A ParenthesizedExpression expression in the AST.
 */
final class ParenthesizedExpression extends Expr instanceof ParenthesizedExpressionImpl { }

/**
 * A PrimaryExpression expression in the AST.
 */
final class PrimaryExpression extends Expr instanceof PrimaryExpressionImpl { }

/**
 * A ResourceExpression expression in the AST.
 */
final class ResourceExpression extends Expr instanceof ResourceExpressionImpl { }

/**
 * A SubscriptExpression expression in the AST.
 */
final class SubscriptExpression extends Expr instanceof SubscriptExpressionImpl { }

/**
 * A TernaryExpression expression in the AST.
 */
final class TernaryExpression extends Expr instanceof TernaryExpressionImpl { }

/**
 * A UnaryExpression expression in the AST.
 */
final class UnaryExpression extends Expr instanceof UnaryExpressionImpl { }
