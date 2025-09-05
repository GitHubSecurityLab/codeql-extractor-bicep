
/**
 * Calls
 */
private import codeql.bicep.ast.AstNodes
private import AstNodes
private import TreeSitter
private import Expr
private import Idents
private import Stmts
private import Type

abstract class CallableImpl extends ExprImpl, TCallable {
  override string getAPrimaryQlClass() { result = "Callable" }

  override string toString() { result = this.getAPrimaryQlClass() }

  abstract AstNode getIdentifier();

  predicate hasIdentifier() { exists(this.getIdentifier()) }

  string getName() { result = this.getIdentifier().(IdentsImpl).getName() }

  abstract ExprImpl getParameters();

  abstract ExprImpl getParameter(int n);

  abstract StmtSequenceImpl getBody();

  int getNumberOfParameters() { result = count(int i | exists(this.getParameter(i))) }

  abstract TypeImpl getType();

  string getTypeValue() { result = this.getType().getType() }
}

/**
 * Call Expression
 */
abstract class CallImpl extends ExprImpl, TCall {
  override string getAPrimaryQlClass() { result = "Calls" }

  override string toString() { result = this.getAPrimaryQlClass() }

  abstract AstNode getIdentifier();

  string getName() { result = this.getIdentifier().(IdentsImpl).getName() }

  abstract ExprImpl getArguments();

  abstract ExprImpl getArgument(int n);

  abstract ExprImpl getArgumentByName(string name);

  abstract IdentsImpl getReceiver();

  string getReceiverName() {
    exists(IdentsImpl ident | ident = this.getReceiver() | result = ident.getName())
  }

  abstract int getNumberOfArguments();
}