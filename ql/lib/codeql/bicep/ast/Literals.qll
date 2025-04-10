/**
 * Literals in the AST.
 */

private import AstNodes
private import Expr
private import internal.AstNodes
private import internal.TreeSitter
private import internal.Literals
private import internal.Array
private import internal.Null
private import internal.NullableReturnType
private import internal.Number
private import internal.String
private import internal.StringContent

/**
 * A literal in the AST.
 */
final class Literals extends AstNode instanceof LiteralsImpl { }

/**
 *  A Array unknown AST node.
 */
class Array extends Literals instanceof ArrayImpl {
  Expr getElements() {
    result = ArrayImpl.super.getElements()
  }

  Expr getElement(int index) {
    result = ArrayImpl.super.getElement(index)
  }
}

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
  int getValue() {
    result = NumberImpl.super.getValue().toInt()
  }
}


/**
 * A String literal in the AST.
 */
class StringLiteral extends Literals instanceof StringImpl {
  string getValue() {
    exists(StringContentLiteral content |
      content = this.getAChild() and
      result = content.getValue()
    )
  }
}

/**
 * A StringContent literal in the AST.
 */
class StringContentLiteral extends Literals instanceof StringContentImpl {
  string getValue() { result = StringContentImpl.super.getValue() }
}
