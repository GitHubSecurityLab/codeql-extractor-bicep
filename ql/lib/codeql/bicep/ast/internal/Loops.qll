/**
 * Loop statements in Bicep code.
 * 
 * Bicep supports for loops for iterating over collections, ranges, or object properties.
 * These loops are used to create multiple instances of resources, variables, or other elements.
 */

private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Idents
private import Stmts
private import Expr

abstract class LoopsImpl extends AstNode, TLoops {
  override string getAPrimaryQlClass() { result = "Loops" }

  abstract ExprImpl getCondition();

  abstract ExprImpl getBody();

  abstract IdentsImpl getInitializer();
}
