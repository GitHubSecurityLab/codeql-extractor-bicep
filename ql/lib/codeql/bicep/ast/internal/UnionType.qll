/**
 *  Internal implementation for UnionType
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Types

/**
 *  A UnionType AST Node.
 */
class UnionTypeImpl extends TUnionType, TypesImpl {
  private BICEP::UnionType ast;

  override string getAPrimaryQlClass() { result = "UnionType" }

  UnionTypeImpl() { this = TUnionType(ast) }

  override string toString() { result = ast.toString() }
  
  override string getValue() { result = ast.toString() }



}