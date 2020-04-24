
# Fetch the IDs you need

```
$wsmsi_objid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # Replace with Workspace MSI object id here
$stg_subid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # Replace with ID of Subscription that the Storage Account is in
```

# Fetch the names you need

```
$stg_account = "name_of_storage_account" # Replace with Storage account name
$stg_container = "name_of_container" # Replace with the container to give the MSI access to
$role = "Storage Blob Data Contributor" # Leave this alone
```

# Run this command to assign the role

```
$scope = "/subscriptions/" + $stg_subid  + "/resourceGroups/shared/providers/Microsoft.Storage/storageAccounts/"
$scope = $scope + $stg_account + "/blobServices/default/containers/" + "users"
New-AzRoleAssignment -ObjectId $wsmsi_objid -RoleDefinitionName $role -Scope $scope 
```

