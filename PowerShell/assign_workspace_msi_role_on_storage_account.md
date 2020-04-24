
## Summary
This code will set your Workspace enable your Worksapce MSI to use the storage account or a container

## You'll need to collect this information

```
$wsname = "name of your workspace"
$stg_account = "name_of_storage_account" # Replace with Storage account name
$stg_subid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # Replace with ID of Subscription that the Storage Account is in
$stg_rg = "name_of_reosurce_group_containing_the_storage_account"
$role = "Storage Blob Data Contributor" # Leave this alone
```

if you want to assign the MSI to a specific container, then add this line.

```
$stg_container = "name_of_container" # Replace with the container to give the MSI access to
```

## Fetch the principal id for the Workspace MSI. We'll use the ObjectID property later

```
$wsmsi = Get-AzureADServicePrincipal -SearchString $wsname
```
## OPTION 1: Run this code to assign the role to the entire account

```
$scope = "/subscriptions/" + $stg_subid  + "/resourceGroups/" 
$scope = $scope + $stg_rg + "/providers/Microsoft.Storage/storageAccounts/" + $stg_account 
New-AzRoleAssignment -ObjectId $wsmsi.ObjectId -RoleDefinitionName $role -Scope $scope
```

## OPTION 1: Run this code to assign the role to a specific containe in the account

```
$scope = "/subscriptions/" + $stg_subid  + "/resourceGroups/shared/providers/Microsoft.Storage/storageAccounts/"	$scope = "/subscriptions/" + $stg_subid  + "/resourceGroups/" 
$scope = $scope + $stg_account + "/blobServices/default/containers/" + $stg_container	
$scope = $scope + $stg_rg + "/providers/Microsoft.Storage/storageAccounts/" + $stg_account 
New-AzRoleAssignment -ObjectId $wsmsi.ObjectId -RoleDefinitionName $role -Scope $scope 
```
