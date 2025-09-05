private import AstNodes
private import codeql.bicep.ast.AstNodes
private import TreeSitter
private import Expr

class TypesImpl extends ExprImpl, TTypes {
    abstract string getValue();
}