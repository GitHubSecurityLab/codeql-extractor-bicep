/**
 *  Internal implementation for Type
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Types

/**
 *  A Type AST Node.
 */
class TypeImpl extends TType, TypesImpl {
  private BICEP::Type ast;

  override string getAPrimaryQlClass() { result = "Type" }

  TypeImpl() { this = TType(ast) }

  override string toString() { result = ast.toString() }
  
  override string getValue() { result = ast.toString() }

  string getType() {
    result = ast.getChild().toString()
  }
}