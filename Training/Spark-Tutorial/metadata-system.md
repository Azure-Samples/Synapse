# Metadata system

## List Databases

### PySpark

```
%%pyspark

dbs = spark.catalog.listDatabases()
for db in dbs:
    print(db)
```

```
Database(name='default', description='Default Hive database', locationUri='abfss://users@contosolake.dfs.core.windows.net/synapse/workspaces/saveenrws18/warehouse')
```

### .NET for Spark

```
%%csharp

var dbs = spark.Catalog().ListDatabases();
dbs.Show();
```

```
+--------+--------------------+--------------------+
|    name|         description|         locationUri|
+--------+--------------------+--------------------+
| default|Default Hive data...|abfss://users@con...|
|sparkdb3|                    |abfss://users@con...|
|tutorial|                    |abfss://users@con...|
+--------+--------------------+--------------------+
```

### Spark SQL

```
%%sql
SHOW DATABASES
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


### PySpark

```
%%pyspark
df = spark.sql("SELECT * FROM searchlog");
df.write.mode("overwrite").saveAsTable("tutorial.searchlog_copy")
```

### .NET For Spark

```
%%csharp
var df = spark.Sql("SELECT * FROM searchlog");
df.Write().Mode("overwrite").SaveAsTable("tutorial.searchlog_copy");
```

### Spark SQL

```
%%sql
CREATE TABLE IF NOT EXISTS tutorial.searchlog_copy
AS 
(
	SELECT *
	FROM searchlog
)
```

