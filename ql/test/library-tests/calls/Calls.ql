private import bicep

query predicate callable(Callable callable) { any() }

query predicate callArguments(CallExpression call, Expr argument) { call.getArguments() = argument }
