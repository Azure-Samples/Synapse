
## Summary
This code will set your Workspace enable your Worksapce MSI to use the storage account

## You'll need to collect this information

```
$wsname = "name of your workspace"
$stg_account = "name_of_storage_account" # Replace with Storage account name
$stg_container = "name_of_container" # Replace with the container to give the MSI access to
$stg_subid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # Replace with ID of Subscription that the Storage Account is in
$stg_rg = "name_of_reosurce_group_containing_the_storage_account"
$role = "Storage Blob Data Contributor" # Leave this alone
```
## Then run this code

```
$wsmsi = Get-AzureADServicePrincipal -SearchString $wsname
$scope = "/subscriptions/" + $stg_subid  + "/resourceGroups/" 
$scope = $scope + $stg_rg + "/providers/Microsoft.Storage/storageAccounts/" + $stg_account 
New-AzRoleAssignment -ObjectId $wsmsi.ObjectId -RoleDefinitionName $role -Scope $scope
```
