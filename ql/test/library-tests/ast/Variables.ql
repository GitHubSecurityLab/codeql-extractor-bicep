private import bicep

query predicate variables(Variable var) { any() }

query predicate variableAccess(Variable var, VariableAccess access) { var.getAnAccess() = access }

query predicate variableRead(VariableReadAccess reada) { any() }

query predicate variableWrite(VariableWriteAccess writeAccess) { any() }
