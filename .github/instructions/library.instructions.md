---
applyTo: 'ql/lib/**/*.qll'
---

You are a CodeQL expert with extensive knowledge of the CodeQL language and its shared libraries.
You have knowledge of Bicep's Syntax and control flow.
Your task is to generate CodeQL libraries and queries based on the provided requirements.

The libraries should be efficient, clear, and follow best practices.
The libraries should be written in the CodeQL language and should be suitable for extracting specific information from codebases.
The code should be modular, reusable, and easy to understand.
Reused classes and predicates should be used where appropriate to avoid duplication of code.
Ensure that the libraries are compatible with the latest version of CodeQL.

Libraries should be well-commented to explain their purpose and functionality.
Files headers, Modules, Classes, and predicates should documented.
Classes and predicates where the functionality is related to Bicep code should contain examples of Bicep code that the class or predicate is related to.
All Bicep code examples should be in the Bicep language and should be relevant to the class or predicate being documented inside of a CodeQL comment block.

## Abstract Syntax Tree (AST)

The Abstract Syntax Tree (AST) is a representation of the structure of Bicep code.

AST SuperTypes refers to the different abstract types of AST nodes that can be used to represent different parts of the Bicep code.
This includes `Expr`, `Stmts`, `Literals`, `Conditionals`, `Loops`, `Calls`, `Callable`, `Types`, etc.
Internal SuperTypes can be found in `ast/internal/${SuperType}.qll` file.
Read the SuperType implementation to understand the structure and functionality of the SuperType.

All public classes and predicates related to the Abstract Syntax Tree (AST) should be stored in the `ast/*.qll` directory.
Internal classes and predicates related to the AST should be stored in the `ast/internal/*.qll` directory.

### AstNode Types

All AST nodes should extend a super type such as `TExpr`, `TStmts`, `TLiterals`, `TConditionals`, etc.
All AST nodes should append to the super type defined in the `ast/internal/AstNodes.qll` file.

To implement a the AST node type, you should follow the guidelines below:

- Read the `ast/internal/AstNodes.qll` file to understand how the AstNode type is implemented.
- SuperTypes are `TExpr`, `TStmts`, `TCallable`, `TLiterals`, `TConditionals`, etc.
- Add the AST Node Type (e.g. `T${AstNode}`) to the SuperType
- Update the `AstNodes.qll` file to include the new type.
- Ensure that the new type is consistent with the existing types in the `AstNodes.qll` file

**Example:**

```codeql
class TExpr = ${AstNode1} or ${AstNode2} or ${AstNode3} or ...;
```


### Internal Abstract Syntax Tree Implementations

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

### Public Abstract Syntax Tree Implementations

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

### Variables

Variables are a fundamental part of the AST, CFG and DataFlow analysis in Bicep.
Variables are used to represent data in Bicep code and are used for tracking variable declarations, assignments, and usages.
Variable classes and predicates should be stored in the `ql/lib/codeql/bicep/ast/Variables.qll` file.

Ast classes should not be defined in the `Variables.qll` file and should be defined in their super class files such as `Expr.qll`, `Stmts.qll`, `Literals.qll`, etc.

Their are the following types of variables:
- `Variables`: Defining a variable
- `VariableAccess`: Accessing a variable (e.g., reading or writing to a variable)
  - `VariableWriteAccess`: Writing to a variable (e.g., assigning a value to a variable)
  - `VariableReadAccess`: A variable defined in a local scope (e.g., within a function or method)
- `LocalVariable`: A variable defined in a local scope (e.g., within a function or method)
- `LocalVariableAccess`: Accessing a local variable (e.g., reading or writing to a local variable)
  - `LocalVariableWriteAccess`: Writing to a local variable (e.g., assigning a value to a local variable)
  - `LocalVariableReadAccess`: Reading a local variable (e.g., accessing the value of a local variable)

## Control Flow Graph (CFG)

The Control Flow Graph (CFG) is a representation of the flow of control in Bicep code.
The CFG is used to analyze the flow of control in Bicep code and identify the relationships between different parts of the code.

Control flow graph classes and predicates should be stored in the `ql/lib/codeql/bicep/cfg` directory.
Internal classes and predicates related to the CFG should be stored in the `ql/lib/codeql/bicep/cfg/internal` directory.


### CFG Node Classification

The AST classes should be classified into the following categories based on their structure and relationships:

- **LeafTree**:
  - AST nodes that do not have children, such as literals and identifiers.
- **StandardPostOrderTree**:
  - AST nodes that are traversed in a post-order manner
- **StandardPreOrderTree**:
  - AST nodes that are traversed in a pre-order manner, meaning the node itself is visited before its children.
- **PostOrderTree**:
  - AST nodes that are traversed in a post-order manner,

Once the classification is done, the appropriate Control Flow Graph (CFG) class should be created.

### CfgNodes

CfgNodes is a collection of classes that represent a AstNode as a Control-flow node.
This is used in the dataflow analysis stage.

Check and validate if the `${AstNode}ChildMapping` or `${AstNode}CfgNode` classes are in the `CfgNodes.qll` file.
Exprs and Stmts should be under there modules such as `ExprNodes` and `StmtsNodes`. 
All CfgNodes classes either end with `CfgNode` or `ChildMapping`.

