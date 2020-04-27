
## Temporary Views


* A temporary view allows us to assign a name to a dataset.
* A temporary view is scoped to the current spark session. It doesn't
 live after the session is over.
* A temporary view allows us to share data between languages. This means
* we can mix and match whatever language we need on the same data



## Problem Scenario

Imagine we have two cells one %%csharp and one %%pyspark. They are different
languages ans there's no clear way to pass a dataframe between them. This
is where the temporary view helps us out.


## passing data from PySpark to .NET

```
%%pyspark
df0 = spark.sql("SELECT * FROM sparktutorial.searchlog")
df0.createOrReplaceTempView("tv_df0")
```

```
%%csharp
var df1 = spark.Sql("SELECT * FROM tv_df0");
```


## passing data from .NET to PySpark
```
%%csharp
var df0 = spark.Sql("SELECT * FROM sparktutorial.searchlog");
df0.CreateOrReplaceTempView("tv_df0"); 
```

```
%%pyspark
df1 = spark.sql("SELECT * from tv_df0")
```



### Consuming data from SparkSQL queries

```
%%sql
CREATE OR REPLACE TEMPORARY VIEW tv_df0
AS 
	SELECT * 
	FROM sparktutorial.searchlog
	WHERE market = 'en-us'
```


```
%%pyspark
df1 = spark.sql("SELECT * from tv_df0")
```


```
%%csharp
var df2 = spark.Sql("SELECT * FROM tv_df0");
```



## Deleting a temporary view

### with PySpark

```
spark.catalog.dropTempView("tv_searchlog_enus")
```

### with .NET for Spark

```
%%csharp
spark.Catalog().DropTempView("tv_searchlog_enus");
```

### with Spark SQL

```
drop view tv_searchlog_enus
```

