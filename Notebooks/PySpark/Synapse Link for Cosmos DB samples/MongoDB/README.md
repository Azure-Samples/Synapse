
# Load, Query, and Schema Updates with Azure Cosmos DB API for MongoDB

In this noteboook, a simple dataset is created to show you how to use MongoDB client to ingest data, and how to use Synapse Link with Cosmos DB API for MongoDB to query this data. Also, we will ingest a second dataset with a schema update and show how it is managed by Synapse Link.

## Environment setup

Please make sure that you followed the pre-reqs of the main [README](../README.md) file. Please execute the below steps in the given order.

1. Using the Azure Portal, go to the Access Control (IAM) tab of the storage account associated with Synapse workspace, click on the +Add and Add a role assignment and add yourself to the Data Contributor role. This is needed for any spark metadata operations such as creating databases and tables using the Azure Synapse Spark Pool.
1. Use the Notebook instructions to create a new Cosmos DB account for MongoDB API. You can't use the same account created for the 2 other notebooks in this repo, they were created for the SQL API.
1. Use the notebook instructions to create a database and a collection within your Azure Cosmos DB account for MongoDB API.
1. Use the Notebook instructions to create a linked service.

## Notebook Execution

Now you just need to follow the notebook instructions:

[Data Ingestion and Queries with Synapse Spark for Cosmos DB API for MongoDB](../MongoDB/spark-notebooks/pyspark/01-CosmosDBSynapseMongoDB.ipynb)