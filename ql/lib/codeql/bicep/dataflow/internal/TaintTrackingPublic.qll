private import bicep
private import TaintTrackingPrivate
private import codeql.bicep.CFG
private import codeql.bicep.dataflow.DataFlow

/**
 * Holds if taint propagates from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localTaint(DataFlow::Node source, DataFlow::Node sink) { localTaintStep*(source, sink) }

/**
 * Holds if taint can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprTaint(CfgNodes::ExprCfgNode e1, CfgNodes::ExprCfgNode e2) { none() }

predicate localTaintStep = localTaintStepCached/2;
