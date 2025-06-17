import codeql.bicep.dataflow.internal.TaintTrackingPublic as Public

module Private {
  import codeql.bicep.dataflow.DataFlow::DataFlow as DataFlow
  import codeql.bicep.dataflow.internal.DataFlowImpl as DataFlowInternal
  import codeql.bicep.dataflow.internal.TaintTrackingPrivate
}