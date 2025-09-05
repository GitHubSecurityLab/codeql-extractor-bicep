/**
 *  Internal implementation for ForStatement
 */

private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Stmts
private import Loops
private import Expr
private import Idents

/**
 *  A ForStatement AST Node.
 */
class ForStatementImpl extends TForStatement, LoopsImpl {
  private BICEP::ForStatement ast;

  override string getAPrimaryQlClass() { result = "ForStatement" }

  ForStatementImpl() { this = TForStatement(ast) }

  override string toString() { result = ast.toString() }
  
  override ExprImpl getCondition() {
    // In Bicep, for loops don't have explicit conditions like other languages,
    // but the loop enumeration object can be considered the condition
    // We use child index 1 which should be the loop condition/enumeration
    toTreeSitter(result) = ast.getChild(1)
  }

  override ExprImpl getBody() {
    // The body is the part to execute for each iteration
    toTreeSitter(result) = ast.getBody()
  }

  override IdentsImpl getInitializer() {
    // The initializer is the loop variable
    toTreeSitter(result) = ast.getInitializer()
  }
}
