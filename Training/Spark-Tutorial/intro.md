# Working with Synapse Spark and Dataframes 

## Introduction

This tutorial is for developers new to Azure Synapse who need to get productive 
with basic Spark programming.

* You don't need to haved a background in Spark
* It will help if you have a basic knowledge of SQL queries
* Knowledge of Python or C# will help

Just read the sections one-by-one and by the end you'll be ready to use Spark in Synapse. 

## Preparing

You'll need:
- an Azure Synapse Analytics workspace. 
- to be assigned the Workspace Admin role in the Synpse Workspace.
- to have contributor access to the Workspace (done via the Azure portal)
- read and write permissions to an ADLSGEN2 account

## Spark pool

If you don't already have, one create a spark pool. For this document, we'll assume it has a name of **spark1**.

## Information you should have ready
* The name of your Synapse workspace
* The name AAD Directory you will use
* The name Azure Subscription that your Synapse workspace is in
* The name of the Primary ADLSGEN2 account your Synapse uses
* The name of the default container in that ADLSGEN2 account used by your Synapse workspace
* The name of the spark pool you will use

# Launch Synapse Studio

Go here: https://web.azuresynapse.net/

Choose the appropriate:
* Directory
* Subscriptoin
* Workspace

## Create a notebook and run a Hello World

* Go to the **Develop** hub and create an new notebook. 
* Add a new code cell.
* In the cell put this code

```
%%pyspark
print("Hello World!")
```

* In the notebook, set **Attach to** to **spark1**
* Click the **Run** icon on that cell.

This notebook does almost nothing, but running it ensures that the worksapce is configured correctly at some minumum level.

If you haven't used this pool recently, it will take about 2.5
minutes to spin up the Spark resources for the notebook and then the
cell will run.

After this point, when you run a cell, because the 
spark resources are availalbe for you already, your cells will immediately
start running.


## A note about cell magics

You see that the first line in the cell is `%%pyspark` this is called a **cell magic**. Notebooks have a default language, and this magic override the language in the that cell. We'll use cell magics in this doc because we'll be mixing languages often. 

The specific magic we used indicates that this cell will use the Python language to work with spark.

In this tutorial we will use these magics:

* `%%pyspark`
* `%%sql`
* `%%csharp`


