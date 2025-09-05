/**
 * Authorization resource framework for Microsoft.Authorization resources in Bicep.
 *
 * Provides classes for working with Azure role assignments and other authorization resources.
 *
 * Classes:
 * - RoleAssignmentResource: Represents Microsoft.Authorization/roleAssignments resources.
 * - RoleAssignmentProperties: Properties object for role assignments.
 */

private import bicep
private import codeql.bicep.frameworks.Microsoft.General

module Authorization {
  private import RoleAssignmentProperties

  /**
   * Represents a Microsoft.Authorization/roleAssignments resource in a Bicep file.
   * See: https://learn.microsoft.com/en-us/azure/templates/microsoft.authorization/roleassignments
   */
  class RoleAssignmentResource extends AzureResource {
    /**
     * Constructs a RoleAssignmentResource for Microsoft.Authorization/roleAssignments resources.
     */
    RoleAssignmentResource() {
      this.getResourceType().regexpMatch("^Microsoft.Authorization/roleAssignments@.*")
    }

    /**
     * Returns the properties object for the role assignment resource.
     */
    Properties getProperties() { result = this.getProperty("properties") }

    /**
     * Returns the scope property of the role assignment.
     * This can be a reference to a subscription, resource group, or specific resource.
     */
    Expr getScope() { result = this.getProperty("scope") }

    /**
     * Returns the name property of the role assignment (typically a GUID).
     */
    override string getName() {
      exists(StringLiteral name |
        name = this.getProperty("name") and
        result = name.getValue()
      )
    }

    /**
     * Gets the role definition ID from the properties.
     * This identifies which Azure built-in or custom role is being assigned.
     * It may be a direct string literal or extracted from a function call.
     */
    string getRoleDefinitionId() { 
      result = this.getProperties().getRoleDefinitionId()
    }

    /**
     * Gets the principal ID from the properties.
     * This identifies the user, group, or service principal receiving the role assignment.
     */
    string getPrincipalId() { result = this.getProperties().getPrincipalId() }

    /**
     * Gets the principal type from the properties.
     * This indicates whether the principal is a User, Group, or ServicePrincipal.
     */
    string getPrincipalType() { result = this.getProperties().getPrincipalType() }

    /**
     * Determines if this is a subscription-scoped role assignment.
     */
    predicate isSubscriptionScoped() {
      exists(CallExpression call |
        call = this.getScope() and
        call.getName() = "subscription"
      )
    }

    /**
     * Determines if this is a resource group-scoped role assignment.
     */
    predicate isResourceGroupScoped() {
      exists(CallExpression call |
        call = this.getScope() and
        call.getName() = "resourceGroup"
      )
    }

    /**
     * Determines if this role assignment has a broad scope (subscription or resource group).
     */
    predicate hasBroadScope() {
      this.isSubscriptionScoped() or this.isResourceGroupScoped()
    }

    /**
     * Determines if this role assignment grants a powerful built-in role.
     * Checks for common powerful roles like Owner and Contributor.
     */
    predicate grantsPrivilegedRole() {
      exists(string roleId | roleId = this.getRoleDefinitionId() |
        // Owner role
        roleId = "8e3af657-a8ff-443c-a75c-2fe8c4bcb635" or
        // Contributor role  
        roleId = "b24988ac-6180-42a0-ab88-20f7382dd24c" or
        // User Access Administrator role
        roleId = "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
      )
    }

    /**
     * Determines if this role assignment is overly permissive.
     * This checks for privileged roles assigned at broad scopes.
     */
    predicate isOverlyPermissive() {
      this.hasBroadScope() and this.grantsPrivilegedRole()
    }
  }

  /**
   * Module containing property classes for role assignment resources.
   */
  private module RoleAssignmentProperties {
    /**
     * Represents the properties object of a role assignment resource.
     */
    class Properties extends ResourceProperties {
      private RoleAssignmentResource parent;

      /**
       * Constructor for the Properties class.
       */
      Properties() { this = parent.getProperty("properties") }

      /**
       * Gets the role definition ID property.
       */
      Expr getRoleDefinitionIdProperty() { result = this.getProperty("roleDefinitionId") }

      /**
       * Returns the role definition ID as a string.
       * This handles both direct string literals and subscriptionResourceId function calls.
       */
      string getRoleDefinitionId() { 
        // Direct string literal
        result = this.getRoleDefinitionIdProperty().(StringLiteral).getValue()
        or
        // Extract from subscriptionResourceId function call
        exists(CallExpression call |
          call = this.getRoleDefinitionIdProperty() and
          call.getName() = "subscriptionResourceId" and
          result = call.getArgument(1).(StringLiteral).getValue()
        )
      }

      /**
       * Determines if the role definition ID property exists.
       */
      predicate hasRoleDefinitionId() { exists(this.getRoleDefinitionIdProperty()) }

      /**
       * Gets the principal ID property.
       */
      Expr getPrincipalIdProperty() { result = this.getProperty("principalId") }

      /**
       * Returns the principal ID as a string.
       */
      string getPrincipalId() { result = this.getPrincipalIdProperty().(StringLiteral).getValue() }

      /**
       * Determines if the principal ID property exists.
       */
      predicate hasPrincipalId() { exists(this.getPrincipalIdProperty()) }

      /**
       * Gets the principal type property.
       */
      Expr getPrincipalTypeProperty() { result = this.getProperty("principalType") }

      /**
       * Returns the principal type as a string.
       */
      string getPrincipalType() { result = this.getPrincipalTypeProperty().(StringLiteral).getValue() }

      /**
       * Determines if the principal type property exists.
       */
      predicate hasPrincipalType() { exists(this.getPrincipalTypeProperty()) }

      override string toString() { result = "RoleAssignmentProperties" }
    }
  }
}