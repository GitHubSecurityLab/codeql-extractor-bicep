/**
 * Provides the module `TaintTracking`.
 */

private import bicep

/**
 * Provides a library for performing local (intra-procedural) and global
 * (inter-procedural) taint-tracking analyses.
 */
module TaintTracking {
  import codeql.bicep.dataflow.internal.TaintTrackingImpl::Public
  private import codeql.bicep.dataflow.internal.DataFlowImplSpecific
  private import codeql.bicep.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  private import bicep
  import TaintFlowMake<Location, BicepDataFlow, BicepTaintTracking>
}