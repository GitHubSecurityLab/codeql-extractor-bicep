private import AstNodes
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

// Resource resolveResource(Expr expr) {
//   exists(Resource resource |
//     // Object having an id property needs to be resolved
//     // {resource.id}.id
//     exists(MemberExpr memexpr |
//       memexpr = expr.(Object).getProperty("id") and
//       memexpr.getObject().(Identifier).getName() = resource.getIdentifier().(Identifier).getName()
//     |
//       result = resource
//     )
//     or
//     exists(Identifier ident |
//       ident = expr and
//       ident.getName() = resource.getIdentifier().(Identifier).getName()
//     |
//       result = resource
//     )
//   )
// }


class Resource extends TResource {
  private ResourceDeclaration resource;

  Resource() { this = TResourceDeclaration(resource) }

  string getResourceType() {
    exists(StringLiteral sl | sl = resource.getName() | result = sl.getValue())
  }

  Expr getProperty(string name) {
    result = resource.getProperty(name)
  }

  string toString() { result = "Resource[" + resource.getIdentifier().getName() + "]" }

  string getAPrimaryQlClass() { result = "Resource" }
}

cached
private module Cached {
  cached
  newtype TResource = TResourceDeclaration(ResourceDeclaration rd)
}

private import Cached