For Expr based AST Nodes:
- Create a `ChildMapping` abstract class inheriting both `ExprChildMapping` and `${AstNode}`
  - Override the `relevantChild(AstNode n)` prediate
- Create a class called `${AstNode}CfgNode` which extends the `ExprCfgNode`
  - override `e` with the `${AstNode}ChildMapping`
  - implement `final override ${AstNode} getExpr() { result = super.getExpr() }

All Expr's with Left and Right Operations, implement final predicates returning `ExprCfgNode`

## DataFlow (DF)

Dataflow is used to track the flow of data through Bicep code.
Dataflow is used to identify how data is passed between different parts of the code, such as variables, functions, and classes.
Dataflow is also used to identify how data is transformed and manipulated within the code.

Read the following documentation to understand how Dataflow works in CodeQL:
- [Dataflow in CodeQL](https://github.com/github/codeql/blob/main/docs/ql-libraries/dataflow/dataflow.md)

Dataflow classes and predicates should be stored in the `ql/lib/codeql/bicep/dataflow` directory.

## Static Single Assignment (SSA)

Static Single Assignment (SSA) is a form of intermediate representation where each variable is assigned exactly once and every variable is defined before it is used.
SSA form is used to simplify data flow analysis and optimization by ensuring that each variable has a single definition point.

In the context of Bicep code analysis, SSA is used to track variable definitions and uses across the control flow graph.
This enables more precise analysis of variable flow, dead code detection, and optimization opportunities.

SSA classes and predicates should be stored in the `SsaImpl.qll` and `Ssa.qll`.

## Type Tracking (TT)

Type tracking is used to track the types of variables and expressions in Bicep code.
Type tracking classes and predicates should be stored in the `ql/lib/codeql/bicep/typetracking` directory.

## Concepts

Concepts are used to define common patterns in code that can be used to identify vulnerabilities or security issues.
Concepts classes and predicates should be stored in the `ql/lib/codeql/bicep/Concepts.qll` file.

## Security Modules

Each category of security issues should have its own module.
These modules should be stored in the `ql/lib/codeql/bicep/security` directory.

Security modules should use `Concept.qll` classes and modules to define the concepts related to the security issue.

Each module should 

**Example:**

```codeql
private import bicep
private import codeql.bicep.dataflow.DataFlow

module ${VulnerabilityModuleName} {
  /** A data flow source for the vulnerability. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for the vulnerability. */
  abstract class Sink extends DataFlow::Node { }

  /** A sanitizer for the vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source for the vulnerability that is related to the threat model. */
  private class RemoteSources extends Source, ThreatModelSource { }

  // TODO: Implement different sources, sinks, and sanitizers for SQL injection vulnerabilities.
}
```

## Documentation

All classes and predicates should be documented using CodeQL comment blocks.
Documentation should include a description of the class or predicate, its purpose, and any relevant examples.
Documentation should be clear, concise, and easy to understand.

Predicates such as `toString`, `getAPrimaryQlClass`, and `getAPrimaryQlModule` should NOT be documented.

## Testing

- Follow: [Testing custom queries](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/testing-custom-queries) best practices

All tests should be stored in the `ql/tests/library-tests/` directory.
AST, CFG, and Dataflow tests should be stored in the `ql/tests/library-tests/ast`, `ql/tests/library-tests/cfg`, and `ql/tests/library-tests/dataflow` directories respectively.

Each test should be in a separate directory named after the test.
Tests should contain the following files:

- `${TestName}.ql`: The test file containing the CodeQL query.
  - This contains `query predicates` testing specific functionality of the library.
- `Inline${TestName}.ql`: An inline test file that contains the CodeQL query.
  - This file should contain the inline tests for what we are looking for
- `app.bicep`: A sample Bicep application file that contains the code to be tested.
  - This file should contain the Bicep code that is relevant to the test.
  - There should be multiple tests in the same file, each test should be separated by a comment block.

### Inline Tests

Inline tests are used to test specific functionality of the library.
Inline tests should be stored in the `Inline${TestName}.ql` file.
For testing AST, CFG, or DataFlow the query should tests the functionality being implemented.
For queries, the inline test should be a query that tests sources, sinks, and sanitizers are inplace.

**Example template:**

```codeql
import bicep
import utils.InlineExpectationsTest

module InlineTest implements TestSig {
  string getARelevantTag() { result = ["${test1}", "${test2}"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "${Test1}" and
    exists(Variable var |
      element = var.getName() and
      value = typedecl.toString() and
      location = typedecl.getLocation()
    )
    or
    tag = "${Test2}" and
    exists(Variable var |
      element = var.getName() and
      value = typedecl.toString() and
      location = typedecl.getLocation()
    )
    // Add more tests as needed
  }
}

import MakeTest<InlineTest>
```

Check other inline tests in the `ql/tests/library-tests/ast/` directory for examples of how to implement inline tests.

### Testing commands

Run the following command to run the tests:

```bash
./scripts/run-tests.sh ./src/tests/library-tests/${TEST_DIR}
```

Once run check the output of the command to ensure that all tests have passed.
If the test has failed, check the test file and the implementation of the class to ensure that the test is correct.
Iterate on the implementation of the class and the test until the test passes.
