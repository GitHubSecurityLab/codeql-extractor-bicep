private import AstNodes
private import internal.AstNodes
private import internal.TreeSitter
private import internal.Expr
private import internal.AssignmentExpression
private import internal.BinaryExpression
private import internal.CallExpression
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

private import Resources

/**
 * An expression in the AST.
 */
final class Expr extends AstNode instanceof ExprImpl { }

/**
 * A AssignmentExpression expression in the AST.
 */
final class AssignmentExpression extends Expr instanceof AssignmentExpressionImpl { }

/**
 * A BinaryExpression expression in the AST.
 */
final class BinaryExpression extends Expr instanceof BinaryExpressionImpl { }

/**
 * A CallExpression expression in the AST.
 */
final class CallExpression extends Expr instanceof CallExpressionImpl { }

/**
 * A Expression expression in the AST.
 */
final class Expression extends Expr instanceof ExpressionImpl { }

/**
 * A Interpolation literal in the AST.
 */
final class Interpolation extends Expr instanceof InterpolationImpl { }

/**
 * A LambdaExpression expression in the AST.
 */
final class LambdaExpression extends Expr instanceof LambdaExpressionImpl { }

/**
 * A MemberExpression expression in the AST.
 */
class MemberExpression extends Expr instanceof MemberExpressionImpl {
    Object getObject() { result = super.getObject() }
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
