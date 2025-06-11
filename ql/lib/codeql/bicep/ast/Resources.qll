private import AstNodes
private import codeql.Locations
private import Expr
private import Idents
private import Literals
private import internal.ResourceDeclaration
private import internal.ObjectProperty
private import internal.Object

/**
 *  A Object unknown AST node.
 */
class Object extends Expr instanceof ObjectImpl {
  ObjectProperty getProperties() { result = ObjectImpl.super.getProperties() }

  ObjectProperty getProp(int i) { result = ObjectImpl.super.getProperty(i) }

  Expr getProperty(string name) {
    exists(ObjectProperty property |
      property = this.getProperties() and
      property.getName().getName() = name
    |
      result = property.getValue()
    )
  }
}

/**
 *  A ObjectProperty unknown AST node.
 */
class ObjectProperty extends Expr instanceof ObjectPropertyImpl {
  Idents getName() { result = ObjectPropertyImpl.super.getName() }

  Expr getValue() { result = ObjectPropertyImpl.super.getValue() }
}

/**
 *  A ResourceDeclaration unknown AST node.
 */
class ResourceDeclaration extends AstNode instanceof ResourceDeclarationImpl {
  /**
   *  The name of the resource instance
   */
  Idents getIdentifier() { result = ResourceDeclarationImpl.super.getIdentifier() }

  /**
   *  The name of the resource instance.
   */
  Literals getName() { result = ResourceDeclarationImpl.super.getName() }

  /**
   *  The object that represents the resource.
   */
  Object getBody() { result = ResourceDeclarationImpl.super.getObject() }

  ObjectProperty getProperties() { result = this.getBody().getProperties() }

  Expr getProperty(string name) { result = this.getBody().getProperty(name) }
}

Resource resolveResource(Expr expr) {
  exists(ResourceDeclaration resource |
    // Object having an id property needs to be resolved
    // {resource.id}.id
    exists(MemberExpr memexpr |
      memexpr = expr.(Object).getProperty("id") and
      memexpr.getNamespace().(Idents).getName() = resource.getIdentifier().getName()
    |
      result = TResourceDeclaration(resource)
    )
    or
    exists(Identifier ident |
      ident = expr and
      ident.getName() = resource.getIdentifier().(Identifier).getName()
    |
      result = TResourceDeclaration(resource)
    )
  )
}

class Resource extends TResource {
  private ResourceDeclaration resource;

  Resource() { this = TResourceDeclaration(resource) }

  string getResourceType() {
    exists(StringLiteral sl | sl = resource.getName() | result = sl.getValue())
  }

  string getName() {
    exists(StringLiteral name |
      name = resource.getProperty("name") and
      result = name.getValue()
    )
  }

  Expr getProperty(string name) { result = resource.getProperty(name) }

  Resource getParent() { result = resolveResource(this.getProperty("parent")) }

  string toString() { result = resource.toString() }

  string getAPrimaryQlClass() { result = "Resource" }

  Location getLocation() { result = resource.getLocation() }
}

cached
private module Cached {
  cached
  newtype TResource = TResourceDeclaration(ResourceDeclaration rd)
}

private import Cached
