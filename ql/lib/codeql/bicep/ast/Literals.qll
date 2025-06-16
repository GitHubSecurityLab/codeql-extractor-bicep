/**
 * Literals in the AST.
 *
 * This module defines CodeQL classes for representing literal values in the Bicep AST, including arrays, booleans, nulls, nullable return types, numbers, strings, and string content.
 */

private import AstNodes
private import Expr
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

/**
 * A literal node in the Bicep AST.
 *
 * This is the base class for all literal values (arrays, booleans, nulls, numbers, strings, etc.).
 */
final class Literals extends AstNode instanceof LiteralsImpl { }

/**
 * An array literal node in the Bicep AST.
 *
 * Represents an array value, providing access to its elements.
 */
class Array extends Literals instanceof ArrayImpl {
  /**
   * Gets all elements of the array as expressions.
   */
  Expr getElements() { result = ArrayImpl.super.getElements() }

  /**
   * Gets the element at the specified index in the array.
   */
  Expr getElement(int index) { result = ArrayImpl.super.getElement(index) }
}

/**
 * A boolean literal node in the Bicep AST.
 *
 * Represents a boolean value (`true` or `false`).
 */
class Boolean extends Literals instanceof BooleanImpl {
  /**
   * Gets the boolean value represented by this node.
   */
  boolean getBool() {
    exists(string bl |
      bl = BooleanImpl.super.getValue().toLowerCase() and
      bl = "true" and
      result = true
      or
      bl = "false" and
      result = false
    )
  }
}

/**
 * An alias for the Boolean literal in the AST.
 */
class BooleanLiteral = Boolean;

/**
 * A null literal node in the Bicep AST.
 *
 * Represents a `null` value.
 */
final class NullLiteral extends Literals instanceof NullImpl { }

/**
 * A nullable return type literal node in the Bicep AST.
 *
 * Represents a nullable return type value.
 */
final class NullableReturnTypeLiteral extends Literals instanceof NullableReturnTypeImpl { }

/**
 * A number literal node in the Bicep AST.
 *
 * Represents a numeric value.
 */
class Number extends Literals instanceof NumberImpl {
  /**
   * Gets the integer value represented by this node.
   */
  int getValue() { result = NumberImpl.super.getValue().toInt() }
}

/**
 * A string literal node in the Bicep AST.
 *
 * Represents a string value.
 */
class StringLiteral extends Literals instanceof StringImpl {
  /**
   * Gets the string value represented by this node.
   */
  string getValue() {
    exists(StringContentLiteral content |
      content = this.getAChild() and
      result = content.getValue()
    )
  }
}

/**
 * A string content literal node in the Bicep AST.
 *
 * Represents the content of a string literal.
 */
class StringContentLiteral extends Literals instanceof StringContentImpl {
  /**
   * Gets the string content value represented by this node.
   */
  string getValue() { result = StringContentImpl.super.getValue() }
}
