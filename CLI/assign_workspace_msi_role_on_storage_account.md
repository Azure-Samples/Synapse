## Summary

Enable your workspace to orchestrate activities that require reading or writing data.

This code will enable your workspace's identity to use the primary Data Lake Storage Gen2 file system associated with the workspace.

## Prerequisite

You need Azure CLI in order to run this sample. There are two options:
* [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) and open a Terminal / Command Prompt window.
* [Use Azure Cloud Shell](https://shell.azure.com/) in **Bash** mode.

## Collect some information

Find the values that these variables need, then run the code to set them up.

```
ws_name="contosoanalytics" # Replace with the workspace name
stg_subid="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # Replace with Subscription ID of the Storage account
stg_account="name_of_storage_account" # Replace with the workspace's primary Storage account name
stg_container="name_of_container" # Replace with the workspace's primary Storage file system name
```

## Create the role assignment

Once the variables are set up, run the following code to create the role assignment.

```
az login
az account set --subscription $stg_subid
wsmsi_objid=az resource list --resource-type "Microsoft.Synapse/workspaces" --name $ws_name --query [0].identity.principalId
scope="/subscriptions/"$stg_subid"/resourceGroups/shared/providers/Microsoft.Storage/storageAccounts/"$stg_account"/blobServices/default/containers/"$stg_container
az role assignment create --role "Storage Blob Data Contributor" --assignee-object-id $wsmsi_objid --scope $scope
```

