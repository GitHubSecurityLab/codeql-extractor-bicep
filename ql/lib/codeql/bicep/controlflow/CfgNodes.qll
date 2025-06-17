/** Provides classes representing nodes in a control flow graph. */

private import bicep
private import BasicBlocks
private import ControlFlowGraph
import internal.ControlFlowGraphImpl

/** A control-flow node that wraps an AST expression. */
class ExprCfgNode extends AstCfgNode {
  string getAPrimaryQlClass() { result = "ExprCfgNode" }

  Expr e;

  ExprCfgNode() { e = this.getAstNode() }

  /** Gets the underlying expression. */
  Expr getExpr() { result = e }
}

/** A control-flow node that wraps an AST statement. */
class StmtsCfgNode extends AstCfgNode {
  string getAPrimaryQlClass() { result = "StmtsCfgNode" }

  Stmts s;

  StmtsCfgNode() { s = this.getAstNode() }

  /** Gets the underlying expression. */
  Stmts getStmt() { result = s }
}

/** Provides classes for control-flow nodes that wrap AST expressions. */
module ExprNodes { 
  class CallCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "CallCfgNode" }

    override CallExpression e;

    override CallExpression getExpr() { result = super.getExpr() }
  }
}

module StmtNodes {
  /** A control-flow node that wraps a `Cmd` AST expression. */
  class CallCfgNode extends StmtsCfgNode {
    override string getAPrimaryQlClass() { result = "CallCfgNode" }

    override UserDefinedFunction s;

    override UserDefinedFunction getStmt() { result = super.getStmt() }
  }
}