private import AstNodes
private import Expr
private import internal.Idents
private import internal.Identifier
private import internal.PropertyIdentifier
private import internal.CompatibleIdentifier

/**
 * The base class for all identifiers in the AST.
 * 
 * This abstract class represents all types of identifiers in Bicep, including
 * variable names, property names, parameter names, and resource identifiers.
 * Identifiers are names that refer to declared entities in the program.
 */
abstract class Idents extends Expr instanceof IdentsImpl {
    /**
     * Gets the name of this identifier as a string.
     * 
     * @return The name of this identifier
     */
    abstract string getName();
}

/**
 * A regular identifier in the AST.
 * 
 * Represents a standard identifier that refers to a variable, parameter, resource,
 * or other named entity in a Bicep program. For example, in an expression like
 * `myVariable`, `myVariable` is represented by an Identifier.
 */
class Identifier extends Idents instanceof IdentifierImpl {
    /**
     * Gets the name of this identifier as a string.
     * 
     * @return The name of this identifier
     */
    override string getName() { result = IdentifierImpl.super.getName() }
}

/**
 * A property identifier in the AST.
 * 
 * Represents the name part of a property in an object literal. For example,
 * in the property `name: 'example'`, `name` is represented by a PropertyIdentifier.
 * Property identifiers are used as keys in object literals.
 * 
 * In Bicep, property identifiers appear in object literals and resource declarations:
 * 
 * ```bicep
 * var myObject = {
 *   name: 'value',  // 'name' is a PropertyIdentifier
 *   type: 'string'  // 'type' is a PropertyIdentifier
 * }
 * ```
 */
class PropertyIdentifier extends Idents instanceof PropertyIdentifierImpl {
    /**
     * Gets the name of this property identifier as a string.
     * 
     * @return The name of this property identifier
     */
    override string getName() { result = PropertyIdentifierImpl.super.getName() }
}

/**
 * A compatible identifier in the AST.
 * 
 * Represents an identifier that is compatible with certain naming conventions.
 * Compatible identifiers are often used when a standard identifier is needed
 * in contexts that have specific compatibility requirements.
 */
class CompatibleIdentifier extends Idents instanceof CompatibleIdentifierImpl {
    /**
     * Gets the name of this compatible identifier as a string.
     * 
     * @return The name of this compatible identifier
     */
    override string getName() { result = CompatibleIdentifierImpl.super.getName() }
    
    /**
     * Gets the underlying identifier.
     * 
     * @return The underlying identifier
     */
    Identifier getIdentifier() { result = CompatibleIdentifierImpl.super.getIdentifier() }
}
