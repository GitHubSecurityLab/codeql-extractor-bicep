---
mode: 'agent'
---

Given a AST class or set of classes, create the various CFG related classes.
This includes the following:
- ControlFlowGraphImpl Tree class
- CfgNodes classes for each AST Node

**Guidelines:**

- Classify the AST class into the appropriate Control Flow Graph (CFG) class.
- Implement the `ControlFlowGraphImpl.qll` class if it does not exist.
- Implement the `CfgNodes` classes for each AST Node, ensuring that they follow the naming conventions and structure outlined below.
- All ControlFlowGraph Tree classes should be in the `ControlFlowGraphImpl.qll` file.
- All CfgNodes classes should be in the `CfgNodes.qll` file.

## Reading AST Implementaion

All public AST classes are are in the `ql/lib/codeql/bicep/ast/*.qll` files.
Read the classes implementation and documentation to understand the structure and relationships of the AST nodes.

## Classification

The AST classes should be classified into the following categories based on their structure and relationships:

- **LeafTree**:
  - AST nodes that do not have children, such as literals and identifiers.
- **StandardPostOrderTree**:
  - AST nodes that are traversed in a post-order manner
- **PreOrderTree**:
  - AST nodes that are traversed in a pre-order manner, meaning the node itself is visited before its children.
- **PostOrderTree**:
  - AST nodes that are traversed in a post-order manner,

Once the classification is done, the appropriate Control Flow Graph (CFG) class should be created.

## Control Flow Graph Implementaion

If you are asked to implement any Control Flow Graph (CFG) classes or predicates, you should follow the guidelines below.
The Control Flow Graph (CFG) is a representation of all paths that might be traversed through a program during its execution.
The Control Flow Graph library is in `ql/lib/codeql/**/controlflow/internal/ControlFlowGraphImpl.qll`

An AST node can only be represented as a single Control Flow Graph node class.
All Control Flow Graph node classes should have a suffix of `Tree` to indicate that they are part of the Control Flow Graph library.
Example classes include `ExprTree`, `StmtsTree`, and `ProgramTree`.

Use the `first()` and `last()` predicates to indicate the first and last nodes in the control flow.

### CFG LeafTree Nodes

The LeafTree Nodes are a part of the Control Flow Graph library and represent an end nodes in the CFG.
LeafTree Nodes are used to represent nodes in the CFG that do not have any children, meaning they are the end points of a path in the graph.

All Literals AST types are represented as LeafTree Nodes.

### CFG StandardPostOrderTree Nodes

The StandardPostOrderTree Nodes are a part of the Control Flow Graph library and represent the nodes in the CFG that are traversed in a post-order manner.
StandardPostOrderTree Nodes are used to represent nodes in the CFG that are traversed in a post-order manner, meaning that the children of a node are visited before the node itself.

Expressions and statements in the CFG are represented as StandardPostOrderTree Nodes.

If an expression or statement uses a predicate for accessing its children it should be used.
If an expression or statement does not have a predicate for accessing its children, the `getChild(i)` method should be used to access the children.

The following predicates should be implemented and overrided:
- `override AstNode getChildNode(int i)`
  - to get the child node at index `i`.
  - result should be the child node at index `i`.
  - If a node has multiple nodes, add the children in the order of execution in a Bicep program

**StandardPostOrderTree Class Example:**

```codeql
class ${AstNode}Tree extends StandardPostOrderTree instanceof ${AstNode} {
  override AstNode getChildNode(int i) {
    i = 0 and result = super.getAChild()
  }
}
```

### CFG PreOrderTree Nodes

The PreOrderTree Nodes are a part of the Control Flow Graph library and represent the nodes in the CFG that are traversed in a pre-order manner.
PreOrderTree Nodes are used to represent nodes in the CFG that are traversed in a pre-order manner, meaning that the node itself is visited before its children.

The following predicates should be implemented and overrided:

- `final override predicate propagatesAbnormal(AstNode child)`
  - to indicate if the node propagates abnormal control flow to its child.
  - child should be matched with the child node of the AST node.
- `override predicate succ(AstNode pred, AstNode succ, Completion c)`
  - to indicate the successor of the node.
  - `pred` should be the predecessor node.
  - `succ` should be the successor node.
  - `c` should be the completion of the successor node.
- `override predicate last(AstNode node, Completion c)`
  - to indicate if the node is the last node in the control flow.
  - `node` should be the node to check.
  - `c` should be the completion of the node.

**PreOrderTree Class Example:**

```codeql
class ${AstNode}Tree extends PreOrderTree instanceof ${AstNode} {
  final override predicate propagatesAbnormal(AstNode child) { child = super.getIdentifier() }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Start with the identifier
    pred = this and first(super.getIdentifier(), succ) and completionIsSimple(c)
    or
    last(super.getIdentifier(), pred, c) and first(super.getDefaultValue(), succ) and completionIsNormal(c)
  }

  override predicate last(AstNode node, Completion c) {
    node = super.getDefaultValue() and completionIsNormal(c)
  }
}
```

Check and validate if a CFG Tree class is present in the `ControlFlowGraphImpl.qll` file.
If on Tree class is not present, implement the class for the desired node.

## CfgNodes Implementaion

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
