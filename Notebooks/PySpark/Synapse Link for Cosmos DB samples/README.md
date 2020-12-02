---
page_type: sample
languages:
- pySpark
- SparkSQL
- python
products:
- Azure Cosmos DB
- Azure Synapse Link
- MMLSpark
description: "Sample Azure Cosmos DB - Synapse Link notebooks "
urlFragment: "cosmosdb-synapse-link-samples"
---

# Azure Synapse Link for Azure Cosmos DB - Samples

This Repo contains detailed Synapse Spark sample notebooks that shows end-to-end solutions using Azure Synapse Link for Azure Cosmos DB. While the first two scenarios are focused on the Azure Cosmos DB SQL API, the third focuses on the API for MongoDB.

## Prerequisites

* [Azure Cosmos DB account](https://docs.microsoft.com/azure/cosmos-db/create-cosmosdb-resources-portal)
* [Azure Synapse workspace](https://docs.microsoft.com/azure/synapse-analytics/quickstart-create-workspace) configured with a [Spark pool](https://docs.microsoft.com/azure/synapse-analytics/quickstart-create-apache-spark-pool)

## Scenario 1 - Internet of Things (IoT) - Azure Cosmos DB SQL API

In this scenario, you will ingest streaming and batch IoT data into Azure Cosmos DB using Azure Synapse Spark, perform Joins and aggregations using Azure Synapse Link and perform [anomaly detection](https://azure.microsoft.com/services/cognitive-services/anomaly-detector/) using Azure Cognitive Services on Spark (MMLSpark).

![IoT-components-dataflow](images/dataflow.PNG)

### IoT Notebooks Execution

Import the below four synapse spark notebooks under the `IoT/spark-notebooks/pyspark/` dir on to the Synapse workspace and attach the Spark pool created in the prerequisite to the notebooks.

1. [01-CosmosDBSynapseStreamIngestion: Ingest streaming data into Azure Cosmos DB collection using Structured Streaming](IoT/spark-notebooks/pyspark/01-CosmosDBSynapseStreamIngestion.ipynb)
1. [02-CosmosDBSynapseBatchIngestion: Ingest Batch data into Azure Cosmos DB collection using Azure Synapse Spark](IoT/spark-notebooks/pyspark/02-CosmosDBSynapseBatchIngestion.ipynb)
1. [03-CosmosDBSynapseJoins: Perform Joins and aggregations across Azure Cosmos DB collections using Azure Synapse Link](IoT/spark-notebooks/pyspark/03-CosmosDBSynapseJoins.ipynb)
1. [04-CosmosDBSynapseML: Perform Anomaly Detection using Azure Synapse Link and Azure Cognitive Services on Synapse Spark (MMLSpark)](IoT/spark-notebooks/pyspark/04-CosmosDBSynapseML.ipynb)

## Scenario 2 - Retail Forecasting - Azure Cosmos DB SQL API

In this scenario, you will ingest Retail data into Azure Cosmos DB using Azure Synapse Spark, perform joins and aggregations using Azure Synapse Link and perform Forecasting using [Azure Automated Machine Learning](https://docs.microsoft.com/azure/machine-learning/concept-automated-ml).

![IoT-components-dataflow](images/pipeline.PNG)

### Retail Notebooks Execution

Import the below two synapse spark notebooks under the `Retail/spark-notebooks/pyspark/` dir into your Synapse workspace and attach the Spark pool created in the prerequisite to the notebooks.

1. [Batch Ingestion of Sales Forecasting data on Synapse Spark](Retail/spark-notebooks/pyspark/1CosmoDBSynapseSparkBatchIngestion.ipynb)
1. [Perform Sales Forecasting using Azure Synapse Link and Azure Automated Machine Learning on Synapse Spark](Retail/spark-notebooks/pyspark/2SalesForecastingWithAML.ipynb)

## Scenario 3 - E-Commerce Food orders and SparkSQL Queries - Azure Cosmos DB API for MongoDB

In this simple scenario, you will learn how to use Azure Synapse Spark to ingest data into Cosmos DB MongoDB API container, hot to query it using Spark, and how [schema updates are managed](https://docs.microsoft.com/azure/cosmos-db/analytical-store-introduction#analytical-schema).

### E-Commerce Notebooks Execution

Import the below synapse spark notebooks under the `E-Commerce-with-MongoDB/spark-notebooks/pyspark/` dir into your Synapse workspace and attach the Spark pool created in the prerequisite to the notebooks.

1. [Data Ingestion and Queries with Synapse Spark for Cosmos DB API for MongoDB](E-Commerce-with-MongoDB/spark-notebooks/pyspark/01-CosmosDBSynapseMongoDB.ipynb)

## Key concepts - Azure Synapse Link for Azure Cosmos DB analytical store

* [Azure Synapse Link for Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/synapse-link)
* [Azure Cosmos DB Analytical Store](https://review.docs.microsoft.com/azure/cosmos-db/analytical-store-introduction?branch=release-build-cosmosdb)
* [Configure Synapse Link for Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/synapse-link-frequently-asked-questions)
* [Connect to Synapse Link from Synapse Studio](https://docs.microsoft.com/azure/synapse-analytics/synapse-link/how-to-connect-synapse-link-cosmos-db?branch=release-build-synapse)
* [Query Cosmos DB Analytical Store with Synapse Spark](https://docs.microsoft.com/azure/synapse-analytics/synapse-link/how-to-query-analytical-store-spark?branch=release-build-synapse)

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
