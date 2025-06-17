/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */

 import codeql.Locations

 /**
  * Provides classes for performing local (intra-procedural) and
  * global (inter-procedural) data flow analyses.
  */
 module DataFlow {
   private import codeql.dataflow.DataFlow
   import DataFlowMake<Location, BicepDataFlow>
   import Public
 }