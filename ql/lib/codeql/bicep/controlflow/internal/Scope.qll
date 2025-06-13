private import bicep
private import codeql.bicep.AST
private import Completion
private import ControlFlowGraphImpl

abstract private class CfgScopeImpl extends AstNode {
  /** Holds if `first` is executed first when entering scope. */
  abstract predicate scopeFirst(AstNode first);

  /** Holds if scope is exited when `last` finishes with completion `c`. */
  abstract predicate scopeLast(AstNode last, Completion c);
}

final class CfgScope = CfgScopeImpl;

/**
 * A Infrastructure is a Sequence of statements.
 */
final class InfrastructureScope extends CfgScopeImpl, Infrastructure {
  override predicate scopeFirst(AstNode first) { first(this.getStatement(0), first) }

  override predicate scopeLast(AstNode last, Completion c) { last(this, last, c) }
}
