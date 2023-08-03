# Parameter for holding storage account access key passed from container-acl.bicep as argument.
param (
    [string] $keys,
    [string[]] $users
)

# Storage account name passed as environment variable.
$storageAccountName = "${Env:saname}"
# Filesystem name or container name passed as environment variable
$filesystemName = "${Env:fsname}"
# User
$usersArray = $users -split ','
#$user = "${Env:users}"
$key = $keys
$ctx = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $key
foreach ($usr in $usersArray) {
$acl = set-AzDataLakeGen2ItemAclObject -AccessControlType user -EntityId $usr -Permission r--
Update-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Acl $acl
}