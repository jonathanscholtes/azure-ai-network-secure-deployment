metadata description = 'Creates an Azure AI Search instance.'
param name string
param location string = resourceGroup().location
param vnetId string
param subnetName string


param sku object = {
  name: 'standard'
}

param authOptions object = {}
param disableLocalAuth bool = false
param disabledDataExfiltrationOptions array = []
param encryptionWithCmk object = {
  enforcement: 'Unspecified'
}
@allowed([
  'default'
  'highDensity'
])
param hostingMode string = 'default'
param networkRuleSet object = {
  bypass: 'None'
  ipRules: []
}
param partitionCount int = 1
@allowed([
  'enabled'
  'disabled'
])
param publicNetworkAccess string = 'enabled'
param replicaCount int = 1
@allowed([
  'disabled'
  'free'
  'standard'
])
param semanticSearch string = 'disabled'

var searchIdentityProvider = (sku.name == 'free') ? null : {
  type: 'SystemAssigned'
}


resource search 'Microsoft.Search/searchServices@2025-02-01-preview' = {
  name: name
  location: location
  // The free tier does not support managed identity
  identity: searchIdentityProvider
  properties: {
    authOptions: disableLocalAuth ? null : authOptions
    disableLocalAuth: disableLocalAuth
    disabledDataExfiltrationOptions: disabledDataExfiltrationOptions
    encryptionWithCmk: encryptionWithCmk
    hostingMode: hostingMode
    networkRuleSet: {
      ipRules: []
      bypass: 'AzureServices'

    }
    partitionCount: partitionCount
    publicNetworkAccess: publicNetworkAccess
    replicaCount: replicaCount
    semanticSearch: semanticSearch
  }
  sku: sku
}

output searchServiceId string = search.id
output searchServiceEndpoint string = 'https://${name}.search.windows.net/'
output searchServicePrincipalId string = search.identity.principalId
output searchServiceName string = name
