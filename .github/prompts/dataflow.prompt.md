---
mode: 'agent'
---

Dataflow is used to track the flow of data through Bicep code.
Dataflow is used to identify how data is passed between different parts of the code, such as variables, functions, and classes.
Dataflow is also used to identify how data is transformed and manipulated within the code.

**Guidelines:**

- Check the `DataFlowPrivate.qll` file in the `ql/lib/codeql/bicep/dataflow/internal` directory to understand how the DataFlow classes are implemented.
- Identify and implement the necessary data flow predicates


# Instructions for Implementing CodeQL Dataflow Library

This document provides comprehensive instructions for implementing and customizing the CodeQL dataflow library for different programming languages. It is intended for language maintainers who need to adapt the shared dataflow framework to their specific language.

## Overview

The CodeQL dataflow library provides a sophisticated framework for performing interprocedural (global) data flow analysis. It's designed as a modular system where:

1. Language-specific components define the data flow graph (nodes and edges)
2. Shared components handle the complex aspects like:
   - Connecting call sites with returns
   - Matching field writes with reads
   - Ensuring paths are well-formed
   - Pruning infeasible paths based on type information

The resulting framework allows security researchers to write powerful queries to detect vulnerabilities with minimal effort.

## File Organization

Implement your language-specific dataflow library with these files:

```
dataflow/DataFlow.qll                     # User-facing interface
dataflow/internal/DataFlowImpl.qll        # Configuration-specific implementation
dataflow/internal/DataFlowImplSpecific.qll # Language-specific implementation
```

The `DataFlow.qll` file is minimal and just imports the implementation:

```ql
import <language>

module DataFlow {
  import <language>.dataflow.internal.DataFlowImpl
}
```

`DataFlowImplSpecific.qll` should expose `Public` and `Private` modules:

```ql
module Private {
  import DataFlowPrivate
}

module Public {
  import DataFlowPublic
}
```

## Step 1: Define the Core Data Flow Graph

### Defining the `Node` Class

First, create the `Node` class in `DataFlowPublic.qll`:

```ql
/** A node in the data flow graph. */
class Node {
  /** Gets a textual representation of this element. */
  string toString() { ... }
  
  /** Gets the location of this node. */
  Location getLocation() { ... }
  
  // Helper methods for users
  DataFlowExpr asExpr() { ... }
  Parameter asParameter() { ... }
}
```

Then implement required subclasses:

```ql
/** A data flow node that corresponds to an expression. */
class ExprNode extends Node {
  DataFlowExpr expr;
  ExprNode() { this = TExprNode(expr) }
  
  /** Gets the expression corresponding to this node. */
  DataFlowExpr getExpr() { result = expr }
}

/** A data flow node that corresponds to a parameter. */
class ParameterNode extends Node {
  Parameter param;
  ParameterNode() { this = TParameterNode(param) }
  
  /** Gets the parameter corresponding to this node. */
  Parameter getParameter() { result = param }
}

// Additional required subclasses
class ArgumentNode extends ExprNode { ... }
class ReturnNode extends ExprNode { ... }
class OutNode extends ExprNode { ... }
class CastNode extends ExprNode { ... }
class PostUpdateNode extends Node { ... }
```

### Define Node Construction

Define how nodes are constructed using a `newtype` in `DataFlowPrivate.qll`:

```ql
private newtype TNode =
  TExprNode(DataFlowExpr e) or
  TParameterNode(Parameter p) or
  ...
```

### Define Local Flow Steps

Implement the core local flow relation:

```ql
/**
 * Holds if there is a simple local flow step from `node1` to `node2`.
 */
predicate simpleLocalFlowStep(Node node1, Node node2, string model) {
  // Example: expression to its parent when value is preserved
  exists(Assignment a |
    node1.asExpr() = a.getRValue() and
    node2.asExpr() = a and
    model = "local assignment"
  )
  or
  // Add other local flow steps specific to your language
  ...
}

// Public version for users
predicate localFlowStep(Node node1, Node node2) {
  simpleLocalFlowStep(node1, node2, _)
}

pragma[inline]
predicate localFlow(Node node1, Node node2) {
  localFlowStep*(node1, node2)
}
```

## Step 2: Define Call Graph and Inter-procedural Flow

Create the necessary types and predicates for handling function calls:

```ql
// Aliases for language-specific types
class DataFlowCall = Call;
class DataFlowCallable = Callable;

/**
 * Gets the callable in which node `n` occurs.
 */
DataFlowCallable nodeGetEnclosingCallable(Node n) {
  result = n.asExpr().getEnclosingCallable() or
  result = n.asParameter().getCallable() or
  // Handle other node types
  ...
}

/** 
 * Gets a viable target for the call `c`. 
 */
DataFlowCallable viableCallable(DataFlowCall c) {
  result = c.getTarget() or
  // Add other resolution mechanisms (virtual calls, etc.)
  ...
}
```

