# TweetAnalysis Demo

## Description

A set of two Spark notebooks and a T-SQL script that show the use of Spark.NET and .NET interactive with focus on:
- How to use a .NET function in a notebook as a Spark UDF
- How to use some of the Spark functions from .NET (including different ways to reference columns)
- call into SparkSQL
- Create the Parquet backed Spark tables to be used with other Spark applications and notebooks and even SQL engines
- Create a visualization with the Plotly library
- Use SQL on-demand to query the tables created with Spark.

## Demo data location

You can get a set of CSV-files from the [/Data/Tweets](../../../Data/Tweets) directory.

If you would like to use your own tweet data, you can use [https://tweetdownload.net](https://tweetdownload.net) and save the result as CSV.

## Installation instruction

1. Get the demo data from the above location and upload it to your Azure Synapse ADLS Gen2 account.
2. Upload the two Spark notebooks and one T-SQL script to your Azure Synapse account. 
3. Replace the dummy `inputfile` path in the notebook [`01_TweetAnalysis_DataPrep.ipynb`](01_TweetAnalysis_DataPrep.ipynb) with the location path to the files in your ADLS Gen2 account where you placed the Tweet files.

## Demo Details

### Demo Data

Data consists of a set of header-less CSV files containing tweets. They have 4 columns: Date, Time, Author, and Tweet.

### [`01_TweetAnalysis_DataPrep.ipynb`](01_TweetAnalysis_DataPrep.ipynb)

This is the notebook to run first. 

It will create a dataframe from the CSV files, use a user-defined function written in .NET to extract mentions and topics, and finally create a Synapse database with Spark, that contains two Parquet-backed tables called `Topics` and `Mentions`.

It provides the option to quickly run the notebook without intermediate result by setting the `display` variable to `false`, thus avoiding intermediate execution of the Spark expressions.

### [`02_TweetAnalysis_Analysis.ipynb`](02_TweetAnalysis_Analysis.ipynb)

This notebook will analyze the `Topics` table. The main example takes the top 5 quarterly tweet topics of `MikeDoesBigData` and visualizes it as a bar chart using the built-in Plotly library.

Uncomment and run the last cell, if you changed the tables in another notebook while the Spark Pool used by this notebook was active to make sure you get the latest version of the data.

### [`NumberOfMentions_SQL_Query.sql`](NumberOfMentions_SQL_Query.sql)

This T-SQL script should be run against the SQL on-demand Pool and run against the same database that was created in the [`01_TweetAnalysis_DataPrep.ipynb`](01_TweetAnalysis_DataPrep.ipynb) notebook.

It accesses the `Mentions` table that got created in Spark earlier to find the number of times that `MikeDoesBigData` got mentioned by the different authors. 
