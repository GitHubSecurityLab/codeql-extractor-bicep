private import bicep
private import DataFlowPrivate
private import TaintTrackingPublic
private import codeql.bicep.CFG
private import codeql.bicep.dataflow.DataFlow

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) { none() }

/**
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::ContentSet c) { none() }

cached
private module Cached {
  private import codeql.bicep.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon

  cached
  predicate forceCachingInSameStage() { DataFlowImplCommon::forceCachingInSameStage() }

  /**
   * Holds if the additional step from `nodeFrom` to `nodeTo` should be included
   * in all global taint flow configurations.
   */
  cached
  predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string model) {
    none()
  }

  /**
   * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  cached
  predicate localTaintStepCached(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    DataFlow::localFlowStep(nodeFrom, nodeTo) or
    defaultAdditionalTaintStep(nodeFrom, nodeTo, _)
  }
}

import Cached

import SpeculativeTaintFlow

private module SpeculativeTaintFlow {
  private import codeql.bicep.dataflow.internal.DataFlowDispatch as DataFlowDispatch
  private import codeql.bicep.dataflow.internal.DataFlowPublic as DataFlowPublic

  /**
   * Holds if the additional step from `src` to `sink` should be considered in
   * speculative taint flow exploration.
   */
  predicate speculativeTaintStep(DataFlow::Node src, DataFlow::Node sink) { none() }
}
