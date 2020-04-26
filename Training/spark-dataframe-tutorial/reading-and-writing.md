### Reading and writing data 

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




## JSON

### Loading a JSON file from an ADLSGEN2 asccount
```
%%pyspark
filepath = '/SearchLog.json'
df = spark.read.json.load(filepath)
df.printSchema()
df.show()
```

### Writing a JSON to an ADLSGEN2 asccount

The example below will create a FOLDER called SearchLog.json with multiple JSON files inside
```
%%pyspark
filepath = '/SearchLog.json'
searchlog.write.json(filepath)
```

If you really need to create a single JSON file. It will sill create a SearchLog.json, but it will contain a single JSON file instead of multiple

```
%%pyspark
filepath = '/SearchLog.json'
searchlog.repartition(1).write.json(filepath)
```
