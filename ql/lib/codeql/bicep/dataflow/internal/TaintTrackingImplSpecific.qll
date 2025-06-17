/**
 * Provides bicep-specific definitions for use in the taint tracking library.
 */

private import codeql.Locations
private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module BicepTaintTracking implements InputSig<Location, BicepDataFlow> {
  import TaintTrackingPrivate
}
