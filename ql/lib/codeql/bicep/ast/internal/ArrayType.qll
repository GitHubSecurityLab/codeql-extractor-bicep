/**
 *  Internal implementation for ArrayType
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Type
private import Types

/**
 *  A ArrayType AST Node.
 */
class ArrayTypeImpl extends TArrayType, TypesImpl {
  private BICEP::ArrayType ast;

  override string getAPrimaryQlClass() { result = "ArrayType" }

  ArrayTypeImpl() { this = TArrayType(ast) }
  
  override string toString() { result = ast.toString() }
  
  override string getValue() { result = ast.toString() }

  TypeImpl getElementType() {
    toTreeSitter(result) = ast.getChild()
  }
}