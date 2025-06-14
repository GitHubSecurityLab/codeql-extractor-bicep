/**
 *  Internal implementation for Parameters
 *
 *  WARNING: this file is generated, do not edit manually
 */
private import AstNodes
private import TreeSitter
private import codeql.bicep.ast.AstNodes
private import Parameter

/**
 *  A Parameters AST Node.
 */
class ParametersImpl extends TParameters, AstNode {
  private BICEP::Parameters ast;

  override string getAPrimaryQlClass() { result = "Parameters" }

  ParametersImpl() { this = TParameters(ast) }

  override string toString() { result = ast.toString() }

  ParameterImpl getParameter(int index) {
    toTreeSitter(result) = ast.getChild(index)
  }

}