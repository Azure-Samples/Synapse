
# IoT Anomaly Detection leveraging Azure Synapse Link for Azure Cosmos DB
The hypothetical scenario is Power Plant where signals from steam turbines are being analyzed and Anomalous signals are detected. You will ingest streaming and batch IoT data into Azure Cosmos DB using Azure Synapse Spark, perform Joins and aggregations using Azure Synapse Link and perform anomaly detection using Azure Cognitive Services on Spark (MMLSpark).

### Environment setup
Please make sure that you followed the pre-reqs of the main [README](../README.md) file. Please execute the below steps in the given order.
1. Using the Data / Linked tab of your Synapse workspace, create IoTData folder within the root directory of the storage account that is attached to the Synapse workspace. Upload to this folder the "IoTDeviceInfo.csv" file that is placed under the "IoTData" dir of this repo. 
 
![upload_datasets](images/upload_datasets.png)

2.  Using the Azure Portal, go to the Access Control (IAM) tab of the storage account associated with Synapse workspace, click on the +Add and Add a role assignment and add yourself to the Data Contributor role. This is needed for any spark metadata operations such as creating databases and tables using the Azure Synapse Spark Pool.

3. Using the Azure Portal, go to Data Explorer of your the Azure Cosmos DB Account and create a database called CosmosDBIoTDemo. 

4. In the same Data Explorer, create two Analytical Store enabled containers: IoTSignals and IoTDeviceInfo. In the portal interface, the container-id is the container name. Change the Throughput to Autoscale and set the max limit to 4,000. Please click [here](https://review.docs.microsoft.com/en-us/azure/cosmos-db/configure-synapse-link?branch=release-build-cosmosdb#create-analytical-ttl) for details on how to enable Analytical storage on Cosmos DB containers.
    * Use /id as the Partition key for both the containers
    * Please make sure that Analytical store is enabled for both the containers

5. In your Azure Synapse workspace, go to the Manage / Linked Services tab and create a linked service called CosmosDBIoTDemo pointing to the Cosmos DB database that was created in step 3 above. Please click [here](https://review.docs.microsoft.com/en-us/azure/synapse-analytics/synapse-link/how-to-connect-synapse-link-cosmos-db?branch=release-build-synapse#connect-an-azure-cosmos-db-database-to-a-synapse-workspace) for more details on creating Synapse linked service pointing to Cosmos DB.

### Notebooks Execution

Import the below four synapse spark notebooks under the "IoT/spark-notebooks/pyspark/" dir on to the Synapse workspace and attach the Spark pool created in the prerequisite to the notebooks.
1. [01-CosmosDBSynapseStreamIngestion: Ingest streaming data into Azure Cosmos DB collection using Structured Streaming](IoT/spark-notebooks/pyspark/01-CosmosDBSynapseStreamIngestion.ipynb)

    This notebook ingests documents to "IoTSignals" collection using structured streaming. Please make sure to stop the execution of this notebook after few 2 to 5 minutes of streaming, which would bring in enough documents required for the Anomaly detection in "04-CosmosDBSynapseML" notebook.
    Once the notebook execution is stopped, go to the Data Explorer in Azure Cosmos DB Account portal and make sure that the data has been loaded into the "IoTSignals" collection.   

1. [02-CosmosDBSynapseBatchIngestion: Ingest Batch data into Azure Cosmos DB collection using Azure Synapse Spark](IoT/spark-notebooks/pyspark/02-CosmosDBSynapseBatchIngestion.ipynb)

    This notebook ingests documents from "IoTDeviceInfo.csv" to the "IoTDeviceInfo" collection.
    Once the notebook execution is completed, go to the Data Explorer in Azure Cosmos DB Account portal and make sure that the data has been loaded into the "IoTDeviceInfo" collection.   

1. [03-CosmosDBSynapseJoins: Perform Joins and aggregations across Azure Cosmos DB collections using Azure Synapse Link](IoT/spark-notebooks/pyspark/03-CosmosDBSynapseJoins.ipynb)

    This notebook creates Spark tables pointing to Azure Cosmos DB Analytical store collections, perform Joins, filters and aggregations across collectionsand visualize the data using plotly

1. [04-CosmosDBSynapseML: Perform Anomaly Detection using Azure Synapse Link and Azure Cognitive Services on Synapse Spark (MMLSpark)](IoT/spark-notebooks/pyspark/04-CosmosDBSynapseML.ipynb)

    This notebook performs anomaly detection using Azure Cognitive Services on Spark and enables to visualize the anomalies using plotly.

