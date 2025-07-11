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
 * A literal in the AST.
 */
final class Literals extends AstNode instanceof LiteralsImpl { }

/**
 *  A Array unknown AST node.
 */
class Array extends Literals instanceof ArrayImpl {
  Expr getElements() { result = ArrayImpl.super.getElements() }

  Expr getElement(int index) { result = ArrayImpl.super.getElement(index) }
}

/**
 * A SubscriptExpression expression in the AST.
 */
class SubscriptExpression extends Expr instanceof SubscriptExpressionImpl {
  /**
   * Gets the index of the subscript expression.
   */
  Expr getIndex() { result = SubscriptExpressionImpl.super.getIndex() }

  /**
   * Gets the object of the subscript expression.
   */
  Idents getIdentifier() { result = SubscriptExpressionImpl.super.getObject() }

  /**
   * Gets the array that this subscript expression is indexing into.
   * This is equivalent to the variable declaration that contains the
   * subscript expression.
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
 *  A Boolean unknown AST node.
 */
class Boolean extends Literals instanceof BooleanImpl {
  boolean getBool() {
    exists(string bl | bl = BooleanImpl.super.getValue().toLowerCase() |
      bl = "true" and
      result = true
      or
      bl = "false" and
      result = false
    )
  }

  boolean getValue() {
    result = this.getBool()
  }
}

/**
 * An alias for the Boolean literal in the AST.
 */
class BooleanLiteral = Boolean;

/**
 * A Null literal in the AST.
 */
final class NullLiteral extends Literals instanceof NullImpl { }

/**
 * A NullableReturnType literal in the AST.
 */
final class NullableReturnTypeLiteral extends Literals instanceof NullableReturnTypeImpl { }

/**
 *  A Number unknown AST node.
 */
class Number extends Literals instanceof NumberImpl {
  int getValue() { result = NumberImpl.super.getValue().toInt() }
}

class String = StringLiteral;

/**
 * A String literal in the AST.
 */
class StringLiteral extends Literals instanceof StringImpl {
  /**
   * Gets the value of the string literal.
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

  Interpolation getInterpolation(int index) { result = StringImpl.super.getChild(index) }
}

/**
 * A StringContent literal in the AST.
 */
class StringContentLiteral extends Literals instanceof StringContentImpl {
  string getValue() { result = StringContentImpl.super.getValue() }
}
