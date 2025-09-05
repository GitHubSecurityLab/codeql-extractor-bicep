private import bicep

query predicate conditional(Conditionals ast) { any() }

query predicate ifCondition(IfStatement ifStmt, Expr condition, Expr body) {
  ifStmt.getCondition() = condition and
  ifStmt.getBody() = body
}
