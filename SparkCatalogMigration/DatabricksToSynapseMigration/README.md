# Introduction 

Users need to share Spark catalog from Databricks to Synapse. 
- ADB stores Spark catalog in HMS DB (managed or external metastore). 
- Synapse stores Spark catalog in SyMS.

Import/export scripts are provide to users to migration spark catalog from Databrick to Synapse. 

## Migration Scripts

### [export_metadata_from_databricks_notebook_script.scala](./scripts/export_metadata_from_databricks_notebook_script.scala)

This script is used to export metadata database, table, and partition objects from databrciks to Azure storage Gen2.

### [import_metadata_to_synapse_notebook_script.ipynb](./scripts/import_metadata_to_synapse_notebook_script.ipynb)

This script is used to import database, table, and partition objects from Azure storage Gen2 to Synapse. 

## Limitations 

1.	Only databases, tables and partitions can be migrated. 
2.	Migration scripts depend on spark externalcatalog APIs. The export/import notebook should be run on the Databricks/Synapse spark cluster with the same spark version.   
3.	There is no isolation guarantee, which means that if Databricks is doing concurrent modifications to the metastore while the migration notebook is running, inconsistent data can be introduced in Synapse Catalog. 

## Prerequisites

1.	You have access to the source Databricks.
2.	You have access to the target Synapse.
3.	You need to prepare Azure storage Gen2 storage account and a blob container as the storage location of intermediate files. 
4.	Databricks File System (DBFS) is not supported. You need to prepare Azure storage Gen2 storage account and create folder in container as the new catalog data root.
Optional: copy your data to the new create catalog folder  

# Getting Started
## Migration catalog objects from Databricks to Synapse using migration scripts
### Export metadata from Databricks to Azure Data Lake Gen2 Storage

1. Import [export_metadata_from_databricks_notebook_script.scala](./scripts/export_metadata_from_databricks_notebook_script.scala) to Databricks Notebook
2. Specify the parameters defined in the first cmd in Notebook
 - IntermediateFolderPath
 
    Type: String. The Azure data lake Gen2 storage path for storing the exported catalog objects.
   
 - StorageAccountName
 
    Type: String. The Azure data lake Gen2 storage account name of IntermediateFolderPath.
    
 - StorageAccountAccessKey
    
    Type: String. The Azure data lake Gen2 storage account access key of IntermediateFolderPath.
    
 - DatabaseNames

    Type: String. Semicolon-separated list of names of database in Databricks to export. If it's *, all the databases will be export. Default is *.

 Parmeter sample
 ``` yaml
 var IntermediateFolderPath = "abfss://<container_name>@<storage_account_name>.dfs.core.windows.net/intermediate_output/"
 var StorageAccountName = "<storage_account_name>"
 var StorageAccountAccessKey = "<storage_account_access_key>"
  
 var DatabaseNames = "*"
 ```

3.	Click "Run all" to execute all cmds.

### Import metadata from Azure Datalake Gen2 Storage to Synpase 

1.	Import [import_metadata_to_synapse_notebook_script.ipynb](./scripts/import_metadata_to_synapse_notebook_script.ipynb) to Synpase Notebook

2.	Specify the parameters defined in the first cell in Notebook
 - IntermediateFolderPath
 
    Type: String. The Azure data lake Gen2 storage path for storing the exported catalog objects.
    
 - StorageAccountName (optional)
 
    Type: String. The Azure data lake Gen2 storage account name of IntermediateFolderPath.
    
 - StorageAccountAccessKey (optional)
 
    Type: String. The Azure data lake Gen2 storage account access key of IntermediateFolderPath.
    
 - DatabasePrefix
    
    Type: String. Prefix string added when create database in synapse. You can use it to track the original of the metadata and avoid name conflict. The default value is empty.
    Database create will fail if it already exists.
    
 - TablePrefix
 
    Type: String. Prefix string added when create table in synapse. You can use it to track the original of the metadata and avoid name conflict. The default value is empty.

 - OverriedIfExists
 
    Type: Boolean. Override metadata object if it exists.
    
 - IgnoreIfExists
 
    Type: Boolean. Skip create metadata object if it exists. 
    
 - LocationPrefixMappings
 
    Type: Map[String, String]. DBFS is not supported in Synapse. User need to specify replaced Azure Gen2 location prefix. The map key is old location prefix, the map value is the new location prefix. The location prefix replace following longest prefix match rule
    
    Sample
    > LocationPrefixMappings = Map(
    > "dbfs:/user/hive/warehouse"->"abfss://adbdata@myws.dfs.core.windows.net/synapse/workspaces/my-demo/warehouse",
    > "dbfs:/user/hive/warehouse/"->"abfss://adbdata@myws.dfs.core.windows.net/synapse/workspaces/my-demo/warehouse/db_prefix_") 
    > 
    > Source ADB DB location is: dbfs:/user/hive/warehouse/mydb.db/
    > Tagert Synapse DB location will be: abfss://adbdata@myws.dfs.core.windows.net/synapse/workspaces/my-demo/warehouse/db_prefix_mydb.db/

    Note: if no mapping abfss path for some DBFS location in ADB catalog objects, the migration will fail
    
    Note: IntermediateFolderPath must be the same as their value you specified in the first cmd of Databricks notebook.

 Parameter sample:
 ``` yaml
  var IntermediateFolderPath = "abfss://<container_name>@<storage_account_name>.dfs.core.windows.net/intermediate_output/"
  var StorageAccountName = "<storage_account_name>"
  var StorageAccountAccessKey = "<storage_account_access_key>"
    
  var DatabasePrefix = ""
  var TablePrefix = ""
  var IgnoreIfExists = false
  var OverrideIfExists = false

  var LocationPrefixMappings:Map[String, String] = Map("dbfs:/user/hive/warehouse"->"abfss://<container_name>@<storage_account_name>.dfs.core.windows.net/catalog/hive/warehouse")
 ```

3.	Click "Run all" to execute all cells.

## Monitor Migration progress
### Monitor export progress 

Export script is executed in Databrick notebook. Our script is print the total get databases, tables and partition in last cmd output. You can monitor the export progress here.
 
### Monitor import progress 

Import script is executed in Synapse notebook. Import database, table and partition are executed in different cells. When import cell running, you can check what the cell doing as below
1.	click the "view in monitoring" at the right bottom of cell to go to the spark application monitor page 
2.	In spark application monitor page, choose Logs -> driver-> stderr to check what the cell doing. 
3.	After cell executed, you can also see how many catalog objects created at the cell output. You can also see how many catalog objects on spark application monitor page, Logs -> driver-> stdout part.
