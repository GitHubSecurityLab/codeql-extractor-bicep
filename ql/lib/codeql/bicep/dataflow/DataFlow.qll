/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */

import bicep

module DataFlow {
  private import internal.DataFlowImplSpecific
  private import codeql.dataflow.DataFlow
  import DataFlowMake<Location, BicepDataFlow>
  import internal.DataFlowImpl
}
