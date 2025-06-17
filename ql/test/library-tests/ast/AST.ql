private import bicep

query predicate ast(AstNode ast) { any() }

query predicate strings(String str, string output) { output = str.getValue() }

query predicate ifCondition(IfStatement ifStmt, Expr condition, Expr body) {
  ifStmt.getCondition() = condition and
  ifStmt.getBody() = body
}
