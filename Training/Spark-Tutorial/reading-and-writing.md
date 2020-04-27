### Reading and writing data 


## Authentication when accessing ADLSGEN2

Authentication is handled automatically with ADLSGEN2.

The rules are simple:
- When you run a notebook in Synape Studio **interactively** - all data access 
by default to an ADLSGEN2 account will use your AAS user identity
- When a notebook runs **from a pipeline**, the identity used to access ADLSGEN2 is
always the Synapse Workspace MSI


## ADLSGEN2 Paths

Before we look into to read and write files, you should understand how paths work

Fully-Qualified Paths fully describes the location of the file.

```
abfss://CONTAINER@ACCOUNT.dfs.core.windows.net/FOLDER1/data.json
```

Paths that aren't fully qualified start from the container of the primary ADLSGEN2 storage account

So these paths 
```
Data.json
/Data.json
```

Are equivalent to 

```
abfss://CONTAINER@ACCOUNT.dfs.core.windows.net/Data.json
```

## CSV

### Loading a CSV file from an ADLSGEN2 asccount
```
%%pyspark
filepath = '/SearchLog.csv'
df = spark.read.csv(filepath)
df.printSchema()
df.show()
```

### Writing a CSV to an ADLSGEN2 asccount

The example below will create a FOLDER called SearchLog.json with multiple CSV files inside
```
%%pyspark
filepath = '/SearchLog.csv'
df_searchlog.write.csv(filepath)
```

If you really need to create a single CSVfile. It will sill create a SearchLog.csv folder, but it will contain a single CSV file instead of multiple

```
%%pyspark
filepath = '/SearchLog.csv'
df_searchlog.repartition(1).write.csv(filepath)
```

## JSON

The examples for JSON follow the same pattern as we showed for CSV files

To read:

```
df = spark.read.json.load(filepath)
```

To write:

```
df_searchlog.write.json(filepath)
```

```
df_searchlog.repartition(1).write.json(filepath)
```
