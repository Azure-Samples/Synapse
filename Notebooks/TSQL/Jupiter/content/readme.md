# Azure Synapse Analytics 

This book contains tutorials that demo how to use serverless Synapse SQL pool to analyze data on Azure Storage.

## Prerequisites

To start tutorials, you would need to have Synapse Analytics workspace.

If you don't have one, you can deploy a workspace with underlying Data Lake Storage. Select the **Deploy to Azure** button to deploy the workspave. The template will open in the Azure portal.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure-Samples%2FSynapse%2Fmaster%2FManage%2FDeployWorkspace%2Fazuredeploy.json" data-linktype="external"><img src="https://docs.microsoft.com/en-us/azure/media/template-deployments/deploy-to-azure.png" alt="Deploy to Azure" data-linktype="relative-path"/></a>

If you don't have an Azure subscription, create a <a href="https://azure.microsoft.com/free/?WT.mc_id=A261C142F" data-linktype="external">free account</a> before you begin.</p>

The template defines two resources:
- Storage account
- Workspace

## Samples

This book contains the following samples:

- Quick-start samples - reading [PARQUET](quickstarts/parquet.ipynb), [CSV](quickstarts/csv.ipynb), [Delta Lake](quickstarts/delta-lake.ipynb), and [JSON](quickstarts/json.ipynb)
- Tutorials - [Analyze COVID data set provided by ECDC](tutorials/covid-ecdc.ipynb) and [Analyze NY Taxi rides](tutorials/ny-taxi.ipynb)

Open some of these notebooks, select SQL kernel and connect to your serverless Synapse SQL endpoint. Follow the instructions in tutorials to run the samples.
