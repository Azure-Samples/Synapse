
## Temporary Views

We've been querying a temporary view called searchlog in all the examples.

* A temporary view allows us to assign a name to a dataset.
* A temporary view is scoped to the current spark session. It doesn't
 live after the session is over.
* A temporary view allows us to share data between languages. This means
* we can mix and match whatever language we need on the same data


## Creating a temporary view

We will first create a temporary view that is a subset of the searchlog data - filtered to just those
sessions from the "en-us" market

### with PySpark
```
%%pyspark
query =  """
SELECT * 
FROM searchlog
WHERE market = 'en-us'
"""

df = spark.sql(query)
df.show() 

df.createOrReplaceTempView("searchlog_en_us") 
```

### with .NET
```
%%csharp
string query = @"
SELECT * 
FROM searchlog
WHERE market = 'en-us'
";

var df = spark.Sql(query);
df.Show();

df.CreateOrReplaceTempView("searchlog_en_us"); 
```

### with Spark SQL

```
%%sql
CREATE OR REPLACE TEMPORARY VIEW searchlog_en_us
AS 
	SELECT * 
	FROM searchlog
	WHERE market = 'en-us'
```

## Deleting a temporary view

### with PySpark

```
spark.catalog.dropTempView("searchlog_en_us")
```

### with Spark SQL

```
drop view searchlog_en_us
```
