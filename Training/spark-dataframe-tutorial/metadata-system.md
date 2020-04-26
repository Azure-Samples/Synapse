# Metadata system

## List Databases

### PySpark

```

dbs = spark.catalog.listDatabases()
for db in dbs:
    print(db)

```

```

Database(name='default', description='Default Hive database', locationUri='abfss://users@contosolake.dfs.core.windows.net/synapse/workspaces/saveenrws18/warehouse')

```

## Creating Databases

The code below creates a database called tutorial

```
%%sql
CREATE DATABASE tutorial
```

If SparkDB1 already exists, that command will fail. We can use IF NOT EXISTS so that we can handle this case easily

```
%%sql
CREATE DATABASE IF NOT EXISTS tutorial
```


## Creating a table from data

```
CREATE TABLE IF NOT EXISTS tutorial.searchlog
AS 
(
	SELECT *
	FROM searchlog
)
```




