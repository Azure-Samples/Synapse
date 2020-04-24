# Working with Spark Dataframes 

## Introduction

If you come from the SQL world, you may be unused to the mechnics of using dataframes in Spark. 
This document will get your productive fast. Just follow the instructions be and by the end you'll be able
to do basic dataframe manipulations.

## Preparing

You'll need
- an Azure Synapse Analytics workspace. 
- to be assigned the Workspace Admin role in the Synpse Workspace.
- to have contributor access to the Workspace (done via the Azure portal)
- read and write permissions to an ADLSGEN2 account

## Spark pool

If you don't already have, one create a spark pool. For this document, we'll assume it has a name of **spark1**.

## Create a notebook and run a Hello World

Create an new notebook. 
Add a new cell.
In the cell put this code

```
%%pyspark
print("Hello World!")
```

This notebook does almost nothing, but running it ensuresthat the worksapce is configured correctly at some minumum level.

You see that the first line in the cell is `%%pyspark` this is called a **cell magic**. Notebooks have a default language, and this magic override the language in the that cell. We'll use cell magics in this doc because we'll be mixing languages often.












