
# Basics

When we created the SearchLog dataset we created a table called **sparktutorial.searchlog** that contains to the same data.

The examples in this tutorial will most often
refer to this table.

# Approach

In this tutorial we are going to take the approach of
using SQL as much as possible.


## Getting a dataframe for the the sparktututorial.searchlog table

```
%%pyspark
df = spark.sql("SELECT * FROM sparktutorial.searchlog")
df.show()
```

```
%%csharp
var df = spark.Sql("SELECT * FROM sparktutorial.searchlog");
df.Show();
```

## Find the dataframe schema

```
%%pyspark
df = spark.sql("SELECT * FROM sparktutorial.searchlog")
df.printSchema()
```

```
%%csharp
var df = spark.Sql("SELECT * FROM sparktutorial.searchlog");
df.PrintSchema();
```


## Rename a column


```
%%pyspark
df = spark.sql("SELECT * FROM sparktutorial.searchlog")
df = df.withColumnRenamed("id","sessionid")
df.show()
```

```
%%csharp
var df = spark.Sql("SELECT * FROM sparktutorial.searchlog");
df = df.WithColumnRenamed("id","sessionid");
df.PrintSchema();
```


## Select specific columns

```
%pyspark
df = spark.sql("SELECT id, market FROM sparktutorial.searchlog")
df.show()
```

```
%csharp
var df = spark.Sql("SELECT id, market FROM sparktutorial.searchlog");
df.show();
```

### Calculate a column

```
%%pyspark

query = """
SELECT latency, 
       latency/1000 AS latencysec
FROM sparktutorial.searchlog
"""

df = spark.sql(query)
df.show()
```

```
%%csharp

string query = @"
SELECT latency, 
       latency/1000 AS latencysec
FROM sparktutorial.searchlog
";

var df = spark.Sql(query);
df.Show();
```



### Limiting the number of records in a dataframe

```
%%pyspark

query = """
SELECT *
FROM sparktutorial.searchlog
LIMIT 5
"""

df = spark.sql(query)
df.show()
```

```
%%csharp

string query = @"
SELECT *
FROM sparktutorial.searchlog
LIMIT 5
";

var df = spark.Sql(query);
df.Show();
```
