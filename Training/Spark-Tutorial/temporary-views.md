
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

In the following code you can see an example of how this works:

```
%%pyspark
df0 = spark.sql("SELECT * FROM sparktutorial.searchlog")
df0.createOrReplaceTempView("tv_df0")
```

```
%%csharp
var df1 = spark.Sql("SELECT * FROM tv_df0");
```

## Creating a temporary view

```
%%pyspark
df0 = spark.sql("SELECT * FROM sparktutorial.searchlog")
df0.createOrReplaceTempView("tv_df0")
```

```
%%csharp
var df0 = spark.Sql("SELECT * FROM sparktutorial.searchlog");
df0.CreateOrReplaceTempView("tv_df0"); 
```

```
%%sql
CREATE OR REPLACE TEMPORARY VIEW tv_df0
AS 
	SELECT * 
	FROM sparktutorial.searchlog
	WHERE market = 'en-us'
```


## List temporary views

```
%%pyspark
df0 = spark.sql("SELECT * FROM sparktutorial.searchlog")
df0.createOrReplaceTempView("tv_df0")
df1 = spark.sql("SELECT * FROM sparktutorial.searchlog WHERE latency > 600")
df1.createOrReplaceTempView("tv_df1")

tables = spark.catalog.listTables("default")
for table in tables:
    print(table)
```

```
%%csharp
var df0 = spark.Sql("SELECT * FROM sparktutorial.searchlog");
df0.CreateOrReplaceTempView("tv_df0");
var df1 = spark.Sql("SELECT * FROM sparktutorial.searchlog WHERE latency > 600");
df1.CreateOrReplaceTempView("tv_df1");

var tables = spark.Catalog().ListTables("default");
tables.Show();
```

```
%%sql
drop view temp_view_name
```

## Deleting a temporary view

```
%%pyspark
spark.catalog.dropTempView("temp_view_name")
```

```
%%csharp
spark.Catalog().DropTempView("temp_view_name");
```

```
%%sql
drop view temp_view_name
```

