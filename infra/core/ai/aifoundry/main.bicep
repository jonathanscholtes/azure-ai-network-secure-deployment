
param projectName string
param environmentName string
param resourceToken string
param location string
param identityName string
param vnetId string
param subnetName string

@description('the Application Insights instance used for monitoring')
param appInsightsName string

param aiSearchTarget string
param searchServiceId string
param storageAccountId string

param agentSubnetId string


@description('Resource ID of the key vault resource for storing connection strings')
param keyVaultId string


var accountName  = 'fnd-${projectName}-${environmentName}-${resourceToken}'
var aiProjectName  = 'prj-${projectName}-${environmentName}-${resourceToken}'


module aiaccount 'modules/ai-account.bicep' = {
  name: 'aiAccount'
  params: {
    accountName: accountName
    location: location
    identityName: identityName
    customSubdomain: 'fnd-${projectName}-${environmentName}-${resourceToken}'
    storageAccountResourceId:storageAccountId
    appInsightsName:appInsightsName
    vnetId:vnetId
    subnetName:subnetName
    
  }
}

module aiAccountPE 'modules/ai-account-private-endpoint.bicep' = { 
  name: 'aiServicePE'
  params: { 
     accountName:accountName
      location:location
      vnetId:vnetId
      subnetName:'servicesSubnet'
  }
  dependsOn:[aiaccount]
}

module aiModels 'modules/ai-models.bicep' = {
  name:'aiModels'
  params:{
    accountName:aiaccount.outputs.aiAccountName
  }
  dependsOn: [aiaccount]
}


module aiProjects 'modules/ai-project.bicep' =  {
  name: 'aiProjects-${environmentName}'
  params: {
    accountName:aiaccount.outputs.aiAccountName
    location: location
    aiProjectName: aiProjectName
    aiProjectFriendlyName: 'AI Project - ${projectName}'
    aiProjectDescription: 'Project for ${projectName} in ${environmentName} environment'
  }
  dependsOn:[aiaccount]
}




output aiservicesTarget string = aiaccount.outputs.aiAccountTarget
output OpenAIEndPoint string = aiaccount.outputs.OpenAIEndPoint
output aiProjectPrincipalId string = aiProjects.outputs.aiProjectPrincipalId
output aiAccountName string = aiaccount.outputs.aiAccountName
output aiAccountPrincipalId string = aiaccount.outputs.aiAccountPrincipalId
output aiServicesPrivateEndpointName string = aiAccountPE.outputs.aiServicesPrivateEndpointName
output aiProjectEndpoint string = aiProjects.outputs.aiProjectEndpoint
