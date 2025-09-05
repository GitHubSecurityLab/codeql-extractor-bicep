private import AstNodes
private import codeql.Locations
private import Expr
private import Idents
private import Literals
private import internal.ResourceDeclaration
private import internal.ObjectProperty
private import internal.Object

/**
 * An object literal in the AST.
 * 
 * Represents an object in Bicep, which is a collection of key-value pairs enclosed 
 * in curly braces, such as `{ name: 'example', value: 42 }`. Objects are commonly 
 * used to define resource properties, parameter defaults, and return values.
 */
class Object extends Expr instanceof ObjectImpl {
  /**
   * Gets all properties defined in this object.
   * 
   * @return All property definitions in this object
   */
  ObjectProperty getProperties() { result = ObjectImpl.super.getProperties() }

  /**
   * Gets the property at the specified index.
   * 
   * @param i The index of the property to retrieve
   * @return The property at the specified index
   */
  ObjectProperty getProp(int i) { result = ObjectImpl.super.getProperty(i) }

  /**
   * Gets the value of a property by its name.
   * 
   * This method searches for a property with the given name and returns its value.
   * The property name can be specified either as an identifier or a string literal.
   * 
   * @param name The name of the property to look for
   * @return The value of the property, if found
   */
  Expr getProperty(string name) {
    exists(ObjectProperty property |
      property = this.getProperties() and
      (
        exists(Idents ident | ident = property.getName() | ident.getName() = name)
        or
        exists(StringLiteral str | str = property.getName() | str.getValue() = name)
      )
    |
      result = property.getValue()
    )
  }

  override string toString() { result = "Object" }
}

/**
 * An object property in the AST.
 * 
 * Represents a key-value pair in an object literal, consisting of a property name
 * and a property value. The property name can be an identifier or a string literal,
 * and the value can be any expression.
 */
class ObjectProperty extends Expr instanceof ObjectPropertyImpl {
  /**
   * Gets the name (key) of this property.
   * 
   * @return The expression representing the property name
   */
  Expr getName() { result = ObjectPropertyImpl.super.getName() }

  /**
   * Gets the value of this property.
   * 
   * @return The expression representing the property value
   */
  Expr getValue() { result = ObjectPropertyImpl.super.getValue() }
}

/**
 * A resource declaration in the AST.
 * 
 * Represents a resource declaration in Bicep, which defines an Azure resource
 * to be deployed. A resource declaration includes the resource type, an identifier
 * for referencing the resource, and an object containing the resource properties.
 */
class ResourceDeclaration extends AstNode instanceof ResourceDeclarationImpl {
  /**
   * Gets the identifier of the resource instance.
   * 
   * This is the symbolic name used to reference this resource elsewhere
   * in the Bicep file. For example, in `resource storageAccount '...' = { ... }`,
   * the identifier would be `storageAccount`.
   */
  Idents getIdentifier() { result = ResourceDeclarationImpl.super.getIdentifier() }

  /**
   * Gets the name literal of the resource type.
   * 
   * This is the string literal that specifies the Azure resource type.
   * For example, in `resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = { ... }`,
   * the name would be `'Microsoft.Storage/storageAccounts@2021-02-01'`.
   */
  Literals getName() { result = ResourceDeclarationImpl.super.getName() }

  /**
   * Gets the object that contains the resource properties.
   * 
   * This is the object literal that defines all the properties of the resource.
   * It includes attributes like name, location, properties, and other resource-specific
   * configuration settings.
   */
  Object getBody() { result = ResourceDeclarationImpl.super.getObject() }

  /**
   * Gets all properties defined in the resource body.
   * 
   * @return All property definitions in the resource body
   */
  ObjectProperty getProperties() { result = this.getBody().getProperties() }

  /**
   * Gets the value of a specific property in the resource body by name.
   * 
   * @param name The name of the property to look for
   * @return The value of the property, if found
   */
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

/**
 * A high-level representation of an Azure resource.
 * 
 * This class provides a more abstract view of Azure resources defined in Bicep,
 * with convenient methods to access common resource properties like type, name,
 * and parent-child relationships.
 */
class Resource extends TResource {
  private ResourceDeclaration resource;

  Resource() { this = TResourceDeclaration(resource) }

  /**
   * Gets the resource type of this Azure resource.
   * 
   * This is extracted from the resource type string literal in the resource declaration.
   * For example, from a declaration like `resource vm 'Microsoft.Compute/virtualMachines@2021-03-01'`,
   * this would return `"Microsoft.Compute/virtualMachines@2021-03-01"`.
   * 
   * @return The resource type as a string
   */
  string getResourceType() {
    exists(StringLiteral sl | sl = resource.getName() | result = sl.getValue())
  }

  /**
   * Gets the identifier of this resource.
   * 
   * This is the symbolic name used to reference this resource within the Bicep file.
   * 
   * @return The identifier of this resource
   */
  Identifier getIdentifier() { result = resource.getIdentifier() }

  /**
   * Gets the underlying resource declaration for this resource.
   * 
   * This provides access to the full AST node representing the resource declaration.
   * 
   * @return The ResourceDeclaration AST node
   */
  ResourceDeclaration getResourceDeclaration() { result = resource }

  /**
   * Gets the name of this resource as defined in its properties.
   * 
   * This is different from the identifier. It's the actual deployment name of the
   * resource that will be used in Azure, defined in the "name" property.
   * 
   * @return The resource name as a string
   */
  string getName() {
    exists(StringLiteral name |
      name = resource.getProperty("name") and
      result = name.getValue()
    )
  }

  /**
   * Gets the value of a specific property in this resource.
   * 
   * @param name The name of the property to look for
   * @return The value of the property, if found
   */
  Expr getProperty(string name) { result = resource.getProperty(name) }

  /**
   * Gets the parent resource of this resource, if any.
   * 
   * This attempts to resolve the "parent" property to find the parent resource.
   * Used for resources that have hierarchical relationships in Azure.
   * 
   * @return The parent resource, if one exists
   */
  Resource getParent() { result = resolveResource(this.getProperty("parent")) }

  /**
   * Gets a string representation of this resource.
   * 
   * @return A string representation of this resource
   */
  string toString() { result = resource.toString() }

  /**
   * Gets the primary QL class for this AST node.
   * 
   * @return The name of the QL class ("Resource")
   */
  string getAPrimaryQlClass() { result = "Resource" }

  /**
   * Gets the location of this resource in the source code.
   * 
   * @return The source location of this resource
   */
  Location getLocation() { result = resource.getLocation() }
}

cached
private module Cached {
  cached
  newtype TResource = TResourceDeclaration(ResourceDeclaration rd)
}

private import Cached
