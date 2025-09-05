private import bicep

query predicate ast(AstNode ast) { any() }

query predicate infra(Infrastructure infra, int index, Stmts stmts) {
  stmts = infra.getStmt(index)
}

query predicate strings(String str, string output) { output = str.getValue() }
