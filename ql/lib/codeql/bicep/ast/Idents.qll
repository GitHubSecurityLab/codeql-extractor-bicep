private import AstNodes
private import Expr
private import internal.Idents
private import internal.Identifier
private import internal.PropertyIdentifier

/**
 *  A Idents AST node.
 */
abstract class Idents extends Expr instanceof IdentsImpl {
    abstract string getName();
}

/**
 *  A Identifier unknown AST node.
 */
class Identifier extends Idents instanceof IdentifierImpl {
    override string getName() { result = IdentifierImpl.super.getName() }
}

/**
 *  A PropertyIdentifier unknown AST node.
 */
class PropertyIdentifier extends Idents instanceof PropertyIdentifierImpl {
    override string getName() { result = PropertyIdentifierImpl.super.getName() }
}
