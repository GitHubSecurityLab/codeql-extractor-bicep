---
mode: 'agent'
---

Given a AST class or set of classes, update and implement both the public and internal classes.

**Guidelines:**

- Always check the CodeQL TreeSitter.qll implementation first when checking the internal implementation to ensure consistency with the AST implementation.
- Update the AST Node Type if necessary, following the guidelines in the "AST Nodes Types" section.
- Always check and update the internal implementations of classes before updating the public classes.
- Internal implementations should never return the TreeSitter class directly, always import and use `Impl` types.

## Read TreeSitter Implementation

Before implementing any AST classes or predicates, you should first read the CodeQL `TreeSitter.qll` implementation.
This will help understand how the AST classes are implemented and how they relate to the TreeSitter implementation.
The TreeSitter implementation is stored in the `TreeSitter.qll` file in the `ql/lib/codeql/bicep/ast/internal` directory.

## AST Nodes Types

If you are asked to update the AstNode type to include a new type, you should follow the guidelines below.

- Read the `AstNodes.qll` file in the `ql/lib/codeql/bicep/ast/internal` directory to understand how the AstNode type is implemented.
- SuperTypes are `TExpr`, `TStmts`, `TCallable`, `TLiterals`, `TConditionals`, etc.
- Add the AST Node Type (e.g. `T${AstNode}`) to the SuperType
- Update the `AstNodes.qll` file to include the new type.
- Ensure that the new type is consistent with the existing types in the `AstNodes.qll` file

**Example:**

```codeql
class TExpr = ${AstNode1} or ${AstNode2} or ${AstNode3} or ...;
```

## Internal Abstract Syntax Tree Implementation

If you are asked to implementation any internal AstNode classes or predicates, you should follow the guidelines below.
Internal classes and predicates should be stored in the `ql/lib/codeql/bicep/ast/internal/${AST_NODE}.qll` directory.

The following rules should be followed when implementing AST classes and predicates:

- Internal implementations should never return the TreeSitter class directly, always import and use `Impl` types
- All internal classes should extend a SuperType class which can be found in `ast/internal/${SuperType}.qll` file.
  - If the SuperType isn't known, check the `internal/AstNodes.qll`
- Core logic should be in the internal class and reflected in the public facing class
- Used named prediates the Tree Sitter class should be used in the internal implementation.
  - If only `getChild(i)` is avalible, look at the Tree Sitter grammar and check which possition the field is in.
- Include all of the correct imports for Impl classes
- Convert TreeSitter classes to CodeQL classes by using the `toTreeSitter()` method.
  - Example: `toTreeSitter(result) = ast.<TreeSitterPredicate>()`
- Internal classes can call prediates from the `ast` by using the `toTreeSitter(result) = ast.<predicate>()` syntax.
- Update internal implemention to directly use predicates from Tree Sitter module by using the ast in the class
- include import statements for Impl classes, excluding the `Impl`
  - For example: `private import ${CLASS}`

**Example getting name field in the TreeSitter module:**

```codeql
class ${AstNode}Impl extends ${AstNodeSuperType} {
  private Bicep::${TREESITTER_NODE} ast;
  
  ${ReturnType}Impl <predicate_name>() {
    toTreeSitter(result) = ast.get<name>()
 }
}
```

## Public Abstract Syntax Tree Implementation

The public user facing classes and predicates should be implemented in the `ql/lib/codeql/bicep/ast/${AST_NODE}.qll` directory.
The public classes and predicates should follow the guidelines below:

- Public classes should extend a base class such as:
  - `Expr`: for expressions
  - `Literals`: literals in the language
  - `Stmts`: statements in the language
  - `Calls`: for function / method calls
  - `Callable`: for functions, methods, and lambdas definitions
  - `Conditionals`: for if, switch, and other conditional statements
- Public classes should use `instanceof ${AstNode}Impl` to check if the internal implementation is used.
- Implement all abstract predicates from the base class
- Predicates that are defined in the internal implementation should be used in the public implementation.
  - Using the `${AstNode}Impl.super.${predicate}` syntax.
  - Example: `Type getType() { result = TypeImpl.super.getType() }
- Public classes should be in the base class 
- Public classes should define a `getAPrimaryQlClass()` predicate that returns the primary CodeQL class name.
- Public classes should define a `toString()` predicate that returns a string representation of the class.
- All public classes and predicates should be documented with examples and descriptions.

**Example:**

```codeql
class ${AstNode} extends Expr instanceof ${AstNode}Impl {

  /** Returns the name of the AST node. */
  ${ReturnType} <predicate_name>() {
    result = ${AstNode}Impl.super.<predicate_name>();
  }
}
```
