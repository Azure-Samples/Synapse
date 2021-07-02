# Azure Data Factory to Synapse Analytics Migration Tool
This PowerShell script enables you to migrate Azure Data Factory pipelines, datasets, linked service, integration runtime and triggers to a Synapse Workspace.

## Usage
 ``` PowerShell
    .\importADFtoSynapseTool.ps1 -sourceADFResourceId <factoryResourceId> -destSynapseResourceId <workspaceResourceId> -TenantId <tenantId>
 ```

or 
 ``` PowerShell
    .\importADFtoSynapseTool.ps1 -ConfigFile appsettings.json
 ```
 
The migration tool has the following limitations:

* Migration to Microsoft Azure Government environment is not supported.
* Managed Private Endpoints are not migrated automatically.
You will have to make sure that the Synapse Workspace has managed virtual network and endpoints setup correctly. Refer to [Synapse managed virtual endpoints](https://docs.microsoft.com/azure/synapse-analytics/security/synapse-workspace-managed-private-endpoints).
* The migration does not support migration of ADF SSIS pipelines. SSIS IR is currently not supported on Synapse Analytics.
* Linked Service dependency on other Linked Service might cause some resources are not migrated. You can run the migration script again.
* For differences between capabilities in Azure Data Factory and Synapse, refer to the [Azure Doc](https://docs.microsoft.com/azure/synapse-analytics/data-integration/concepts-data-factory-differences).

## Prerequisite checks

* PowerShell Environment Setup
   * Check [PowerShell 7.x](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1) installation will be used in the migration tool.
   * Check the **Execution Policy** for PowerShell using Get-ExecutionPolicy -List
   * **Unblock-file** - Depending on the setup of your PowerShell environment, you will have to [Unblock-file](https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/unblock-file?view=powershell-7.1)

 * Permission on Synapse - Grant user being used to migrate having [Synapse Contributor](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/synapse-workspace-synapse-rbac-roles) permission.

* Install the following PowerShell Modules
   * _Az.Resources_ - Install-Module -Name Az.Resources -MinimumVersion 3.3.0 -AllowClobber -Force
   * _Az.Synapse_ - Install-Module -Name Az.Synapse -MinimumVersion 0.8.0 -AllowClobber -Force
   * _Az.DataFactory_ -   install-module -name Az.DataFactory -AllowClobber -Force

* (Optional)) Ensure that Self-hosted Integration Runtimes are running and pre-created if you are planning to migrate.

* * *

## How do I run the Migration Tool?

### Method 1 - Specify the resource ID for ADF and Synapse, with TenantId
You can get the Resource IDs for Azure Data Factory and Azure Synapse Analytics.

 ``` PowerShell
   .\importADFtoSynapseTool.ps1 -sourceADFResourceId "/subscriptions/<SubscriptionID>/resourcegroups/<ADFResourceGroupName>/providers/Microsoft.DataFactory/factories/<ADFName>" -destSynapseResourceId "/subscriptions/<SubscriptionID>/resourcegroups/<SynapseResourceGroupName>/providers/Microsoft.Synapse/workspaces/<SynapseName>" -TenantId <tenantId>
```

### Method 2 - Using a configuation file - appsettings.json

* Edit appsettings.json to provide the following details:
   * Resource group name for Azure Data Factory
   * Resource group name for Azure Synapse Workspace
   * Subscription ID
   * Tenant ID (you can find this by click Azure Active Directory in the Azure Portal)
   * ClientId and ClientSecret (optional - unless you are using Service Principal authentication)
   
* At the commandline, run the migration tool via resource id or service principal  
 ``` PowerShell
 .\importADFtoSynapseTool.ps1 -ConfigFile appsettings.json
```

<span style="color:red">[!NOTE]</span>
*  Existing resources in destination workspace with the same name will be overwritten. 
*  Same networking setting between Azure Data Factory and Synapse is required.
e.g. Managed Virtual Network of Azure Data Factory is enabled on both Azure Data Factory and Synapse.
*  The migration tool does not support migration of ADF SSIS pipeline
* Refer to the [Troubleshooting Guide](./Troubleshooting.md) if you run into any issues when using the migration PowerShell script
 
* * *

## How do I exclude specific objects from my Data Factory source factory?
This migration tool will migrate all objects from the published version of your factory that is live in Azure. You will have to remove any objects that you do not wish to migrate to your Synapse workspace. If you do not wish to modify your source ADF, then you should make a copy of the existing factory, remove the objects you do not wish to migrate, and use that new factory as your source.

## What should I do after running the Migration Tool?
Post-migration, you will need to check the following in the Synapse Analytics workspace.

* The migrated Synapse pipelines and dataflows takes a few minutes to be reflected in the Azure Portal.
* Linked Service dependency on other Linked Service might cause some resources are not migrated. You can run the migration script again.
* Any inline secrets in the Linked services will need to be re-entered in the Azure Synapse workspace. 
* Test each configuration in linked service and make sure the test connection is successful before running the pipelines on Synapse Analytics.
* You will need to manually start the triggers in the Synapse Workspace.
* (Optional) Re-configure [Self-hosted Integration Runtime](https://docs.microsoft.com/en-us/azure/data-factory/create-self-hosted-integration-runtime) on Azure Synapse workspace if Self-hosted Integration Runtime be used in Azure Data Factory. 
* **Support for Live ADF and Synapse  Migration only** - Migration script migrates your Azure Data Factory resources to Azure Synapse Analytics workspace in the live environment only. After you migrate to the Azure Synapse workspace, you have to resync it with the Github repository. Refer to [Troubleshooting Git Integration](https://docs.microsoft.com/en-us/azure/data-factory/source-control#troubleshooting-git-integration)

To get started wih Synapse Analytics Pipelines and Data flows, see the following tutorials for step-by-step instructions
[Pipelines and activities in Synpase](https://docs.microsoft.com/en-us/azure/data-factory/concepts-pipelines-activities?toc=/azure/synapse-analytics/toc.json&bc=/azure/synapse-analytics/breadcrumb/toc.json)
