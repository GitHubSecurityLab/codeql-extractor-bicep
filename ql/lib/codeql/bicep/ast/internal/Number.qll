/**
 *  Internal implementation for Number
 *
 *  WARNING: this file is generated, do not edit manually
 */

private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Literals

/**
 *  A Number AST Node.
 */
class NumberImpl extends TNumber, LiteralsImpl {
  private BICEP::Number ast;

  override string getAPrimaryQlClass() { result = "Number" }

  NumberImpl() { this = TNumber(ast) }

  override string toString() { result = ast.toString() }

  override string getValue() { result = ast.getValue() }
}
