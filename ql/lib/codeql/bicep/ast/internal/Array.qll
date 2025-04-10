/**
 *  Internal implementation for Array
 *
 *  WARNING: this file is generated, do not edit manually
 */

private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Expr

/**
 *  A Array AST Node.
 */
class ArrayImpl extends TArray, AstNode {
  private BICEP::Array ast;

  override string getAPrimaryQlClass() { result = "Array" }

  ArrayImpl() { this = TArray(ast) }

  override string toString() { result = ast.toString() }

  ExprImpl getElements() { toTreeSitter(result) = ast.getChild(_) }

  ExprImpl getElement(int index) { toTreeSitter(result) = ast.getChild(index) }
}
