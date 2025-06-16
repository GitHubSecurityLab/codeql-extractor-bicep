/**
 * AST nodes for Bicep resources and objects.
 *
 * This module defines CodeQL classes for representing Bicep resource declarations, objects, and object properties in the AST.
 */

private import AstNodes
private import codeql.Locations
private import Expr
private import Idents
private import Literals
private import internal.ResourceDeclaration
private import internal.ObjectProperty
private import internal.Object

/**
 * An object literal node in the Bicep AST.
 *
 * Represents an object value, providing access to its properties.
 */
class Object extends Expr instanceof ObjectImpl {
  /**
   * Gets all properties of the object as `ObjectProperty` nodes.
   */
  ObjectProperty getProperties() { result = ObjectImpl.super.getProperties() }

  /**
   * Gets the property at the specified index in the object.
   */
  ObjectProperty getProp(int i) { result = ObjectImpl.super.getProperty(i) }

  /**
   * Gets the value of the property with the given name, if it exists.
   */
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
 * An object property node in the Bicep AST.
 *
 * Represents a property of an object, with a name and value.
 */
class ObjectProperty extends Expr instanceof ObjectPropertyImpl {
  /**
   * Gets the name of the property as an identifier.
   */
  Idents getName() { result = ObjectPropertyImpl.super.getName() }

  /**
   * Gets the value of the property as an expression.
   */
  Expr getValue() { result = ObjectPropertyImpl.super.getValue() }
}

/**
 * A resource declaration node in the Bicep AST.
 *
 * Represents a resource declaration, including its identifier, name, and body.
 */
class ResourceDeclaration extends AstNode instanceof ResourceDeclarationImpl {
  /**
   * Gets the identifier of the resource instance.
   */
  Idents getIdentifier() { result = ResourceDeclarationImpl.super.getIdentifier() }

  /**
   * Gets the name of the resource instance as a literal.
   */
  Literals getName() { result = ResourceDeclarationImpl.super.getName() }

  /**
   * Gets the object that represents the resource body.
   */
  Object getBody() { result = ResourceDeclarationImpl.super.getObject() }

  /**
   * Gets all properties of the resource body as `ObjectProperty` nodes.
   */
  ObjectProperty getProperties() { result = this.getBody().getProperties() }

  /**
   * Gets the value of the property with the given name from the resource body.
   */
  Expr getProperty(string name) { result = this.getBody().getProperty(name) }
}

/**
 * Resolves a resource from an expression, if possible.
 *
 * @param expr The expression to resolve as a resource.
 * @return The resolved resource, if found.
 */
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

/**
 * A resource in the Bicep AST.
 *
 * Provides access to resource type, identifier, name, properties, parent, and location.
 */
class Resource extends TResource {
  private ResourceDeclaration resource;

  /**
   * Constructs a resource from a resource declaration.
   */
  Resource() { this = TResourceDeclaration(resource) }

  /**
   * Gets the resource type as a string.
   */
  string getResourceType() {
    exists(StringLiteral sl | sl = resource.getName() | result = sl.getValue())
  }

  /**
   * Gets the identifier of the resource.
   */
  Identifier getIdentifier() {
    result = resource.getIdentifier()
  }

  /**
   * Gets the name of the resource as a string.
   */
  string getName() {
    exists(StringLiteral name |
      name = resource.getProperty("name") and
      result = name.getValue()
    )
  }

  /**
   * Gets the value of the property with the given name from the resource.
   */
  Expr getProperty(string name) { result = resource.getProperty(name) }

  /**
   * Gets the parent resource, if any.
   */
  Resource getParent() { result = resolveResource(this.getProperty("parent")) }

  /**
   * Gets a string representation of the resource.
   */
  string toString() { result = resource.toString() }

  /**
   * Gets the primary QL class name for the resource.
   */
  string getAPrimaryQlClass() { result = "Resource" }

  /**
   * Gets the location of the resource in the source code.
   */
  Location getLocation() { result = resource.getLocation() }
}

/**
 * Cached resource type for efficient lookups.
 */
cached
private module Cached {
  cached
  newtype TResource = TResourceDeclaration(ResourceDeclaration rd)
}

private import Cached
