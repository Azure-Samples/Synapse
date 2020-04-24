
## Summary

To enable your workspace to orchstrate activities that require reading or writing data in an ADLSGEN2 account, your workspace MSI must be assigned the **Storage Blob Data Contributor** role on the ADLSGEN2 account or a specific container in that account. This code automates that process for you.

## You'll need to collect this information

```
$wsname = "name of your workspace"
$stg_account = "name_of_storage_account" # Replace with Storage account name
$stg_subid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # Replace with ID of Subscription that the Storage Account is in
$stg_rg = "name_of_reosurce_group_containing_the_storage_account"
$stg_container = $null # null = assign the role to the account, otherwise it will assign to that container
$role = "Storage Blob Data Contributor" # Leave this alone
```

## Run this code to assign the role 

```
$account_scope = "/subscriptions/" + $stg_subid  + "/resourceGroups/" 
$account_scope = $account_scope + $stg_rg + "/providers/Microsoft.Storage/storageAccounts/" + $stg_account 
$container_scope = $account_scope + "/blobServices/default/containers/" + $stg_container	

if ($stg_container -eq $null)
{
  $final_scope = $account_scope
}
else
{
  $final_scope = $container_scope
}

$wsmsi = Get-AzureADServicePrincipal -SearchString $wsname
New-AzRoleAssignment -ObjectId $wsmsi.ObjectId -RoleDefinitionName $role -Scope $final_scope
```

