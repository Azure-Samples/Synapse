# Introduction 

Users need to migrate Spark catalog from Databricks to Synapse. 
- ADB(Azure DataBricks) stores Spark catalog in HMS(Hive MetaStore) DB (backed by one SQL database instance, either managed or an external one). 
- Synapse stores Spark catalog in managed metastore

Import/export scripts are provided to users to migrate spark catalog from ADB to Synapse. 

NOTE: Our migration tool only copies catalog objects(i.e. metadata in HMS) from ADB to Synapse. Users need to manually copy catalog artifacts (i.e. data in warehouse locaion of stroage account) from ADB to Synapse. 

## Migration Scripts

### [export_metadata_from_databricks_notebook_script.scala](./scripts/export_metadata_from_databricks_notebook_script.scala)

This script is used to export metadata of databases, tables, and partitions from databrciks to an intermediate directory in Azure Data Lake Storage Gen2.

### [import_metadata_to_synapse_notebook_script.ipynb](./scripts/import_metadata_to_synapse_notebook_script.ipynb)

This script is used to import databases, tables, and partitions from the intermediate directory in ADLS Gen2 to Synapse. 

## Limitations 

1.	Only databases, tables and partitions can be migrated, while support for other catalog objects (e.g. functions) are still in progress
2.	Migration scripts depend on spark catalog APIs. The export/import notebook scripts should be run on the Databricks/Synapse spark cluster with the same spark version.   
3.	There is no isolation guarantee, which means that if Databricks is doing modifications to the metastore while the migration notebook is running, inconsistent data can be introduced in Synapse Catalog. 

## Prerequisites

1.	You have access to the source Azure Databricks workspace.
2.	You have access to the target Synapse workspace.
3.	You need to prepare Azure storage Gen2 storage account and a blob container as the storage location of intermediate files. 


# Getting Started
## Migrate catalog objects from Databricks to Synapse using migration scripts
### Export metadata from Databricks to Azure Data Lake Gen2 Storage

1. Import [export_metadata_from_databricks_notebook_script.scala](./scripts/export_metadata_from_databricks_notebook_script.scala) to Databricks Notebook
2. Specify the parameters defined in the first cmd in Notebook
 - IntermediateFolderPath
 
    Type: String. The Azure data lake Gen2 storage path for storing the exported catalog objects.
    
    Path format: "abfss://<container_name>@<storage_account_name>.dfs.core.windows.net/intermediate_output/"
   
 - StorageAccountName
 
    Type: String. The Azure data lake Gen2 storage account name of IntermediateFolderPath.
    
 - StorageAccountAccessKey
    
    Type: String. The Azure data lake Gen2 storage account access key of IntermediateFolderPath.
    
    Access key can be found azure portal: "Azure Storage Account Portal -> Access keys"
    
 - DatabaseNames

    Type: String. Semicolon-separated list of names of database in Databricks to export. Default is *, all databases will be exported.

 Parmeters sample
 ``` yaml
 var IntermediateFolderPath = "abfss://adbdata@myws.dfs.core.windows.net/intermediate_output/"
 var StorageAccountName = "myws"
 var StorageAccountAccessKey = "<StorageAccountAccessKey>"
  
 var DatabaseNames = "database1;database2"
 ```

3.	Click "Run all" to execute all cmds.

### Import metadata from Azure Datalake Gen2 Storage to Synpase 

1.	Import [import_metadata_to_synapse_notebook_script.ipynb](./scripts/import_metadata_to_synapse_notebook_script.ipynb) to Synpase Notebook

2.	Specify the parameters defined in the first cell in Notebook
 - IntermediateFolderPath
 
    Type: String. The Azure data lake Gen2 storage path for storing the exported catalog objects.
    
    Path format: "abfss://<container_name>@<storage_account_name>.dfs.core.windows.net/intermediate_output/"
    
    Note: IntermediateFolderPath must be the same as their value you specified in the first cmd of Databricks notebook.
    
 - StorageAccountName (optional)
 
    Type: String. The Azure data lake Gen2 storage account name of IntermediateFolderPath.
    
 - StorageAccountAccessKey (optional)
 
    Type: String. The Azure data lake Gen2 storage account access key of IntermediateFolderPath.
    
    Access key can be found at: "Azure Storage Account Portal -> Access keys" tbl   
    
    
 - DatabasePrefix
    
    Type: String. Prefix string added when create database in Synapse.
    
    You can use it to track the original of the catalog and avoid name conflict. The default value is empty. 
    
    Sample
    ``` yaml
    DatabasePrefix = "db_prefix_"
    If Original database name is "mydb", then recreated database name will be "db_prefix_mydb"
    ``` 
 - TablePrefix
 
    Type: String. Prefix string added when create table in Synapse. 
    
    You can use it to track the original of the metadata and avoid name conflict. The default value is empty.
        
    Sample
    ``` yaml
    TablePrefix = "tbl_prefix_"
    If Original table name is "mytbl", then recreated table name will be "tbl_prefix_mytbl"
    ``` 
    
 - IgnoreIfExists
 
    Type: Boolean. Skip creating metadata object if it exists, otherwise assert failure on conflicts.  
    
 - WarehouseMappings
 
    Type: Map[String, String]. The map key is old warehouse prefix, the map value is the new warehouse prefix. The warehouse prefix replace following longest prefix match rule.
    
    Synapse doesn't support DBFS as warehouse. When recreate database/table/partition in Synapse, DBFS location should be replaced by Azure Gen2 storage location. WarehouseMappings is used to do the replacement.
    
    Note: Migration script will fail if no match is found for a DBFS location from the user provided map 
    
    Sample
    ``` yaml
    WarehouseMappings = Map( 
    "dbfs:/user/hive/warehouse"->"abfss://adbdata@myws.dfs.core.windows.net/synapse/workspaces/my-demo/warehouse",
    "dbfs:/user/hive/warehouse/"->"abfss://adbdata@myws.dfs.core.windows.net/synapse/workspaces/my-demo/warehouse/db_prefix_")
   
    Original DB location is: "dbfs:/user/hive/warehouse/mydb.db/"
    Recreated Synapse DB location will be: "abfss://adbdata@myws.dfs.core.windows.net/synapse/workspaces/my-demo/warehouse/db_prefix_mydb.db/"
    ```

3.	Click "Run all" to execute all cells.

## Monitor Migration progress
### Monitor export progress 

Export script executes in Databrick notebook. The export progress output at "execution output" of last cmd. Total exported databases, tables and partitions count are also output in "execution output" of last cmd. 
 
### Monitor import progress

Import script is executed in Synapse notebook. Import database, table and partition execute in different cells. Progress of database/table/partition can be monitor as below: 
1.	click the "view in monitoring" at the right bottom of cell to go to the spark application monitor page 
2.	In spark application monitor page, choose Logs -> driver-> stderr to check what the cell doing. 

## Migration result validation
After import cell execution completed, created database/table/partition count and validation result are output at "execution output" of each import cell.