Define parameter and argument positioning:

```ql
class ParameterPosition {
  private int pos;
  
  ParameterPosition() { this = pos }
  
  /** Gets the position represented by this class. Zero-indexed. */
  int getPosition() { result = pos }
  
  /** Gets a textual representation of this position. */
  string toString() { result = pos.toString() }
}

class ArgumentPosition {
  private int pos;
  
  ArgumentPosition() { this = pos }
  
  /** Gets the position represented by this class. Zero-indexed. */
  int getPosition() { result = pos }
  
  /** Gets a textual representation of this position. */
  string toString() { result = pos.toString() }
}

/**
 * Holds if parameter position `ppos` matches argument position `apos`.
 */
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos.getPosition() = apos.getPosition()
}
```

Connect parameters to arguments:

```ql
/**
 * Holds if `p` is a parameter node of callable `c` at position `pos`.
 */
predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
  p.getParameter() = c.getParameter(pos.getPosition())
}

/**
 * Holds if `arg` is an argument node for call `c` at position `pos`.
 */
predicate isArgumentNode(ArgumentNode arg, DataFlowCall c, ArgumentPosition pos) {
  arg.getExpr() = c.getArgument(pos.getPosition())
}
```

Connect function returns to call sites:

```ql
/**
 * Gets a node that can read the value returned from `call`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  result.asExpr() = call and
  kind instanceof NormalReturnKind
}

class ReturnKind {
  string toString() { result = "return" }
}

// For most languages, a simple singleton implementation is sufficient
private newtype TReturnKind = TNormalReturnKind()

class NormalReturnKind extends ReturnKind, TNormalReturnKind {
  override string toString() { result = "return" }
}
```

## Step 3: Implement Field Flow

Field flow allows tracking data through object properties:

```ql
/** A content item, representing a field or property. */
class Content extends TContent {
  /** Gets a textual representation of this content. */
  abstract string toString();
}

class FieldContent extends Content, TFieldContent {
  Field f;
  
  FieldContent() { this = TFieldContent(f) }
  
  /** Gets the field represented by this content. */
  Field getField() { result = f }
  
  override string toString() { result = f.getName() }
}

class ContentSet {
  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() { ... }
  
  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() { ... }
  
  /** Gets a textual representation of this content set. */
  string toString() { ... }
}
```

Then implement read and store steps:

```ql
/**
 * Holds if data can flow from `node1` to `node2` via a read of `c`.
 */
predicate readStep(Node node1, ContentSet c, Node node2) {
  exists(FieldAccess fa |
    node1.asExpr() = fa.getQualifier() and
    node2.asExpr() = fa and
    c.getAReadContent().(FieldContent).getField() = fa.getField()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via a store to `c`.
 */
predicate storeStep(Node node1, ContentSet c, Node node2) {
  exists(FieldAssignment fa |
    node1.asExpr() = fa.getRValue() and
    node2.(PostUpdateNode).getPreUpdateNode().asExpr() = fa.getQualifier() and
    c.getAStoreContent().(FieldContent).getField() = fa.getField()
  )
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`.
 */
predicate clearsContent(Node n, ContentSet c) {
  n = any(PostUpdateNode pun | storeStep(_, c, pun)).getPreUpdateNode()
}
```

## Step 4: Type Pruning (Optional but Recommended)

Type pruning helps eliminate impossible paths when tracking values:

```ql
/**
 * A data flow type, which may differ from the language's type system.
 */
class DataFlowType extends TDataFlowType {
  /** Gets a textual representation of this type. */
  abstract string toString();
}

/**
 * Holds if `t1` and `t2` are compatible types.
 */
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) {
  t1 = t2 or
  typeStrongerThan(t1, t2) or
  typeStrongerThan(t2, t1)
}

/**
 * Holds if `t1` is strictly stronger than `t2`.
 */
predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) {
  // For example, subclass-superclass relationships
  exists(ClassType cls1, ClassType cls2 |
    t1 = TClassType(cls1) and
    t2 = TClassType(cls2) and
    cls1.getABaseClass+() = cls2
  )
}

/**
 * Gets the data flow type of node `n`.
 */
