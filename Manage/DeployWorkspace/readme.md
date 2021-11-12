# Deploy Azure Synapse workspace

This template deploys Azure Synapse workspace with underlying Data Lake Storage, or a workspace on the existing storage.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure-Samples%2FSynapse%2Fmaster%2FManage%2FDeployWorkspace%2Fazuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FAzure-Samples%2FSynapse%2Fmaster%2FManage%2FDeployWorkspace%2Fazuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/>
</a>

## Parameters

| name | required | description |
--- | --- | ---
| Name | yes | A name to use for your new Azure Synapse workspace and Data Lake Storage account |
| Storage | no | A name of the underlying Azure Data Lake storage. Use one storage account for multiple workspaces in the region. See [naming restrictions](https://docs.microsoft.com/azure/azure-resource-manager/management/resource-name-rules#microsoftdatalakestore). If not provided, the workspace name will be used. |
| Sql Administrator Login | yes | SQL administrator login name that will access SQL endpoint. |
| Sql Administrator Password | yes | SQL administrator login password for accessing SQL endpoint. |
| Tag Values | no | Resource tags |
| CMK Uri | no | Customer-managed key uri from Key Vault for double encryption |

NOTE: If you want to provide a customer-managed key (CMK) from Key Vault for double encryption, you can get the uri from the portal. See [here](https://docs.microsoft.com/en-us/azure/key-vault/secrets/quick-create-portal#retrieve-a-secret-from-key-vault) for details on how to get the uri from Key Vault and [here](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/workspaces-encryption) for more information on encryption in Azure Synapse in general.

---

`Tags: Azure, Synapse, Analytics`
