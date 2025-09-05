---
mode: 'agent'
---


You are 

## Overview

TaintTracking in CodeQL is a framework that extends DataFlow to track not just value flows but also tainted information flows. The framework is language-agnostic at its core (defined in `shared/dataflow/codeql/dataflow/TaintTracking.qll`) but requires language-specific implementations. 

The core structure follows a similar pattern across languages (Python, JavaScript/TypeScript, Ruby):

1. A language-neutral base module (`shared/dataflow/codeql/dataflow/TaintTracking.qll`)
2. Language-specific implementations that implement required interfaces

## Key Components

### 1. Core Interface (shared TaintTracking.qll)

The core taint tracking framework defines the following key components:

- **InputSig module interface**: Defines what language-specific taint tracking must implement
- **TaintFlowMake module**: Constructs modules for taint-tracking analyses
- **Global modules**: For different types of taint tracking (with/without state, speculative)

### 2. Language-Specific Implementation

Each language implements:

- A main `TaintTracking` module 
- Implementation-specific classes in subdirectories:
  - `TaintTrackingPublic.qll`: Public API
  - `TaintTrackingPrivate.qll`: Internal implementation
  - `TaintTrackingImplSpecific.qll`: Language-specific implementation of the `InputSig` interface

## Core Predicates Required

The language-specific implementation must provide:

1. `defaultTaintSanitizer`: Identifies nodes that block taint
2. `defaultAdditionalTaintStep`: Defines additional taint propagation steps
3. `defaultImplicitTaintRead`: Defines content that should be considered tainted
4. `speculativeTaintStep`: Optional steps for speculative taint tracking

## Step-by-Step Implementation Guide

### Step 1: Create the Main TaintTracking Module

Create a file structure like:

```
- YourLanguage/
  - ql/
    - lib/
      - codeql/
        - yourlanguage/
          - TaintTracking.qll
          - dataflow/
            - internal/
              - TaintTrackingPublic.qll
              - TaintTrackingPrivate.qll  
              - TaintTrackingImplSpecific.qll
```

### Step 2: Implement the Main TaintTracking.qll Module

```codeql
/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */
module TaintTracking {
  import codeql.yourlanguage.dataflow.internal.TaintTrackingPublic
  private import codeql.yourlanguage.dataflow.internal.DataFlowImplSpecific
  private import codeql.yourlanguage.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  private import codeql.Locations
  import TaintFlowMake<Location, YourLanguageDataFlow, YourLanguageTaintTracking>
}
```

### Step 3: Implement TaintTrackingImplSpecific.qll

```codeql
/**
 * Provides Language-specific definitions for use in the taint tracking library.
 */
private import codeql.Locations
private import codeql.dataflow.TaintTracking
private import DataFlowImplSpecific

module YourLanguageTaintTracking implements InputSig<Location, YourLanguageDataFlow> {
  import TaintTrackingPrivate
}
```

### Step 4: Implement TaintTrackingPrivate.qll

This file contains the core implementation of the taint tracking functionality:

```codeql
private import YourLanguageAST
private import DataFlowPrivate
private import TaintTrackingPublic
private import YourLanguageSpecificImports

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) {
  // Implement language-specific sanitizers
}

/**
 * Holds if default configurations should allow implicit reads of `c` at sinks
 * and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::ContentSet c) {
  // Implement logic for implicit reads
}

/**
 * Holds if the additional step from `nodeFrom` to `nodeTo` should be included in all
 * global taint flow configurations.
 */
cached
predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string model) {
  // Implement language-specific taint steps
}

/**
 * Holds if the additional step from `src` to `sink` should be considered in
 * speculative taint flow exploration.
 */
predicate speculativeTaintStep(DataFlow::Node src, DataFlow::Node sink) {
  // Implement speculative taint steps
}
```

### Step 5: Implement TaintTrackingPublic.qll

This file exposes the public API for taint tracking:

```codeql
private import YourLanguageAST
private import TaintTrackingPrivate
private import YourLanguageSpecificImports

/**
 * Holds if taint propagates from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localTaint(DataFlow::Node source, DataFlow::Node sink) { 
  localTaintStep*(source, sink) 
}

/**
 * Holds if taint can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprTaint(ExprNode e1, ExprNode e2) {
  localTaint(DataFlow::exprNode(e1), DataFlow::exprNode(e2))
}

/**
 * Holds if taint can flow in one local step from `nodeFrom` to `nodeTo`.
 */
predicate localTaintStep = localTaintStepCached/2;
```

### Step 6: Implement Language-Specific Additional Taint Steps

The most important part of a taint tracking implementation is defining language-specific taint propagation rules. Common patterns include:

1. **String operations**: Concatenation, substring, interpolation, etc.
2. **Container operations**: Element access, iteration, unpacking
3. **Special language constructs**: Async/await, destructuring, etc.
4. **Type-specific propagation**: JSON parsing, serialization, etc.

For example:
```codeql
cached
predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string model) {
  // String concatenation
  exists(StringConcatenationNode concat |
    nodeFrom.asExpr() = concat.getAnOperand() and
    nodeTo.asExpr() = concat
  ) and 
  model = "string-concatenation"
  or
  // Container access
  exists(ArrayAccess access |
    nodeFrom.asExpr() = access.getArray() and
    nodeTo.asExpr() = access
  ) and
  model = "array-access"
}
```

## Usage Example

Once implemented, you can create taint tracking configurations like:

```codeql
import codeql.yourlanguage.TaintTracking

class MyConfiguration implements TaintTracking::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // Define your sources
  }
  
  predicate isSink(DataFlow::Node sink) {
    // Define your sinks
  }
  
  // Optionally override:
  // predicate isBarrier(DataFlow::Node node) { ... }
  // predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node sink) { ... }
}

module MyFlow = TaintTracking::Global<MyConfiguration>;

from MyFlow::PathNode source, MyFlow::PathNode sink
where MyFlow::flowPath(source, sink)
select sink, source, sink, "Tainted flow from $@.", source, source.toString()
```

## Advanced Features

1. **Flow states**: Used when different types of taint need different tracking
2. **Speculative tracking**: For possible but not definite taint flows
3. **Sanitizers**: Used to block taint propagation
4. **Content sets**: Controlling which parts of structured data propagate taint

## Language Implementation Comparison

### Ruby Implementation
Ruby's implementation follows the standard pattern with:
- A minimalistic main TaintTracking module
- Language-specific taint steps like pattern matching, operations, etc.
- Integration with the shared TaintTracking framework

### JavaScript/TypeScript Implementation
JavaScript's implementation includes:
- Additional handling for browser-specific APIs
- Special handling for string manipulation and DOM operations
- Legacy support for older style TaintTracking::Configuration

### Python Implementation
Python's implementation provides:
- Specific handling for Python's dynamic features
- Support for container operations and string manipulation
- Integration with the type tracking system
