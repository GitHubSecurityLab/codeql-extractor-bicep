private import codeql.util.Boolean
private import Completion

newtype TLoopJumpType =
  TContinueJump() or
  TBreakJump()

cached
newtype TSuccessorType =
  TSuccessorSuccessor() or
  TBooleanSuccessor(Boolean b) or
  TBreakSuccessor() or
  TContinueSuccessor() or
  TReturnSuccessor()

/** The type of a control flow successor. */
abstract class SuccessorTypeImpl extends TSuccessorType {
  /** Gets a textual representation of successor type. */
  abstract string toString();
}

/** A normal control flow successor. */
class NormalSuccessorImpl extends SuccessorTypeImpl, TSuccessorSuccessor {
  override string toString() { result = "successor" }
}

/** A conditional control flow successor. */
abstract class ConditionalSuccessorImpl extends SuccessorTypeImpl {
  boolean value;

  bindingset[value]
  ConditionalSuccessorImpl() { exists(value) }

  /** Gets the Boolean value of this successor. */
  boolean getValue() { result = value }
}

/** A Boolean control flow successor for a boolean conditon. */
class BooleanSuccessorImpl extends ConditionalSuccessorImpl, TBooleanSuccessor {
  BooleanSuccessorImpl() { this = TBooleanSuccessor(value) }

  override string toString() { result = "BooleanSuccessor" }
}

/**
 * A control flow successor of a `break` expression.
 */
class BreakSuccessorImpl extends SuccessorTypeImpl, TBreakSuccessor {
  override string toString() { result = "break" }
}

/**
 * A control flow successor of a `continue` expression.
 */
class ContinueSuccessorImpl extends SuccessorTypeImpl, TContinueSuccessor {
  override string toString() { result = "continue" }
}

/**
 * A `return` control flow successor.
 */
class ReturnSuccessorImpl extends SuccessorTypeImpl, TReturnSuccessor {
  override string toString() { result = "return" }
}
