/**
 *  Internal implementation for ObjectProperty
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Expr

/**
 *  A ObjectProperty AST Node.
 */
class ObjectPropertyImpl extends TObjectProperty, AstNode {
  private BICEP::ObjectProperty ast;

  override string getAPrimaryQlClass() { result = "ObjectProperty" }

  ObjectPropertyImpl() { this = TObjectProperty(ast) }

  override string toString() { result = ast.toString() }

  ExprImpl getName() { toTreeSitter(result) = ast.getChild(0) }
  
  ExprImpl getValue() { toTreeSitter(result) = ast.getChild(1) }
}