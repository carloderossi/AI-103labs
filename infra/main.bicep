param accountName string
param location string
param projectName string
//param keyVaultName string
param projectDescription string = ''
param projectDisplayName string = projectName

param modelName string
param modelFormat string
param modelVersion string
param modelCapacity int
param modelSkuName string

//
// Main Cognitive Services Account
//
resource account 'Microsoft.CognitiveServices/accounts@2025-10-01-preview' = {
  name: accountName
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'AIServices'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    apiProperties: {}
    customSubDomainName: accountName
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    allowProjectManagement: true
    defaultProject: projectName
    associatedProjects: [
      projectName
    ]
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
  }
}

//
// Project
//
resource project 'Microsoft.CognitiveServices/accounts/projects@2025-10-01-preview' = {
  parent: account
  name: projectName
  location: location
  // kind: 'AIServices'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: projectDescription
    displayName: projectDisplayName
  }
}

// resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
//   name: keyVaultName
//   location: location
//   properties: {
//     tenantId: subscription().tenantId
//     sku: {
//       family: 'A'
//       name: 'standard'
//     }
//     accessPolicies: []
//   }
// }

// resource apiKeySecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
//   parent: keyVault
//   name: 'ai-api-key'
//   properties: {
//     value: account.listKeys().key1
//   }
// }

resource modelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01'= {
  parent: account
  name: modelName
  sku : {
    capacity: modelCapacity
    name: modelSkuName
  }
  properties: {
    model:{
      name: modelName
      format: modelFormat
      version: modelVersion
    }
  }
}

// resource kvSecretsUserRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(keyVault.id, 'kv-secrets-user', '050b124e-108e-4780-b9b1-4bdd2358f6c4')
//   scope: keyVault
//   properties: {
//     roleDefinitionId: subscriptionResourceId(
//       'Microsoft.Authorization/roleDefinitions',
//       '4633458b-17de-408a-b874-0445c86b69e6' // Key Vault Secrets User
//     )
//     principalId: '050b124e-108e-4780-b9b1-4bdd2358f6c4'
//     principalType: 'ServicePrincipal'
//   }
// }

output accountName string = account.name
output projectName string = project.name
output accountEndpoint string = account.properties.endpoint
output openaiEndpoint string = account.properties.endpoint
output projectEndpoints object = project.properties.endpoints
output apiKey string = account.listKeys().key1
// output secondaryKey string = account.listKeys().key2  // if you want both
