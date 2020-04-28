# Metadata system

## List Databases


```
%%pyspark
dbs = spark.catalog.listDatabases()
for db in dbs:
    print(db)
```

```
%%csharp
var dbs = spark.Catalog().ListDatabases();
dbs.Show();
```

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

```
%%pyspark
df = spark.sql("SELECT * FROM searchlog");
df.write.mode("overwrite").saveAsTable("tutorial.searchlog_copy")
```

```
%%csharp
var df = spark.Sql("SELECT * FROM searchlog");
df.Write().Mode("overwrite").SaveAsTable("tutorial.searchlog_copy");
```

```
%%sql
CREATE TABLE IF NOT EXISTS tutorial.searchlog_copy
AS ( SELECT * FROM searchlog )
```

