/**
 *  Internal implementation for OutputDeclaration
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Stmts
private import Idents
private import Expr
private import Type

/**
 *  A OutputDeclaration AST Node.
 */
class OutputDeclarationImpl extends TOutputDeclaration, StmtsImpl {
  private BICEP::OutputDeclaration ast;

  override string getAPrimaryQlClass() { result = "OutputDeclaration" }

  OutputDeclarationImpl() { this = TOutputDeclaration(ast) }

  override string toString() { result = ast.toString() }

  IdentsImpl getIdentifier() {
    toTreeSitter(result) = ast.getChild(0)
  }

  TypeImpl getType() {
    toTreeSitter(result) = ast.getChild(1)
  }

  ExprImpl getValue() {
    toTreeSitter(result) = ast.getChild(2)
  }
}