DataFlowType getNodeType(Node n) {
  // Map language types to dataflow types
  exists(Type t |
    t = n.asExpr().getType() and
    result = getDataFlowTypeFromType(t)
  )
  or
  exists(Parameter p |
    p = n.asParameter() and
    result = getDataFlowTypeFromType(p.getType())
  )
}
```

## Step 5: Additional Features

### Jump Steps (for Global Variables)

```ql
/**
 * Holds if data can flow from `node1` to `node2` through a non-local step.
 */
predicate jumpStep(Node node1, Node node2) {
  // Example: flow through global variables
  exists(GlobalVariable gv, AssignExpr write, VarAccess read |
    write.getLValue() = gv.getAnAccess() and
    write.getRValue() = node1.asExpr() and
    read = gv.getAnAccess() and
    node2.asExpr() = read and
    not read.getEnclosingCallable() = write.getEnclosingCallable()
  )
}
```

### Lambda Flow Support

```ql
/**
 * A kind of function/lambda call.
 */
class LambdaCallKind extends TLambdaCallKind {
  string toString() { ... }
}

/**
 * Holds if `creation` creates a lambda for callable `c`.
 */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
  // Example for JavaScript:
  exists(FunctionExpr fe |
    creation.asExpr() = fe and
    c = fe and
    kind = TStandardLambdaCallKind()
  )
}

/**
 * Holds if `call` is a lambda call where `receiver` is the function.
 */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
  // Example for JavaScript:
  exists(CallExpr ce |
    call = ce and
    receiver.asExpr() = ce.getCallee() and
    kind = TStandardLambdaCallKind()
  )
}
```

### Call Context Optimization

```ql
/**
 * Holds if call might benefit from call context.
 */
predicate mayBenefitFromCallContext(DataFlowCall call) {
  // Example: calls that have multiple possible targets
  count(viableCallable(call)) > 1
}

/**
 * Gets a viable target in the context of another call.
 */
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
  // Example: Use call context to narrow down targets
  result = viableCallable(call) and
  mayBenefitFromCallContext(call) and
  // Add logic to filter targets based on ctx
  ...
}
```

## Step 6: Must-Have Helper Methods

Implement these helper methods for users of your dataflow library:

```ql
/** Gets the node corresponding to expression `e`. */
ExprNode exprNode(DataFlowExpr e) { result.getExpr() = e }

/** Gets the node corresponding to parameter `p`. */
ParameterNode parameterNode(Parameter p) { result.getParameter() = p }

/** Gets the data flow node for the value of `e`. */
Node valueNode(Expr e) { result.asExpr() = e }

/** Gets the data flow node for the variable `v`. */
Node variableNode(Variable v) { result.(VarAccessNode).getVariable() = v }
```

## Step 7: Testing and Validation

After implementation, verify your library works properly:

1. Run consistency checks in `dataflow/internal/DataFlowImplConsistency.qll`
2. Create test cases that verify flow paths are correct:
   - Simple local flow
   - Flow through parameters and returns
   - Flow through fields/properties
   - Flow through collections/containers
   - Flow through lambdas

## Common Pitfalls and Tips

1. **Type Pruning Precision**: Don't make type compatibility too strict - this can block valid paths. Start permissive and tighten as needed.

2. **Performance Considerations**:
   - The default access path limit is 5. Consider if this is appropriate for your language.
   - Field flow can be expensive. Set appropriate branch limits (default is 2).
   - Monitor the performance of your implementation on large codebases.

3. **PostUpdateNodes**: Ensure these are correctly implemented for all mutable objects, especially arguments.
   - Create post-update nodes for arguments that might be modified by callees.
   - Create post-update nodes for field qualifiers to track field updates.

4. **Local Flow**: Implement use-to-use flow (not just def-use) for better precision and usability.

5. **Field Content Sets**: Design these carefully to balance precision and performance. For containers and arrays, consider special modeling as shown in the array content example.

## Examples

### Example 1: Basic Field Flow

```ql
// For code like: a.f = source; sink(a.f);
// Implement:
storeStep(sourceNode, fieldContent(f), postUpdateNodeFor(a))
readStep(a, fieldContent(f), a_f_access)
```

### Example 2: Constructor Flow

```ql
// For: var obj = new MyClass(source); sink(obj.field);
// Create:
- ArgumentNode for source
- Special MallocNode as the "this" parameter
- PostUpdateNode for the constructor call itself
```

### Example 3: Collection/Array Flow

Consider special modeling for arrays and collections to balance precision and performance.

## Conclusion

Implementing the dataflow library requires careful design of the data flow graph and attention to language-specific details. The shared framework handles much of the complexity, but your language-specific implementation must provide the foundation upon which it operates.

When in doubt, study existing implementations in languages like C++, Java, or JavaScript for guidance on best practices and patterns. Regular testing with real-world examples will help ensure your implementation is both correct and performant.
