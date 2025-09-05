private import Expr
private import AstNodes
private import internal.Types
private import internal.Type
private import internal.ArrayType
private import internal.NegatedType
private import internal.ParameterizedType
private import internal.ParenthesizedType
private import internal.PrimitiveType
private import internal.TypeArguments
private import internal.TypeDeclaration
private import internal.UnionType

/**
 * The Super Type
 */
class Types extends Expr instanceof TypesImpl {
    string getValue() { result = super.getValue() }
}

/**
 * A type node in the AST.
 * 
 * This class represents all type annotations in Bicep, including primitive types
 * (like string, int, bool), complex types (like arrays, objects), and user-defined
 * types. Types are used in parameter declarations, variable declarations, function
 * return types, and other contexts to specify the kind of values that are expected.
 */
class Type extends Types instanceof TypeImpl {
  /**
   * Gets the name of this type as a string.
   * 
   * For primitive types, this will be the name of the type (e.g., "string", "int").
   * For complex types, this will be a representation of the type structure.
   * 
   * @return The type name or representation as a string
   */
  string getType() { result = TypeImpl.super.getType() }
}

/**
 * An array type node in the AST.
 *
 * This class represents array type annotations in Bicep (e.g., `string[]`).
 * Array types are used to specify that a value should be an array of elements
 * of the specified element type.
 *
 * Example:
 * ```bicep
 * param names string[] // Array of strings
 * ```
 */
class ArrayType extends Types instanceof ArrayTypeImpl {
  /**
   * Gets the element type of this array type.
   *
   * For example, in `string[]`, this returns the `string` type.
   *
   * @return The element type of the array
   */
  Type getElementType() {
    result = ArrayTypeImpl.super.getElementType()
  }
}

/**
 * A negated type node in the AST.
 * 
 * This class represents negated type annotations in Bicep (e.g., `!string`).
 * Negated types are used to specify that a value should not be of the specified type.
 *
 * Example:
 * ```bicep
 * param value !string // Any type except string
 * ```
 */
class NegatedType extends Types instanceof NegatedTypeImpl {
  /**
   * Gets the negated type.
   *
   * For example, in `!string`, this returns the `string` type.
   *
   * @return The negated type
   */
  Type getNegatedType() {
    result = NegatedTypeImpl.super.getNegatedType()
  }
}

/**
 * A parameterized type node in the AST.
 *
 * This class represents parameterized type annotations in Bicep.
 * Parameterized types are generic types with type parameters.
 *
 * Example:
 * ```bicep
 * param values array<string> // Array of strings
 * ```
 */
class ParameterizedType extends Types instanceof ParameterizedTypeImpl { }

/**
 * A parenthesized type node in the AST.
 *
 * This class represents parenthesized type annotations in Bicep (e.g., `(string|int)`).
 * Parenthesized types are used to group types for clarity or precedence.
 *
 * Example:
 * ```bicep
 * param value (string|int) // Either string or int
 * ```
 */
class ParenthesizedType extends Types instanceof ParenthesizedTypeImpl { }

/**
 * A primitive type node in the AST.
 *
 * This class represents primitive type annotations in Bicep (e.g., `string`, `int`, `bool`).
 * Primitive types are the basic built-in types in the language.
 *
 * Example:
 * ```bicep
 * param name string // String type
 * param count int   // Integer type
 * param enabled bool // Boolean type
 * ```
 */
class PrimitiveType extends Types instanceof PrimitiveTypeImpl { }

/**
 * A type arguments node in the AST.
 *
 * This class represents type arguments in parameterized types.
 * Type arguments specify the concrete types to use for generic type parameters.
 *
 * Example:
 * ```bicep
 * param values array<string> // <string> is the type argument
 * ```
 */
class TypeArguments extends Types instanceof TypeArgumentsImpl { }

/**
 * A type declaration node in the AST.
 *
 * This class represents type declarations in Bicep.
 * Type declarations define new named types that can be used in the program.
 *
 * Example:
 * ```bicep
 * type Person = {
 *   name: string
 *   age: int
 * }
 * ```
 */
class TypeDeclaration extends Types instanceof TypeDeclarationImpl { }

/**
 * A union type node in the AST.
 *
 * This class represents union type annotations in Bicep (e.g., `string|int`).
 * Union types are used to specify that a value can be of multiple possible types.
 *
 * Example:
 * ```bicep
 * param value string|int // Either string or int
 * ```
 */
class UnionType extends Types instanceof UnionTypeImpl { }
