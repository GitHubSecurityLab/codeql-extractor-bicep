private import bicep

query predicate loops(Loops loops) { any() }

query predicate loopsConditionals(Loops loops, Expr condition) { 
  loops.getCondition() = condition
}
