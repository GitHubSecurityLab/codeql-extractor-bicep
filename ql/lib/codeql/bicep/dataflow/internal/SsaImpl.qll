private import bicep
private import codeql.bicep.controlflow.BasicBlocks as BasicBlocks
private import BasicBlocks
private import codeql.bicep.controlflow.ControlFlowGraph
private import codeql.bicep.controlflow.internal.ControlFlowGraphImpl as ControlFlowGraphImpl
private import codeql.ssa.Ssa as SsaImplCommon

/** Holds if `write` writes to variable `v`. */
predicate variableWrite(AstNode write, Variable v) {
  exists(VariableWriteAccess access |
    access.getAstNode() = write and
    access.getVariable() = v
  )
}

module SsaInput implements SsaImplCommon::InputSig<Location> {
  class BasicBlock = BasicBlocks::BasicBlock;

  class ControlFlowNode = CfgNode;

  class ExitBasicBlock = BasicBlocks::ExitBasicBlock;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  /**
   * A variable amenable to SSA construction.
   */
  class SourceVariable extends Variable {
    SourceVariable() {
      // Only variables that have accesses
      exists(VariableAccess access | this.getAnAccess() = access)
    }
  }

  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    variableWriteActual(bb, i, v, bb.getNode(i)) and
    certain = true
  }

  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    exists(VariableAccess va |
      bb.getNode(i).getAstNode() = va.getAstNode() and
      va = v.getAnAccess()
    ) and
    certain = true
  }
}

import SsaImplCommon::Make<Location, SsaInput> as Impl

class Definition = Impl::Definition;

class WriteDefinition = Impl::WriteDefinition;

class UncertainWriteDefinition = Impl::UncertainWriteDefinition;

class PhiDefinition = Impl::PhiNode;

module Consistency = Impl::Consistency;

/** Holds if `v` is read at index `i` in basic block `bb`. */
private predicate variableReadActual(BasicBlock bb, int i, Variable v) {
  exists(VariableAccess read |
    read instanceof VariableReadAccess and
    read.getVariable() = v and
    read.getAstNode() = bb.getNode(i).getAstNode()
  )
}

cached
private module Cached {
  cached
  CfgNode getARead(Definition def) {
    exists(Variable v, BasicBlock bb, int i |
      Impl::ssaDefReachesRead(v, def, bb, i) and
      variableReadActual(bb, i, v) and
      result = bb.getNode(i)
    )
  }

  cached
  predicate firstRead(Definition def, CfgNode read) {
    // TODO: Get first node
    exists(BasicBlock bb, int i | read = bb.getNode(i))
  }

    /**
   * Holds if `v` is written at index `i` in basic block `bb`, and the corresponding
   * write access node in the CFG is `write`.
   */
  cached
  predicate variableWriteActual(BasicBlock bb, int i, Variable v, CfgNode write) {
    bb.getNode(i) = write and
    variableWrite(write.getAstNode(), v)
  }
}

import Cached
private import codeql.bicep.dataflow.Ssa
