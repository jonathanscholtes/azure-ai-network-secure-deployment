param aiSearchName string
param location string
param vnetId string
param subnetName string


var privateEndpointName = '${aiSearchName}-pe'


var searchPrivateDnsZoneName = 'privatelink.search.windows.net'

resource searchService 'Microsoft.Search/searchServices@2021-04-01-preview' existing = {
  name: aiSearchName

}



resource searchPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: privateEndpointName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          groupIds: [
            'searchService'
          ]
          privateLinkServiceId: searchService.id
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    subnet: {
      id: '${vnetId}/subnets/${subnetName}'
    }
  }
}

resource searchPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: searchPrivateDnsZoneName
  location: 'global'
}

resource searchPrivateEndpointDns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  parent: searchPrivateEndpoint
  name: 'search-PrivateDnsZoneGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: searchPrivateDnsZoneName
        properties: {
          privateDnsZoneId: searchPrivateDnsZone.id
        }
      }
    ]
  }
}

resource searchPrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: searchPrivateDnsZone
  name: uniqueString(searchService.id)
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetId
    }
  }
}


output searchPrivateEndpointName string = privateEndpointName
