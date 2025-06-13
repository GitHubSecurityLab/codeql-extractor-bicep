/**
 *  Internal implementation for Type
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import ReservedWord

/**
 *  A Type AST Node.
 */
class TypeImpl extends TType, AstNode {
  private BICEP::Type ast;

  override string getAPrimaryQlClass() { result = "Type" }

  TypeImpl() { this = TType(ast) }

  override string toString() { result = ast.toString() }

  string getType() {
    result = ast.getChild().toString()
  }
}