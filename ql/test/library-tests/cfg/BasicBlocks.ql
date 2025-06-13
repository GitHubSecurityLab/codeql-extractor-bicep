import bicep
import codeql.bicep.controlflow.BasicBlocks
import codeql.bicep.controlflow.ControlFlowGraph

query predicate dominates(BasicBlock bb1, BasicBlock bb2) { bb1.dominates(bb2) }

query predicate postDominance(BasicBlock bb1, BasicBlock bb2) { bb1.postDominates(bb2) }

query predicate immediateDominator(BasicBlock bb1, BasicBlock bb2) {
  bb1.getImmediateDominator() = bb2
}
