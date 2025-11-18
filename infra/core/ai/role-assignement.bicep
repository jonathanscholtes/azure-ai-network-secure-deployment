

@description('AI Project Id')
param aiProjectPrincipalId string

@description('AI Account Name')
param aiAccountName string

@description('AI Account Id')
param aiAccountPrincipalId string

@description('Search Service Name')
param searchServiceName string

@description('Search Service Id')
param searchServicePrincipalId string

@description('Storage Name')
param storageName string

@description('Private Endpoint IDs for Storage, AI Services, and Search')
param storagePrivateEndpointName string
param aiServicesPrivateEndpointName string
param searchPrivateEndpointName string

var role = {
  SearchIndexDataContributor: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
  SearchServiceContributor: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
  SearchIndexDataReader: '1407120a-92aa-4202-b7e9-c0e197c71c8f'
  StorageBlobDataReader: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  StorageBlobDataContributor: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  CognitiveServicesOpenAiContributor: 'a001fd3d-188f-4b5d-821b-7da978bf7442'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
}


resource searchService 'Microsoft.Search/searchServices@2023-11-01' existing = {
  name: searchServiceName
}

resource aiAccount 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: aiAccountName
}

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageName
}


resource storagePrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' existing ={
  name:storagePrivateEndpointName
}

resource aiServicesPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' existing ={
  name:aiServicesPrivateEndpointName
}


resource searchPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' existing ={
  name:searchPrivateEndpointName
}



// AI Service Identity
resource searchIndexDataContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'SearchIndexDataContributor')
  scope: searchService
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.SearchIndexDataContributor)
    principalId: aiAccountPrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource searchServiceContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'SearchServiceContributor')
  scope: searchService
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.SearchServiceContributor)
    principalId: aiAccountPrincipalId
    principalType: 'ServicePrincipal'
  }
}


resource storageBlobDataContributorAI 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'StorageBlobDataContributorAI')
  scope: storage
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.StorageBlobDataContributor)
    principalId: aiAccountPrincipalId
    principalType: 'ServicePrincipal'
  }
}


// AI Search Service Identity
resource cognitiveServicesOpenAiContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'CognitiveServicesOpenAiContributor')
  scope: aiAccount
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.CognitiveServicesOpenAiContributor)
    principalId: searchServicePrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource storageBlobDataContributorSearch 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'StorageBlobDataContributorSearch')
  scope: storage
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.StorageBlobDataContributor)
    principalId: searchServicePrincipalId
    principalType: 'ServicePrincipal'
  }
}


// AI Project Identity Assignments
resource aiProjectSearchIndexReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'AIProjectSearchIndexDataReader')
  scope: searchService
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.SearchIndexDataReader)
    principalId: aiProjectPrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource aiProjectSearchServiceContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'AIProjectSearchServiceContributor')
  scope: searchService
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.SearchServiceContributor)
    principalId: aiProjectPrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource aiProjectStorageReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'AIProjectStorageReader')
  scope: storagePrivateEndpoint
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.Reader)
    principalId: aiProjectPrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource aiProjectAiServicesReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'AIProjectAiServicesReader')
  scope: aiServicesPrivateEndpoint
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.Reader)
    principalId: aiProjectPrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource aiProjectSearchReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'AIProjectSearchReader')
  scope: searchPrivateEndpoint
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.Reader)
    principalId: aiProjectPrincipalId
    principalType: 'ServicePrincipal'
  }
}


output aiProjectPrincipalId string = aiProjectPrincipalId
output aiAccountPrincipalId string = aiAccountPrincipalId
output searchServicePrincipalId string = searchServicePrincipalId
