/**
 * Provides the module `Ssa` for working with static single assignment (SSA) form.
 */

/**
 * Provides classes for working with static single assignment (SSA) form.
 */
module Ssa {
  private import bicep
  private import codeql.bicep.controlflow.BasicBlocks
  private import codeql.bicep.controlflow.ControlFlowGraph
  private import codeql.bicep.controlflow.internal.ControlFlowGraphImpl as CfgImpl
  private import internal.SsaImpl as SsaImpl

  class Variable = SsaImpl::SsaInput::SourceVariable;

  class Definition extends SsaImpl::Definition {
    final CfgNode getControlFlowNode() {
      exists(BasicBlock bb, int i | this.definesAt(_, bb, i) | result = bb.getNode(i))
    }

    final CfgNode getARead() { result = SsaImpl::getARead(this) }

    final CfgNode getAFirstRead() { SsaImpl::firstRead(this, result) }
  }

  class WriteDefinition extends Definition, SsaImpl::WriteDefinition {
    final CfgNode getControlFlowNode() {
      exists(BasicBlock bb, int i | this.definesAt(_, bb, i) | result = bb.getNode(i))
    }

    final CfgNode getARead() { result = SsaImpl::getARead(this) }

    cached
    override Location getLocation() {
      exists(BasicBlock bb, int i |
        this.definesAt(_, bb, i) and
        result = bb.getNode(i).getLocation()
      )
    }
  }
}