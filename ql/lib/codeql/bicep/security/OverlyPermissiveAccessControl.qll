/**
 * Security library for detecting overly permissive access control in Bicep templates.
 * 
 * This module provides classes and predicates to identify role assignments that grant
 * excessive privileges, particularly broad roles assigned at large scopes.
 */

private import bicep
private import codeql.bicep.frameworks.Microsoft.Authorization

module OverlyPermissiveAccessControl {
  /**
   * Predicate to identify role assignments with overly broad scope.
   */
  predicate hasOverlyBroadScope(Authorization::RoleAssignmentResource roleAssignment) {
    roleAssignment.hasBroadScope()
  }

  /**
   * Predicate to identify role assignments with privileged roles.
   */
  predicate grantsPrivilegedRole(Authorization::RoleAssignmentResource roleAssignment) {
    roleAssignment.grantsPrivilegedRole()
  }

  /**
   * Predicate to identify role assignments that are overly permissive.
   */
  predicate isOverlyPermissive(Authorization::RoleAssignmentResource roleAssignment) {
    roleAssignment.isOverlyPermissive()
  }

  /**
   * Gets a description of why a role assignment is overly permissive.
   */
  string getPermissiveDescription(Authorization::RoleAssignmentResource roleAssignment) {
    exists(string role, string scope |
      (
        roleAssignment.getRoleDefinitionId() = "8e3af657-a8ff-443c-a75c-2fe8c4bcb635" and
        role = "Owner"
        or
        roleAssignment.getRoleDefinitionId() = "b24988ac-6180-42a0-ab88-20f7382dd24c" and
        role = "Contributor"
        or
        roleAssignment.getRoleDefinitionId() = "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9" and
        role = "User Access Administrator"
      ) and
      (
        roleAssignment.isSubscriptionScoped() and scope = "subscription"
        or
        roleAssignment.isResourceGroupScoped() and scope = "resource group"
      ) and
      result = role + " role assigned at " + scope + " scope"
    )
  }
}