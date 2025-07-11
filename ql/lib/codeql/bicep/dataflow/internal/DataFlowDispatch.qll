private import bicep as Bicep
private import codeql.Locations
private import codeql.bicep.CFG
private import DataFlowPrivate
private import codeql.util.Boolean
private import codeql.util.Unit

newtype TReturnKind = TNormalReturnKind()

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { call = result.getCall(kind) }

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable.
 */
abstract class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this position. */
  abstract string toString();
}

/**
 * A value returned from a callable using a `return` statement or an expression
 * body, that is, a "normal" return.
 */
class NormalReturnKind extends ReturnKind, TNormalReturnKind {
  override string toString() { result = "return" }
}

/** A callable defined in library code, identified by a unique string. */
abstract class LibraryCallable extends string {
  bindingset[this]
  LibraryCallable() { any() }

  /** Gets a call to this library callable. */
  Bicep::UserDefinedFunction getACall() { none() }
}

/**
 * A callable. This includes callables from source code, as well as callables
 * defined in library code.
 */
class DataFlowCallable extends TDataFlowCallable {
  /**
   * Gets the underlying CFG scope, if any.
   *
   * This is usually a `Callable`, but can also be a `Toplevel` file.
   */
  CfgScope asCfgScope() { this = TCfgScope(result) }

  /** Gets the underlying library callable, if any. */
  LibraryCallable asLibraryCallable() { this = TLibraryCallable(result) }

  /** Gets a textual representation of this callable. */
  string toString() { result = [this.asCfgScope().toString(), this.asLibraryCallable()] }

  /** Gets the location of this callable. */
  Location getLocation() {
    result = this.asCfgScope().getLocation()
    or
    this instanceof TLibraryCallable
  }

  /** Gets a best-effort total ordering. */
  int totalorder() { none() }
}

/**
 * A call. This includes calls from source code, as well as call(back)s
 * inside library callables with a flow summary.
 */
abstract class DataFlowCall extends TDataFlowCall {
  /** Gets the enclosing callable. */
  abstract DataFlowCallable getEnclosingCallable();

  /** Gets the underlying source code call, if any. */
  abstract CfgNodes::StmtNodes::CallCfgNode asCall();

  /** Gets a textual representation of this call. */
  abstract string toString();

  /** Gets the location of this call. */
  abstract Location getLocation();

  DataFlowCallable getARuntimeTarget() { none() }

  ArgumentNode getAnArgumentNode() { none() }

  /** Gets a best-effort total ordering. */
  int totalorder() { none() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

class NormalCall extends DataFlowCall, TNormalCall {
  private CfgNodes::StmtNodes::CallCfgNode c;

  NormalCall() { this = TNormalCall(c) }

  override CfgNodes::StmtNodes::CallCfgNode asCall() { result = c }

  override DataFlowCallable getEnclosingCallable() { result = TCfgScope(c.getScope()) }

  override string toString() { result = c.toString() }

  override Location getLocation() { result = c.getLocation() }
}

/** A call for which we want to compute call targets. */
private class RelevantCall extends CfgNodes::StmtNodes::CallCfgNode { }

/** Holds if `call` may resolve to the returned source-code method. */
private DataFlowCallable viableSourceCallable(DataFlowCall call) {
  none() // TODO
  or
  result = any(AdditionalCallTarget t).viableTarget(call.asCall())
}

/**
 * A unit class for adding additional call steps.
 *
 * Extend this class to add additional call steps to the data flow graph.
 */
class AdditionalCallTarget extends Unit {
  /**
   * Gets a viable target for `call`.
   */
  abstract DataFlowCallable viableTarget(CfgNodes::StmtNodes::CallCfgNode call);
}

/** Holds if `call` may resolve to the returned summarized library method. */
DataFlowCallable viableLibraryCallable(DataFlowCall call) {
  exists(LibraryCallable callable |
    result = TLibraryCallable(callable) and
    call.asCall().getStmt() = callable.getACall()
  )
}

cached
private module Cached {
  cached
  newtype TDataFlowCallable =
    TCfgScope(CfgScope scope) or
    TLibraryCallable(LibraryCallable callable)

  cached
  newtype TDataFlowCall = TNormalCall(CfgNodes::StmtNodes::CallCfgNode c)

  /** Gets a viable run-time target for the call `call`. */
  cached
  DataFlowCallable viableCallable(DataFlowCall call) {
    result = viableSourceCallable(call)
    or
    result = viableLibraryCallable(call)
  }

  cached
  newtype TArgumentPosition =
    TPositionalArgumentPosition(int pos) { exists(Bicep::CallExpression c | exists(c.getArgument(pos))) }

  cached
  newtype TParameterPosition = TPositionalParameterPosition(int pos) { none() /* TODO */ }
}

import Cached

/** A parameter position. */
class ParameterPosition extends TParameterPosition {
  /** Holds if this position represents a positional parameter at position `pos`. */
  predicate isPositional(int pos) { this = TPositionalParameterPosition(pos) }

  /** Gets a textual representation of this position. */
  string toString() { exists(int pos | this.isPositional(pos) and result = "position " + pos) }
}

/** An argument position. */
class ArgumentPosition extends TArgumentPosition {
  /** Holds if this position represents a positional argument at position `pos`. */
  predicate isPositional(int pos) { this = TPositionalArgumentPosition(pos) }

  /** Gets a textual representation of this position. */
  string toString() { exists(int pos | this.isPositional(pos) and result = "position " + pos) }
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[nomagic]
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  exists(int pos | ppos.isPositional(pos) and apos.isPositional(pos))
}
