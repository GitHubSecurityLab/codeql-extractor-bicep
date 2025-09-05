private import bicep

query predicate functions(UserDefinedFunction function) { any() }

query predicate functionParameters(UserDefinedFunction function, Parameter params) {
  function.getParameter(_) = params
}
