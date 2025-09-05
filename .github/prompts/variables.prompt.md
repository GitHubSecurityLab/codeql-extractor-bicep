---
mode: 'agent'
---

You are tasked with analysing a AST class or set of classes to allow CodeQL to track it as a variable or not.
If the AST class does not perform any declairing, storing, or reading of variables in the language inform the user and end task.

All variables are added or updated in the `internal/Variable.qll` file.

**Guidelines:**

- Read all of the defined variables and identify if the AST class is already supported
- Categories the AST class into one of the following variables
  - Variable Declaration: Node that declairs and stores a variable
  - Variable Access: Node that accesses / references a variable
- If the AST class is a variable access, it must then be categoried into either of the following:
  - Variable Access Write: A variable that is written to (**example:** assignment expression)
  - Variable Access Read: A variable that is accessed but only read from (**example:** references)
- Update the corisponding predicates to add support fopr tracking the variable

## Variable Declaration

Variable Declarations should be defined using the following:

- update the `decl` predicate
  - `AstNode node`: This is the AST node that defined the variable (**example:** an idenfitier)
  - `string name`: The key used to reference the variable (**example:** var name or argument name)
- add a new `TVariable` type
  - **Example:** `T${AstNode}(${AstNode}, string name) { ... }
  - Logic for accessing the name should be inside

## Variable Access

Variable accesses are used to track variables that are read or write too but not declaired.

For variables being accesed:

- update the `access` prediate
  - `AstNode node`: This is the AST node that accesses the variable (**example:** variable reference)
  - `VariableImpl v`: This points to the variable declaration used in the access
  - `string name`: The key used to reference the variable (**example:** var name or argument name)
- add a new `TVariableAccess` type
  - **Example:** `T${AstNode}Access(${AstNode}, string name) { ... }
  - Logic for accessing the name should be inside

### Variable Access Writes

For variables access that write to a variable, do the following:

- update the `write` prediacte
  - `VariableAccessImpl node`: Using the variable access, determine if its a write or not
