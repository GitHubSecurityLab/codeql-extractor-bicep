private import AstNodes
private import internal.Array
private import internal.Boolean
private import internal.Decorator
private import internal.Decorators
private import internal.DiagnosticComment
private import internal.EscapeSequence
private import internal.ForLoopParameters
private import internal.ImportFunctionality
private import internal.LoopEnumerator
private import internal.LoopVariable
private import internal.MetadataDeclaration
private import internal.ModuleDeclaration
private import internal.ObjectProperty
private import internal.TargetScopeAssignment
private import internal.TestBlock

/**
 *  A Decorator unknown AST node.
 */
class Decorator extends AstNode instanceof DecoratorImpl { }

/**
 *  A Decorators unknown AST node.
 */
class Decorators extends AstNode instanceof DecoratorsImpl { }

/**
 *  A DiagnosticComment unknown AST node.
 */
class DiagnosticComment extends AstNode instanceof DiagnosticCommentImpl { }

/**
 *  A EscapeSequence unknown AST node.
 */
class EscapeSequence extends AstNode instanceof EscapeSequenceImpl { }

/**
 *  A ForLoopParameters unknown AST node.
 */
class ForLoopParameters extends AstNode instanceof ForLoopParametersImpl { }

/**
 *  A ImportFunctionality unknown AST node.
 */
class ImportFunctionality extends AstNode instanceof ImportFunctionalityImpl { }

/**
 *  A LoopEnumerator unknown AST node.
 */
class LoopEnumerator extends AstNode instanceof LoopEnumeratorImpl { }

/**
 *  A LoopVariable unknown AST node.
 */
class LoopVariable extends AstNode instanceof LoopVariableImpl { }

/**
 *  A MetadataDeclaration unknown AST node.
 */
class MetadataDeclaration extends AstNode instanceof MetadataDeclarationImpl { }

/**
 *  A ModuleDeclaration unknown AST node.
 */
class ModuleDeclaration extends AstNode instanceof ModuleDeclarationImpl { }

/**
 *  A TargetScopeAssignment unknown AST node.
 */
class TargetScopeAssignment extends AstNode instanceof TargetScopeAssignmentImpl { }

/**
 *  A TestBlock unknown AST node.
 */
class TestBlock extends AstNode instanceof TestBlockImpl { }
