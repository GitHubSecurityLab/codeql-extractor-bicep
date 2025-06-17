private import AstNodes
private import internal.Array
private import internal.ArrayType
private import internal.Boolean
private import internal.CompatibleIdentifier
private import internal.Declaration
private import internal.Decorator
private import internal.Decorators
private import internal.DiagnosticComment
private import internal.EscapeSequence
private import internal.ForLoopParameters
private import internal.Identifier
private import internal.ImportFunctionality
private import internal.LoopEnumerator
private import internal.LoopVariable
private import internal.MetadataDeclaration
private import internal.ModuleDeclaration
private import internal.NegatedType
private import internal.ObjectProperty
private import internal.ParameterizedType
private import internal.ParenthesizedType
private import internal.PrimitiveType
private import internal.PropertyIdentifier
private import internal.TargetScopeAssignment
private import internal.TestBlock
private import internal.Type
private import internal.TypeArguments
private import internal.TypeDeclaration
private import internal.UnionType

/**
 *  A ArrayType unknown AST node.
 */
class ArrayType extends AstNode instanceof ArrayTypeImpl { }

/**
 *  A CompatibleIdentifier unknown AST node.
 */
class CompatibleIdentifier extends AstNode instanceof CompatibleIdentifierImpl { }

/**
 *  A Declaration unknown AST node.
 */
class Declaration extends AstNode instanceof DeclarationImpl { }

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
 *  A NegatedType unknown AST node.
 */
class NegatedType extends AstNode instanceof NegatedTypeImpl { }

/**
 *  A ParameterizedType unknown AST node.
 */
class ParameterizedType extends AstNode instanceof ParameterizedTypeImpl { }

/**
 *  A ParenthesizedType unknown AST node.
 */
class ParenthesizedType extends AstNode instanceof ParenthesizedTypeImpl { }

/**
 *  A PrimitiveType unknown AST node.
 */
class PrimitiveType extends AstNode instanceof PrimitiveTypeImpl { }

/**
 *  A TargetScopeAssignment unknown AST node.
 */
class TargetScopeAssignment extends AstNode instanceof TargetScopeAssignmentImpl { }

/**
 *  A TestBlock unknown AST node.
 */
class TestBlock extends AstNode instanceof TestBlockImpl { }

/**
 *  A Type unknown AST node.
 */
class Type extends AstNode instanceof TypeImpl {
  /**
   *  Returns the type of this AST node.
   */
  string getType() { result = TypeImpl.super.getType() }
}

/**
 *  A TypeArguments unknown AST node.
 */
class TypeArguments extends AstNode instanceof TypeArgumentsImpl { }

/**
 *  A TypeDeclaration unknown AST node.
 */
class TypeDeclaration extends AstNode instanceof TypeDeclarationImpl { }

/**
 *  A UnionType unknown AST node.
 */
class UnionType extends AstNode instanceof UnionTypeImpl { }
