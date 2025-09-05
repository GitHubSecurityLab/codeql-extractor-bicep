private import bicep

query predicate call(CallExpression callable) { any() }

query predicate callArguments(CallExpression call, Expr argument) { call.getArguments() = argument }
