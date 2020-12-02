
# Retail Sales Forecasting with Azure Synapse Link for Azure Cosmos DB Analytical Store and AML SDK

In this notebook, a simple dataset is used to show you how to use Azure Synapse Link for Azure Cosmos DB Analytical Store and AML SDK.

## Environment setup

Please make sure that you followed the pre-reqs of the main [README](../README.md) file. Please execute the below steps in the given order.

1. Using the Azure Portal, go to the Access Control (IAM) tab of the storage account associated with Synapse workspace, click on the +Add and Add a role assignment and add yourself to the Data Contributor role. This is needed for any spark metadata operations such as creating databases and tables using the Azure Synapse Spark Pool.
1. Use the Notebook instructions to create a new Cosmos DB account for MongoDB API. You can't use the same account created for the 2 other notebooks in this repo, they were created for the SQL API.
1. Use the notebook instructions to create a database and a collection within your Azure Cosmos DB account for MongoDB API.
1. Use the Notebook instructions to create a linked service.

## Notebook Execution

Now you just need to follow the notebook instructions:

1. [Batch Ingestion of Sales Forecasting data on Synapse Spark](./spark-notebooks/pyspark/1CosmoDBSynapseSparkBatchIngestion.ipynb)
1. [Perform Sales Forecasting using Azure Synapse Link and Azure Automated Machine Learning on Synapse Spark](./spark-notebooks/pyspark/2SalesForecastingWithAML.ipynb)
