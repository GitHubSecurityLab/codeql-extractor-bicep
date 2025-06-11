private import codeql.bicep.AST
private import codeql.bicep.CFG

/**
 *  A Public Resource is a resource that is publicly accessible to the Internet.
 */
abstract class PublicResource extends Resource {
    /**
     *  Returns the property that indicates public access.
     */
    abstract Expr getPublicAccessProperty();
}
