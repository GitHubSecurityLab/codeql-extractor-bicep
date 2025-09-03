---
applyTo: 'ql/lib/codeql/bicep/frameworks/*.qll'
---

You are a CodeQL expert with extensive knowledge of the CodeQL language and its shared libraries.
Your task is to generate CodeQL libraries to add support for a framework or resource in the Bicep language.

## Bicep Resource URL

Given a Bicep resource URL, look at the `Resource format` section of the Bicep documentation to determine the resource type and version.
For each resource, generate a CodeQL module and class that represents the resource and its properties.

## Framework

Framework support should be added in the `ql/lib/codeql/bicep/frameworks/Microsoft` directory.
Framework is mapped to a Bicep template, which is a collection of resources and their properties.
Check the existing libraries for examples of how to structure the modules and classes.
Check and use `ql/lib/codeql/bicep/frameworks/Microsoft/General.qll` module for helping with the framework support.

Framework support should following these guidelines:

- A framework file should be created for each Bicep template.
- A module called the framework name should be created.
- Each resource in the Bicep template should be represented as a class extending the `AzureResource` class.
- A module for the resource properties should be created
- A class for the core resource property should be created extending the `ResourceProperties` class.
- Each Property of the resource should be represented as either a basic data type or a custom class.
  - Check if the class already exists in the `ql/lib/codeql/bicep/frameworks/Microsoft` module.
  - `String`, `Number`, `Boolean`, and `Null` should be used for basic data types.
- Each property class should have a `private parent` field that references the parent resource class.
  - The class constructor should use the follow pattern `private <PropertyClass> parent;` to define the parent resource.
- Each property class that isn't a basic data type must extend the `Object` class.
- Each property class must has a `toString()` method that returns a string representation of the property.
- Each proptery class must have the following predicates:
  - `get<PropertyName>()`: Returns the name of the resource.
  - `<PropertyName>()`: Returns the native codeql type of the property.
  - `has<PropertyName>()`: A predicate that holds if the property exists in the resource.
    - `exists(this.get<PropertyName>())`: Returns true if the property exists in the resource.
- Predicates should NOT return an Object type, but rather a class representing the property.

**Example Property class**

```codeql
class <PropertyClass> extends Object {
  private <ResourceClass> parent;

  /**
    * Constructor for the property class.
    */
  <PropertyClass>() {
    this = parent.getProperty("<property-name>");
  }

  string toString() { result = "<PropertyClass>" }
  // All predicates for the property
}
```
