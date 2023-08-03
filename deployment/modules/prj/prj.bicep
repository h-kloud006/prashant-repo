param subscriptionId string = ''
param resourceGroupName string
param location string
param tags object
//param keyVault object
param container object
//param dataBricks object
//param cluster object
//param dbInstance object
param storageAccount object
param acl object

//var managedResourceGroupName = dataBricks.managedResourceGroupName
//var trimmedMRGName = substring(managedResourceGroupName, 0, min(length(managedResourceGroupName), 90))
//var managedResourceGroupId = '${subscription().id}/resourceGroups/${trimmedMRGName}'

module rg 'resource-group.bicep' = {
  name: resourceGroupName
  scope: subscription(subscriptionId) // Passing subscription scope
  params: {
    resourceGroupName: resourceGroupName
    resourceGroupLocation: location
    tags: tags
  }
}
/*
module kv 'key-vault.bicep' = {
  scope: resourceGroup(rg.name)
  name: keyVault.name
  params: {
    keyVault: keyVault
    tags: tags
  }
}*/

module sac 'storage-account-container.bicep' = {
  scope: resourceGroup(rg.name)
  name: container.name
  params: {
    container: container
    storageAccount: storageAccount
  }
}

resource keyVault2 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  scope: resourceGroup(rg.name)
  name: 'testhr-kv'
}

module acls 'container-acl.bicep' = {
  scope: resourceGroup('dmw2dihadbrg01-learning')
  name: 'createacl'
  params: {
    acl:acl
    key: keyVault2.getSecret('NEWSaKey')
  }
}
/*
module adb 'dataBricks.bicep' = {
  scope: resourceGroup('diff')
  name: dataBricks.name
  params: {
    dataBricks: dataBricks
    managedResourceGroupId: managedResourceGroupId
  }
}

resource keyVault1 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  scope: resourceGroup('dmw2dihadbrg01-learning')
  name: 'dmw2dihadbkv01-learning'
}

module pats 'pat.bicep' = if (cluster.enabled) {
  scope: resourceGroup('dmw2dihadbrg01-learning')
  name: 'createpat'
  params: {
    cluster: cluster
    patToken: keyVault1.getSecret('adminpat')
  }
}

module compute 'cluster.bicep' = if (cluster.enabled) {
  scope: resourceGroup('dmw2dihadbrg01-learning')
  name: 'createcluster'
  params: {
    cluster: cluster
    dbInstance: dbInstance
    token: pats.outputs.pat
  }
}

*/


