param projectName string
param environmentName string
param resourceToken string
param location string
param identityName string
param searchServicename string
param vnetId string
param subnetName string

@description('the Application Insights instance used for monitoring')
param appInsightsName string

param storageAccountId string
param storageAccountTarget string
param storageAccountName string
param agentSubnetId string
param containerRegistryID string
param storagePrivateEndpointName string


@description('Resource ID of the key vault resource for storing connection strings')
param keyVaultId string


module search 'search/main.bicep' = { 
  name: 'search'
  params: {
  location:location
  identityName: identityName
  searchServicename: searchServicename
  subnetName: subnetName
  vnetId: vnetId
  }
}

module aifoundry 'aifoundry/main.bicep' = {
  name: 'aifoundry'
  params: { 
    location:location
    environmentName: environmentName
    identityName: identityName
    keyVaultId: keyVaultId
    projectName: projectName
    resourceToken: resourceToken
    subnetName: subnetName
    vnetId: vnetId
    appInsightsName: appInsightsName
    searchServiceId:search.outputs.searchServiceId
    aiSearchTarget:search.outputs.searchServiceEndpoint
    storageAccountId:storageAccountId
    agentSubnetId:agentSubnetId
  }

}

module aiRoleAssignment 'role-assignement.bicep' = {
  name: 'aiRoleAssignment'
  params: { 
    searchServiceName: search.outputs.searchServiceName
    searchServicePrincipalId:search.outputs.searchServicePrincipalId
    aiAccountName:aifoundry.outputs.aiAccountName
    aiAccountPrincipalId:aifoundry.outputs.aiAccountPrincipalId
    storageName:storageAccountName
    aiProjectPrincipalId: aifoundry.outputs.aiProjectPrincipalId
    aiServicesPrivateEndpointName: aifoundry.outputs.aiServicesPrivateEndpointName
    searchPrivateEndpointName: search.outputs.searchPrivateEndpointName
    storagePrivateEndpointName:storagePrivateEndpointName
  }
 }

output aiservicesTarget string = aifoundry.outputs.aiservicesTarget
output OpenAIEndPoint string = aifoundry.outputs.OpenAIEndPoint
output searchServiceEndpoint string = search.outputs.searchServiceEndpoint
output searchServiceName string = search.outputs.searchServiceName
