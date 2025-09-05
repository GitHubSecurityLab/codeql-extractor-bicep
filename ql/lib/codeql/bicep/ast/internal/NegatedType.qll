/**
 *  Internal implementation for NegatedType
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Type
private import Types

/**
 *  A NegatedType AST Node.
 */
class NegatedTypeImpl extends TNegatedType, TypesImpl {
  private BICEP::NegatedType ast;

  override string getAPrimaryQlClass() { result = "NegatedType" }

  NegatedTypeImpl() { this = TNegatedType(ast) }

  override string toString() { result = ast.toString() }
  
  override string getValue() { result = ast.toString() }

  TypeImpl getNegatedType() {
    toTreeSitter(result) = ast.getChild()
  }
}