/**
 *  Internal implementation for Identifier
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Idents

/**
 *  A Identifier AST Node.
 */
class IdentifierImpl extends TIdentifier, IdentsImpl {
  private BICEP::Identifier ast;

  override string getAPrimaryQlClass() { result = "Identifier" }

  IdentifierImpl() { this = TIdentifier(ast) }

  override string toString() { result = ast.toString() }

  override string getName() { result = ast.getValue() }
}