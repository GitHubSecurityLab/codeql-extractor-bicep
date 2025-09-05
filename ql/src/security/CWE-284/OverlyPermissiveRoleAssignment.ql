/**
 * @name Overly permissive role assignment
 * @description Detects role assignments that grant privileged roles (Owner, Contributor) at broad scopes (subscription, resource group) which can lead to excessive privileges and potential security risks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id bicep/overly-permissive-role-assignment
 * @tags security
 *       bicep
 *       azure
 *       CWE-284
 */

import codeql.bicep.frameworks.Microsoft.Authorization

from Authorization::RoleAssignmentResource roleAssignment, string roleType, string scopeType
where
  roleAssignment.isOverlyPermissive() and
  (
    // Identify the role type
    exists(string roleId | roleId = roleAssignment.getRoleDefinitionId() |
      roleId = "8e3af657-a8ff-443c-a75c-2fe8c4bcb635" and roleType = "Owner"
      or
      roleId = "b24988ac-6180-42a0-ab88-20f7382dd24c" and roleType = "Contributor"
      or
      roleId = "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9" and roleType = "User Access Administrator"
    )
  ) and
  (
    // Identify the scope type
    roleAssignment.isSubscriptionScoped() and scopeType = "subscription"
    or
    roleAssignment.isResourceGroupScoped() and scopeType = "resource group"
  )
select roleAssignment,
  "This role assignment grants excessive privileges: " + roleType + " role assigned at " + scopeType +
    " scope. Consider using a more restrictive role or narrowing the scope to specific resources."