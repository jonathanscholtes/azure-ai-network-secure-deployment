@description('AI hub name')
param aiHubName string

@description('AI project name')
param aiProjectName string

@description('Name for Ai Search connection.')
param aiSearchConnectionName string

@description('Name for ACS connection.')
param aoaiConnectionName string

@description('Name for capabilityHost.')
param capabilityHostName string 

@description('Name for customer subnet id')
param customerSubnetId string = ''

var storageConnections = ['${aiProjectName}/workspaceblobstore']
var aiSearchConnection = ['${aiSearchConnectionName}']
var aiServiceConnections = ['${aoaiConnectionName}']


resource aiProject 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' existing = {
  name: aiProjectName
}



resource projectCapabilityHost 'Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-10-01-preview' = {
  name: '${aiProjectName}-${capabilityHostName}'
  parent: aiProject
  properties: {
    customerSubnet: customerSubnetId
    capabilityHostKind: 'Agents'
    aiServicesConnections: aiServiceConnections
    vectorStoreConnections: aiSearchConnection
    storageConnections: storageConnections
  }
  dependsOn: [
     aiProject
  ]
}
