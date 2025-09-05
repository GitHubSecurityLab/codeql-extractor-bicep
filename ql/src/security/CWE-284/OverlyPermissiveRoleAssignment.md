# Overly Permissive Role Assignment

## Description

This query identifies Azure role assignments in Bicep templates that grant excessive privileges by assigning privileged roles (Owner, Contributor, User Access Administrator) at broad scopes (subscription or resource group level). Such assignments violate the principle of least privilege and can lead to security risks.

## Query Logic

The query works by:

1. **Identifying Role Assignment Resources**: Finds all `Microsoft.Authorization/roleAssignments` resources in the Bicep template
2. **Checking Role Privileges**: Determines if the assigned role is a privileged built-in role:
   - Owner (`8e3af657-a8ff-443c-a75c-2fe8c4bcb635`)
   - Contributor (`b24988ac-6180-42a0-ab88-20f7382dd24c`)
   - User Access Administrator (`18d7d88d-d35e-4fb5-a5c3-7773c20a72d9`)
3. **Analyzing Scope**: Checks if the role assignment scope is broad:
   - Subscription-level scope (using `subscription()` function)
   - Resource group-level scope (using `resourceGroup()` function)
4. **Flagging Issues**: Reports role assignments that combine privileged roles with broad scopes

## Insecure Code Examples

### Contributor Role at Subscription Scope
```bicep
// INSECURE: Broad "Contributor" at subscription scope
resource subRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, spObjectId, 'contributor-assignment')
  scope: subscription()
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
    principalId: spObjectId
    principalType: 'ServicePrincipal'
  }
}
```

### Owner Role at Resource Group Scope
```bicep
// INSECURE: Owner role at resource group level
resource rgOwnerRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userObjectId, 'owner-assignment')
  scope: resourceGroup()
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635') // Owner
    principalId: userObjectId
    principalType: 'User'
  }
}
```

## Secure Coding Recommendations

### 1. Use Least-Privilege Built-in Roles
Instead of broad roles like Contributor, use specific roles that grant only the necessary permissions:

```bicep
// SECURE: Specific role for storage operations
resource scopedRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(stg.id, spObjectId, 'storage-blob-reader')
  scope: stg
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe') // Storage Blob Data Reader
    principalId: spObjectId
    principalType: 'ServicePrincipal'
  }
}
```

### 2. Narrow the Scope to Specific Resources
Assign roles at the resource level rather than subscription or resource group level:

```bicep
// SECURE: Role assignment scoped to specific storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: 'app${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  // ... other properties
}

resource scopedRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccount.id, spObjectId, roleDefinitionId)
  scope: storageAccount  // Scoped to specific resource
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: spObjectId
    principalType: 'ServicePrincipal'
  }
}
```

### 3. Use Parameter Constraints
When role assignment is parameterized, restrict the allowed roles using the `@allowed` decorator:

```bicep
@allowed([
  'ba92f5b4-2d11-453d-a403-e96b0029c9fe', // Storage Blob Data Reader
  '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'  // Storage Blob Data Contributor
])
@description('Role definition ID to assign (restricted to approved least-privilege roles)')
param roleDefinitionId string
```

### 4. Create Custom Roles for Specific Use Cases
Define custom roles with exactly the permissions needed:

```bicep
resource customRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(resourceGroup().id, 'custom-limited-role')
  scope: resourceGroup()
  properties: {
    roleName: 'Custom Limited Role'
    description: 'Custom role with limited permissions'
    permissions: [
      {
        actions: [
          'Microsoft.Resources/subscriptions/resourceGroups/read'
          'Microsoft.Storage/storageAccounts/read'
        ]
        notActions: []
      }
    ]
    assignableScopes: [
      resourceGroup().id
    ]
  }
}
```

## Security Impact

Overly permissive role assignments can lead to:

- **Privilege Escalation**: Compromised principals can create additional resources or modify permissions
- **Lateral Movement**: Broad scope allows access to more resources than necessary
- **Compliance Violations**: Violates principle of least privilege required by security frameworks
- **Audit Complexity**: Makes it harder to track and audit access patterns

## References

- [CWE-284: Improper Access Control](https://cwe.mitre.org/data/definitions/284.html)
- [Azure RBAC Best Practices](https://docs.microsoft.com/en-us/azure/role-based-access-control/best-practices)
- [Azure Built-in Roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)
- [MITRE ATT&CK T1098: Account Manipulation](https://attack.mitre.org/techniques/T1098/)