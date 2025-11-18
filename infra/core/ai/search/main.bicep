param searchServicename string
param identityName string
param location string
param vnetId string
param subnetName string


module search_service 'modules/search-service.bicep' = { 
 name: 'search_service'
 params: { 
   name: searchServicename
   location:location
    semanticSearch: 'standard'
    disableLocalAuth: false
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http403'
      }}
    publicNetworkAccess: 'disabled'
    vnetId:vnetId
    subnetName:subnetName
 }
}

module search_roles 'modules/search-roles.bicep' = { 
  name: 'search_roles'
  params: { 
    identityName: identityName
     searchServicename: searchServicename
  }
  dependsOn:[search_service]
}

module searchPE 'modules/search-private-endpoint.bicep' = { 
  name: 'searchPE'
  params: { 
    vnetId:vnetId
    aiSearchName:searchServicename
    location:location
    subnetName: 'servicesSubnet'
  }
  dependsOn:[search_service]
}


output searchServiceId string = search_service.outputs.searchServiceId
output searchServiceEndpoint string = search_service.outputs.searchServiceEndpoint
output searchServicePrincipalId string = search_service.outputs.searchServicePrincipalId
output searchServiceName string = search_service.outputs.searchServiceName
output searchPrivateEndpointName string = searchPE.outputs.searchPrivateEndpointName
