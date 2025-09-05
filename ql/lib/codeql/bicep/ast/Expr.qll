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
private import internal.TernaryExpression
private import internal.UnaryExpression
private import Idents
private import Resources

/**
 * An expression in the AST.
 * 
 * This is the base class for all expression nodes in Bicep, including literals,
 * variables, function calls, operators, and other constructs that compute values.
 * Expressions can be nested and can appear in various contexts such as assignments,
 * parameter values, and return statements.
 */
final class Expr extends AstNode instanceof ExprImpl { }

/**
 * An assignment expression in the AST.
 * 
 * Represents an assignment of a value to a variable or property, such as
 * `x = 42` or `obj.prop = value`. The assignment expression consists of
 * a left-hand side (the target), an assignment operator, and a right-hand
 * side (the value).
 */
class AssignmentExpression extends Expr instanceof AssignmentExpressionImpl {
  /**
   * Gets the left operand of the assignment expression.
   * 
   * This is the target of the assignment, which could be a variable,
   * property access, or other assignable expression.
   */
  Expr getLeft() { result = AssignmentExpressionImpl.super.getLeft() }

  /**
   * Gets the right operand of the assignment expression.
   * 
   * This is the value being assigned to the target.
   */
  Expr getRight() { result = AssignmentExpressionImpl.super.getRight() }
}

/**
 * A binary expression in the AST.
 * 
 * Represents an expression with a binary operator and two operands.
 * This includes arithmetic operations (like addition, subtraction),
 * logical operations (like AND, OR), comparison operations (like equality,
 * less than), and other binary operators in the Bicep language.
 */
class BinaryExpression extends Expr instanceof BinaryExpressionImpl {
  /**
   * Gets the left operand of the binary expression.
   * 
   * This is the expression that appears to the left of the operator.
   */
  Expr getLeft() { result = BinaryExpressionImpl.super.getLeft() }

  /**
   * Gets the right operand of the binary expression.
   * 
   * This is the expression that appears to the right of the operator.
   */
  Expr getRight() { result = BinaryExpressionImpl.super.getRight() }

  /**
   * Gets the operator of the binary expression as a string.
   * 
   * Examples include "+", "-", "*", "/", "==", "!=", "&&", "||", etc.
   */
  string getOperator() { result = BinaryExpressionImpl.super.getOperator() }
}

/**
 * A generic expression in the AST.
 * 
 * This class represents any expression that doesn't fit into other more 
 * specific expression categories. It serves as a base implementation for 
 * expressions in the Bicep language.
 */
final class Expression extends Expr instanceof ExpressionImpl { }

/**
 * An interpolation expression in the AST.
 * 
 * Represents string interpolation expressions of the form ${expr} that appear within 
 * string literals. Interpolations allow embedding dynamic values or expressions 
 * within string literals.
 */
final class Interpolation extends Expr instanceof InterpolationImpl {
  /**
   * Gets the expression contained within the interpolation.
   * 
   * This is the expression between the ${...} delimiters whose value
   * will be converted to a string and inserted into the containing string.
   */
  Expr getExpression() {
    result = InterpolationImpl.super.getExpression()
  }

  /**
   * Gets the string representation of this interpolation.
   * 
   * Returns the interpolation in the form "${expression}".
   */
  string getValue() {
    result = "${" + this.getExpression().toString() + "}"
  }
}

/**
 * A lambda expression in the AST.
 * 
 * Represents an anonymous function in Bicep, typically used for callbacks,
 * filters, or other functional programming patterns. A lambda expression
 * consists of parameters and a body that defines the computation to be performed.
 */
final class LambdaExpression extends Expr instanceof LambdaExpressionImpl { }

/**
 * A member expression in the AST.
 * 
 * Represents a property or method access on an object, such as `object.property`
 * or `resource.name`. Member expressions consist of an object (the namespace)
 * and a property (the member being accessed).
 */
class MemberExpression extends Expr instanceof MemberExpressionImpl {
  /**
   * Gets the namespace (object) of the member expression.
   * 
   * This is the part of the expression before the dot operator.
   * For example, in `resource.name`, this would be `resource`.
   */
  Idents getNamespace() { result = MemberExpressionImpl.super.getObject() }

  /**
   * Gets the member (property) of the member expression.
   * 
   * This is the part of the expression after the dot operator.
   * For example, in `resource.name`, this would be `name`.
   */
  Idents getName() { result = MemberExpressionImpl.super.getProperty() }

  /**
   * Gets the full name of the member expression.
   * 
   * This combines the namespace and member names with a dot separator.
   * For example, for the expression `resource.name`, this would return `"resource.name"`.
   */
  string getFullName() { result = this.getNamespace().getName() + "." + this.getName().getName() }
}

/**
 * An alias for MemberExpression.
 * 
 * This alias provides a shorter name for convenience.
 */
final class MemberExpr = MemberExpression;

/**
 * A nullable type expression in the AST.
 * 
 * Represents a type that can be null, typically denoted with a question mark
 * after the type name (e.g., `string?`). Nullable types explicitly allow
 * the value to be null in addition to values of the underlying type.
 */
final class NullableType extends Expr instanceof NullableTypeImpl { }

/**
 * A parenthesized expression in the AST.
 * 
 * Represents an expression enclosed within parentheses, such as `(1 + 2)`.
 * Parentheses can be used to explicitly specify operator precedence or
 * to improve code readability.
 */
class ParenthesizedExpression extends Expr instanceof ParenthesizedExpressionImpl { 
  /**
   * Gets the expression at the specified index contained within the parentheses.
   * 
   * @param index The index of the expression to retrieve
   * @return The expression at the specified index
   */
  Expr getExpression(int index) {
    result = ParenthesizedExpressionImpl.super.getExpression(index)
  }

  /**
   * Gets all expressions contained within the parentheses.
   * 
   * This method returns all expressions enclosed by the parentheses,
   * which could be a single expression or multiple expressions if the
   * parentheses contain a comma-separated list.
   */
  Expr getExpressions() {
    result = ParenthesizedExpressionImpl.super.getExpressions()
  }
}

/**
 * A primary expression in the AST.
 * 
 * Represents a basic, self-contained expression such as a literal value,
 * identifier, or other fundamental expression type. Primary expressions
 * serve as the building blocks for more complex expressions.
 */
final class PrimaryExpression extends Expr instanceof PrimaryExpressionImpl { }

/**
 * A resource expression in the AST.
 * 
 * Represents an expression that refers to or creates an Azure resource.
 * Resource expressions are fundamental to Bicep as they define the
 * infrastructure resources to be provisioned.
 */
final class ResourceExpression extends Expr instanceof ResourceExpressionImpl { }

/**
 * A ternary expression in the AST.
 * 
 * Represents a conditional (ternary) expression of the form `condition ? trueExpr : falseExpr`.
 * The expression evaluates the condition and returns one of two values based on whether
 * the condition is true or false.
 */
final class TernaryExpression extends Expr instanceof TernaryExpressionImpl { }

/**
 * A unary expression in the AST.
 * 
 * Represents an expression with a unary operator and a single operand.
 * Examples include negation (`!expr`), numeric negation (`-expr`),
 * and other operations that apply to a single value.
 */
final class UnaryExpression extends Expr instanceof UnaryExpressionImpl { }
