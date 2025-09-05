/**
 * Literals in the AST.
 */

private import AstNodes
private import Expr
private import Idents
private import Variables
private import internal.AstNodes
private import internal.TreeSitter
private import internal.Literals
private import internal.Array
private import internal.Boolean
private import internal.Null
private import internal.NullableReturnType
private import internal.Number
private import internal.String
private import internal.StringContent
private import internal.SubscriptExpression

/**
 * A literal value in the AST.
 * 
 * This is the base class for all literal values in Bicep, such as strings,
 * numbers, booleans, null, and arrays. Literals represent fixed values that
 * are directly expressed in the source code rather than computed.
 */
final class Literals extends AstNode instanceof LiteralsImpl { }

/**
 * An array literal in the AST.
 * 
 * Represents an array literal in the Bicep language, which is a comma-separated 
 * list of expressions enclosed in square brackets, such as `[1, 2, 3]` or 
 * `['a', 'b', 'c']`. Arrays can contain elements of different types.
 */
class Array extends Literals instanceof ArrayImpl {
  /**
   * Gets all elements of the array.
   * 
   * @return All expressions contained in the array literal
   */
  Expr getElements() { result = ArrayImpl.super.getElements() }

  /**
   * Gets the element at the specified index in the array.
   * 
   * @param index The zero-based index of the element to retrieve
   * @return The expression at the specified index in the array
   */
  Expr getElement(int index) { result = ArrayImpl.super.getElement(index) }
}

/**
 * A subscript expression in the AST.
 * 
 * Represents an array element access using the subscript notation, such as 
 * `array[0]` or `collection[indexExpr]`. A subscript expression consists of 
 * an array/collection and an index expression within square brackets.
 */
class SubscriptExpression extends Expr instanceof SubscriptExpressionImpl {
  /**
   * Gets the index expression of the subscript.
   * 
   * This is the expression inside the square brackets that determines which
   * element to access from the array or collection.
   */
  Expr getIndex() { result = SubscriptExpressionImpl.super.getIndex() }

  /**
   * Gets the identifier of the object being subscripted.
   * 
   * This is the name of the array or collection being accessed.
   */
  Idents getIdentifier() { result = SubscriptExpressionImpl.super.getObject() }

  /**
   * Gets the array that this subscript expression is indexing into.
   * 
   * This method attempts to resolve the array by finding a variable declaration
   * with a matching name in the same scope and retrieving its initializer if
   * that initializer is an array.
   * 
   * @return The array being indexed, if it can be determined
   */
  Array getArray() {
    exists(VariableDeclaration variable |
      variable.getEnclosingCfgScope() = this.getEnclosingCfgScope() and
      variable.getIdentifier().getName() = this.getIdentifier().getName()
    |
      result = variable.getInitializer()
    )
  }
}

/**
 * A boolean literal in the AST.
 * 
 * Represents a boolean literal in Bicep, which can have the value `true` or `false`.
 * Boolean literals are used in logical expressions, conditions, and other contexts
 * where a truth value is needed.
 */
class Boolean extends Literals instanceof BooleanImpl {
  /**
   * Gets the boolean value of this literal as a QL boolean.
   * 
   * @return `true` if the literal is the boolean value "true", `false` otherwise
   */
  boolean getBool() {
    exists(string bl | bl = BooleanImpl.super.getValue().toLowerCase() |
      bl = "true" and
      result = true
      or
      bl = "false" and
      result = false
    )
  }

  /**
   * Gets the boolean value of this literal.
   * 
   * This is an alias for getBool().
   * 
   * @return The boolean value of this literal
   */
  boolean getValue() {
    result = this.getBool()
  }
}

/**
 * An alias for the Boolean literal in the AST.
 * 
 * This provides a more descriptive name to match other literal classes.
 */
class BooleanLiteral = Boolean;

/**
 * A null literal in the AST.
 * 
 * Represents the `null` literal in Bicep, which denotes the absence of a value
 * or a reference that doesn't point to any object. Null literals are often used
 * to indicate optional values or to represent uninitialized state.
 */
final class NullLiteral extends Literals instanceof NullImpl { }

/**
 * A nullable return type literal in the AST.
 * 
 * Represents a function return type annotation that indicates the function may
 * return null in addition to values of another type. This typically appears in
 * function declarations and is denoted with a question mark after the type name.
 */
final class NullableReturnTypeLiteral extends Literals instanceof NullableReturnTypeImpl { }

/**
 * A number literal in the AST.
 * 
 * Represents a numeric literal in Bicep, such as `42`, `3.14`, or `-10`.
 * Number literals can be used in arithmetic expressions, array indices,
 * parameter values, and any other context where numeric values are expected.
 */
class Number extends Literals instanceof NumberImpl {
  /**
   * Gets the integer value of the number literal.
   * 
   * Note: This method currently only handles integer values. If the number
   * is a floating-point value, it will be converted to an integer.
   * 
   * @return The integer value of the number literal
   */
  int getValue() { result = NumberImpl.super.getValue().toInt() }
}

/**
 * An alias for StringLiteral.
 * 
 * This provides a shorter name for convenience.
 */
class String = StringLiteral;

/**
 * A string literal in the AST.
 * 
 * Represents a string literal in Bicep, which can be a single-quoted string,
 * double-quoted string, or a string with interpolated expressions. String literals
 * may contain plain text content and/or interpolated expressions (${...}).
 */
class StringLiteral extends Literals instanceof StringImpl {
  /**
   * Gets the value of the string literal.
   * 
   * This concatenates all the string contents and interpolated expressions
   * to form the complete string value. For interpolated expressions, their
   * string representation is included in the result.
   * 
   * @return The complete string value
   */
  string getValue() {
    result =
      concat(int index, string output |
        exists(StringContentLiteral content |
          content = StringImpl.super.getChild(index) and
          output = content.getValue()
        )
        or
        exists(Interpolation interpolation |
          interpolation = StringImpl.super.getChild(index) and
          output = interpolation.getValue()
        )
      |
        output order by index
      )
  }

  /**
   * Gets the interpolation expression at the specified index within the string.
   * 
   * String literals can contain embedded expressions using the ${...} syntax.
   * This method returns the interpolation at the given position in the string.
   * 
   * @param index The index of the interpolation to retrieve
   * @return The interpolation expression at that index
   */
  Interpolation getInterpolation(int index) { result = StringImpl.super.getChild(index) }
}

/**
 * A string content literal in the AST.
 * 
 * Represents a segment of plain text within a string literal, without any
 * interpolation. String literals are composed of one or more StringContentLiteral
 * instances, possibly interspersed with Interpolation expressions.
 */
class StringContentLiteral extends Literals instanceof StringContentImpl {
  /**
   * Gets the text value of this string content.
   * 
   * @return The literal text content
   */
  string getValue() { result = StringContentImpl.super.getValue() }
}
