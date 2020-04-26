
# Dataframe basics

When we created the SearchLog dataset we created two things:
* a dataframe called **df_searchlog**.
* a temporary view that points to the same data 

## Examine a dataframe with pyspark

```
%%pyspark
df_searchlog.show()
```


```
+------+------+--------------------+-------+--------------------+--------------------+-------------------+
|    id|market|          searchtext|latency|               links|        clickedlinks|               time|
+------+------+--------------------+-------+--------------------+--------------------+-------------------+
|399266| en-us|  how to make nachos|     73|www.nachos.com;ww...|                NULL|2019-10-15 11:53:04|
|382045| en-gb|    best ski resorts|    614|skiresorts.com;sk...|ski-europe.com;ww...|2019-10-15 11:53:25|
|382045| en-gb|          broken leg|     74|mayoclinic.com/he...|mayoclinic.com/he...|2019-10-16 11:53:42|
|106479| en-ca| south park episodes|     24|southparkstudios....|southparkstudios.com|2019-10-16 11:53:10|
|906441| en-us|              cosmos|   1213|cosmos.com;wikipe...|                NULL|2019-10-16 11:54:18|
|351530| en-fr|           microsoft|    241|microsoft.com;wik...|                NULL|2019-10-16 11:54:29|
|640806| en-us| wireless headphones|    502|www.amazon.com;re...|www.amazon.com;st...|2019-10-16 11:54:32|
|304305| en-us|       dominos pizza|     60|dominos.com;wikip...|         dominos.com|2019-10-16 11:54:45|
|460748| en-us|                yelp|   1270|yelp.com;apple.co...|            yelp.com|2019-10-16 11:54:58|
|354841| en-us|          how to run|    610|running.about.com...|running.about.com...|2019-10-16 11:59:00|
|354068| en-mx|         what is sql|    422|wikipedia.org/wik...|wikipedia.org/wik...|2019-10-16 12:00:07|
|674364| en-us|mexican food redmond|    283|eltoreador.com;ye...|                NULL|2019-10-16 12:00:21|
|347413| en-gr|           microsoft|    305|microsoft.com;wik...|                NULL|2019-10-16 12:11:34|
|848434| en-ch|            facebook|     10|facebook.com;face...|        facebook.com|2019-10-16 12:12:14|
|604846| en-us|           wikipedia|    612|wikipedia.org;en....|       wikipedia.org|2019-10-16 12:13:18|
|840614| en-us|                xbox|   1220|xbox.com;en.wikip...|    xbox.com/xbox360|2019-10-16 12:13:41|
|656666| en-us|             hotmail|    691|hotmail.com;login...|                NULL|2019-10-16 12:15:19|
|951513| en-us|             pokemon|     63|pokemon.com;pokem...|         pokemon.com|2019-10-16 12:17:37|
|350350| en-us|             wolfram|     30|wolframalpha.com;...|                NULL|2019-10-16 12:18:17|
|641615| en-us|                kahn|    119|khanacademy.org;e...|     khanacademy.org|2019-10-16 12:19:21|
+------+------+--------------------+-------+--------------------+--------------------+-------------------+
only showing top 20 rows
```

## Examine a temporary view with Spark SQL

You can query using the temporary view with Spark SQL

```
%%sql
SELECT * 
FROM searchlog
```

The benefit of using Spark SQL, is that many operations will be familiar to you 
based on your SQL experience. 


# Using PySpark and SQL together

The approach we will use in the examples is to call Spark SQL from python and C#. This will simplify 
using this tutorial.

```
%%pyspark
query =  """
SELECT * 
FROM searchlog
"""

df = spark.sql(query)
df.show()
```

# Using .NET and SQL together

Below, is an example of using Spark SQL from .NET for Spark

```
%%csharp
string query = @"
SELECT * 
FROM searchlog
";

var df = spark.Sql(query);
df.Show();
```

## Find the dataframe schema with PySpark

```
%%pyspark
df_searchlog.printSchema()
```

```
root
 |-- id: integer (nullable = false)
 |-- market: string (nullable = false)
 |-- searchtext: string (nullable = false)
 |-- latency: integer (nullable = false)
 |-- links: string (nullable = true)
 |-- clickedlinks: string (nullable = true)
 |-- time: timestamp (nullable = true)

```


## Finding out the schema of a table or view

```
%%pyspark
query =  """
DESCRIBE TABLE searchlog
"""

df = spark.sql(query)
df.show()
```

```
+------------+---------+-------+
|    col_name|data_type|comment|
+------------+---------+-------+
|          id|      int|   null|
|      market|   string|   null|
|  searchtext|   string|   null|
|     latency|      int|   null|
|       links|   string|   null|
|clickedlinks|   string|   null|
|        time|timestamp|   null|
+------------+---------+-------+

```


## Selecting columns

### Pick which columns to show
```
query =  """
SELECT id, market 
FROM searchlog
"""

df = spark.sql(query)
df.show()
```

```
+------+------+
|    id|market|
+------+------+
|399266| en-us|
|382045| en-gb|
|382045| en-gb|
|106479| en-ca|
|906441| en-us|
|351530| en-fr|
|640806| en-us|
|304305| en-us|
|460748| en-us|
|354841| en-us|
|354068| en-mx|
|674364| en-us|
|347413| en-gr|
|848434| en-ch|
|604846| en-us|
|840614| en-us|
|656666| en-us|
|951513| en-us|
|350350| en-us|
|641615| en-us|
+------+------+
only showing top 20 rows

```

### Calculate a column

```
query =  """
select latency,latency/1000 as latencysec from searchlog
"""

df = spark.sql(query)
df.show()
```

```
+-------+----------+
|latency|latencysec|
+-------+----------+
|     73|     0.073|
|    614|     0.614|
|     74|     0.074|
|     24|     0.024|
|   1213|     1.213|
|    241|     0.241|
|    502|     0.502|
|     60|      0.06|
|   1270|      1.27|
|    610|      0.61|
|    422|     0.422|
|    283|     0.283|
|    305|     0.305|
|     10|      0.01|
|    612|     0.612|
|   1220|      1.22|
|    691|     0.691|
|     63|     0.063|
|     30|      0.03|
|    119|     0.119|
+-------+----------+
only showing top 20 rows

```


### Limiting the number of records returned

```
query =  """
SELECT latency, 
       latency/1000 AS latencysec
FROM searchlog
LIMIT 5
"""

df = spark.sql(query)
df.show()
```

```
+-------+----------+
|latency|latencysec|
+-------+----------+
|     74|     0.074|
|     24|     0.024|
|   1213|     1.213|
|    241|     0.241|
|   1270|      1.27|
+-------+----------+

```


