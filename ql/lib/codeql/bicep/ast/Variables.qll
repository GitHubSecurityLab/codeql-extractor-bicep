/**
 *  Bicep variable declarations.
 */
private import bicep
private import AstNodes
private import Idents
private import Stmts
private import codeql.bicep.controlflow.BasicBlocks as BasicBlocks
private import codeql.bicep.controlflow.ControlFlowGraph
// Internal
private import internal.VariableDeclaration

/**
 *  A VariableDeclaration unknown AST node.
 */
class VariableDeclaration extends AstNode instanceof VariableDeclarationImpl {
    /**
     * Gets the identifier of the variable declaration.
     */
    Idents getIdentifier() { result = VariableDeclarationImpl.super.getIdentifier() }
    
    /**
     * Gets the initializer expression of the variable declaration.
     */
    Expr getInitializer() { result = VariableDeclarationImpl.super.getInitializer() }
}
