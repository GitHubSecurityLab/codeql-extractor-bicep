private import codeql.Locations
private import codeql.files.FileSystem
private import codeql.bicep.ast.internal.TreeSitter
private import codeql.bicep.ast.internal.AstNodes
private import codeql.bicep.ast.internal.TreeSitter
private import codeql.bicep.controlflow.ControlFlowGraph
private import Variables

/**
 * An AST node of a Bicep program.
 * 
 * This is the base class for all syntax nodes in the Bicep language. All
 * Bicep entities that have a representation in the abstract syntax tree
 * (such as expressions, statements, resources, parameters, etc.) extend this class.
 */
class AstNode extends TAstNode {
  private BICEP::AstNode node;

  AstNode() { toTreeSitter(this) = node }

  /**
   * Gets a string representation of this AST node.
   * 
   * By default, returns the primary QL class name of this node.
   */
  string toString() { result = this.getAPrimaryQlClass() }

  /** 
   * Gets the location of the AST node.
   * 
   * The location includes information about the file, and the start and
   * end positions of the node in the file (line and column).
   */
  cached
  Location getLocation() { result = this.getFullLocation() } // overridden in some subclasses

  /** 
   * Gets the file containing this AST node.
   * 
   * This is the source file where this AST node is defined.
   */
  cached
  File getFile() { result = this.getFullLocation().getFile() }

  /** 
   * Gets the location that spans the entire AST node.
   * 
   * This includes the full text range covered by this node and all its children.
   */
  cached
  final Location getFullLocation() { result = toTreeSitter(this).getLocation() }

  /**
   * Holds if this AST node has the specified location information.
   * 
   * @param filepath The file path
   * @param startline The start line
   * @param startcolumn The start column
   * @param endline The end line
   * @param endcolumn The end column
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    if exists(this.getLocation())
    then this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    else (
      filepath = "" and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    )
  }

  /**
   * Gets the parent in the AST for this node.
   * 
   * This is the immediately enclosing syntax node in the AST.
   * For example, the parent of an expression might be a statement that contains it.
   */
  cached
  AstNode getParent() { result.getAChild() = this }

  /**
   * Gets a child of this node.
   * 
   * This returns any direct child node in the AST hierarchy.
   * The exact set of child nodes depends on the specific type of AST node.
   */
  cached
  AstNode getAChild() { toTreeSitter(result) = node.getAFieldOrChild() }

  /** 
   * Gets the CFG scope that encloses this node, if any.
   * 
   * A CFG scope is a region of code that has its own control flow graph.
   * This can include the entire file, functions, or other code blocks with
   * independent control flow.
   */
  cached
  CfgScope getEnclosingCfgScope() {
    exists(AstNode p | p = this.getParent*() |
      result = p
      or
      not p instanceof CfgScope and
      result = p.getEnclosingCfgScope()
    )
  }

  /**
   * Gets the primary QL class for the AST node.
   * 
   * This returns the name of the most specific QL class that describes this node.
   * Used primarily for debugging and toString() representations.
   * Gets the lexical scope containing this AST node.
   */
  cached
  Scope getScope() {
    result = this.getParent+() and
    not exists(AstNode mid |
      mid = this.getParent+() and
      mid instanceof Scope and
      mid.getParent+() = result
    )
  }

  /**
   * Gets the primary QL class for the ast node.
   */
  string getAPrimaryQlClass() { result = "???" }
}

/** 
 * A Bicep file.
 * 
 * Represents a source file written in the Bicep language. This class provides
 * access to file metadata and metrics such as the total number of lines and
 * lines of code.
 */
class BicepFile extends File {
  BicepFile() { exists(Location loc | bicep_ast_node_location(_, loc) and this = loc.getFile()) }

  /** 
   * Gets a token in this file.
   * 
   * A token is a basic syntactic unit recognized by the lexer.
   */
  private BICEP::Token getAToken() { result.getLocation().getFile() = this }

  /** 
   * Holds if `line` contains a token.
   * 
   * This is used to calculate metrics like the number of lines of code.
   */
  private predicate line(int line) {
    exists(BICEP::Token token, Location l |
      token = this.getAToken() and
      l = token.getLocation() and
      line in [l.getStartLine() .. l.getEndLine()]
    )
  }

  /** 
   * Gets the number of lines in this file.
   * 
   * This counts the total number of lines in the file, including empty lines
   * and comment lines.
   */
  int getNumberOfLines() { result = max([0, this.getAToken().getLocation().getEndLine()]) }

  /** 
   * Gets the number of lines of code in this file.
   * 
   * This counts only lines that contain at least one token, which excludes
   * completely empty lines.
   */
  int getNumberOfLinesOfCode() { result = count(int line | this.line(line)) }
}

/**
 * A comment in a Bicep program.
 * 
 * Represents a single- or multi-line comment in Bicep source code.
 * Comments may be either single-line (// comment) or multi-line (/* comment *\/).
 */
class Comment extends AstNode, TComment {
  private BICEP::Comment comment;

  override string getAPrimaryQlClass() { result = "Comment" }

  Comment() { this = TComment(comment) }

  /**
   * Gets the text content of the comment.
   *
   * For a single-line comment, this is the text after the // delimiter.
   * For a multi-line comment, this is the text between the /* and *\/ delimiters.
   *
   * Note: This method is currently a placeholder and needs implementation.
   * 
   * @return The text content of the comment (currently an empty string)
   */
  string getContents() { result = "" }
}
