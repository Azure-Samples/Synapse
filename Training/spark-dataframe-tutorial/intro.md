# Working with Synapse Spark and Dataframes 

## Introduction

This tutorial is for developers new to Azure Synapse who need to get productive 
with basic Spark programming.

* You don't need to haved a background in Spark at all
* It will help if you have a basic knowledge of SQL queries
* Knowledge of Python or C# will help

Just read the sections one-by-one and by the end you'll be ready to use Spark in Synapse. 

## Preparing

You'll need:
- an Azure Synapse Analytics workspace. 
- to be assigned the Workspace Admin role in the Synpse Workspace.
- to have contributor access to the Workspace (done via the Azure portal)
- read and write permissions to an ADLSGEN2 account

## Spark pool

If you don't already have, one create a spark pool. For this document, we'll assume it has a name of **spark1**.

## Information you should have ready
* The name of your Synapse workspace
* The name AAD Directory you will use
* The name Azure Subscription that your Synapse workspace is in
* The name of the Primary ADLSGEN2 account your Synapse uses
* The name of the default container in that ADLSGEN2 account used by your Synapse workspace
* The name of the spark pool you will use

# Launch Synapse Studio

Go here: https://web.azuresynapse.net/

Choose the appropriate:
* Directory
* Subscriptoin
* Workspace

## Create a notebook and run a Hello World

* Go to the **Develop** hub and create an new notebook. 
* Add a new code cell.
* In the cell put this code

```
%%pyspark
print("Hello World!")
```

* In the notebook, set **Attach to** to **spark1**
* Click **Run all** or click the **Run** icon on that cell.

This notebook does almost nothing, but running it ensures that the worksapce is configured correctly at some minumum level.

## A note about cell magics

You see that the first line in the cell is `%%pyspark` this is called a **cell magic**. Notebooks have a default language, and this magic override the language in the that cell. We'll use cell magics in this doc because we'll be mixing languages often. 

The specific magic we used indicates that this cell will use the Python language to work with spark.

In this tutorial we will use these magics:

* `%%pyspark`
* `%%sql`
* `%%csharp`


## The Searchlog dataset

Run the folllowing code to create a dataframe the searchlog dataset. Don't both trying to understand what the code does. We'll explain everything it does at various points in the tutorial.

```
import pyspark.sql.types as sqltypes

searchlog_data = [ 
    [399266 , "2019-10-15T11:53:04Z" , "en-us" , "how to make nachos" , 73 , "www.nachos.com;www.wikipedia.com" , "NULL" ], 
    [382045 , "2019-10-15T11:53:25Z" , "en-gb" , "best ski resorts" , 614 , "skiresorts.com;ski-europe.com;www.travelersdigest.com/ski_resorts.htm" , "ski-europe.com;www.travelersdigest.com/ski_resorts.htm" ], 
    [382045 , "2019-10-16T11:53:42Z" , "en-gb" , "broken leg" , 74 , "mayoclinic.com/health;webmd.com/a-to-z-guides;mybrokenleg.com;wikipedia.com/Bone_fracture" , "mayoclinic.com/health;webmd.com/a-to-z-guides;mybrokenleg.com;wikipedia.com/Bone_fracture" ], 
    [106479 , "2019-10-16T11:53:10Z" , "en-ca" , "south park episodes" , 24 , "southparkstudios.com;wikipedia.org/wiki/Sout_Park;imdb.com/title/tt0121955;simon.com/mall" , "southparkstudios.com" ], 
    [906441 , "2019-10-16T11:54:18Z" , "en-us" , "cosmos" , 1213 , "cosmos.com;wikipedia.org/wiki/Cosmos:_A_Personal_Voyage;hulu.com/cosmos" , "NULL" ], 
    [351530 , "2019-10-16T11:54:29Z" , "en-fr" , "microsoft" , 241 , "microsoft.com;wikipedia.org/wiki/Microsoft;xbox.com" , "NULL" ], 
    [640806 , "2019-10-16T11:54:32Z" , "en-us" , "wireless headphones" , 502 , "www.amazon.com;reviews.cnet.com/wireless-headphones;store.apple.com" , "www.amazon.com;store.apple.com" ], 
    [304305 , "2019-10-16T11:54:45Z" , "en-us" , "dominos pizza" , 60 , "dominos.com;wikipedia.org/wiki/Domino's_Pizza;facebook.com/dominos" , "dominos.com" ], 
    [460748 , "2019-10-16T11:54:58Z" , "en-us" , "yelp" , 1270 , "yelp.com;apple.com/us/app/yelp;wikipedia.org/wiki/Yelp_Inc.;facebook.com/yelp" , "yelp.com" ], 
    [354841 , "2019-10-16T11:59:00Z" , "en-us" , "how to run" , 610 , "running.about.com;ehow.com;go.com" , "running.about.com;ehow.com" ], 
    [354068 , "2019-10-16T12:00:07Z" , "en-mx" , "what is sql" , 422 , "wikipedia.org/wiki/SQL;sqlcourse.com/intro.html;wikipedia.org/wiki/Microsoft_SQL" , "wikipedia.org/wiki/SQL" ], 
    [674364 , "2019-10-16T12:00:21Z" , "en-us" , "mexican food redmond" , 283 , "eltoreador.com;yelp.com/c/redmond-wa/mexican;agaverest.com" , "NULL" ], 
    [347413 , "2019-10-16T12:11:34Z" , "en-gr" , "microsoft" , 305 , "microsoft.com;wikipedia.org/wiki/Microsoft;xbox.com" , "NULL" ], 
    [848434 , "2019-10-16T12:12:14Z" , "en-ch" , "facebook" , 10 , "facebook.com;facebook.com/login;wikipedia.org/wiki/Facebook" , "facebook.com" ], 
    [604846 , "2019-10-16T12:13:18Z" , "en-us" , "wikipedia" , 612 , "wikipedia.org;en.wikipedia.org;en.wikipedia.org/wiki/Wikipedia" , "wikipedia.org" ], 
    [840614 , "2019-10-16T12:13:41Z" , "en-us" , "xbox" , 1220 , "xbox.com;en.wikipedia.org/wiki/Xbox;xbox.com/xbox360" , "xbox.com/xbox360" ], 
    [656666 , "2019-10-16T12:15:19Z" , "en-us" , "hotmail" , 691 , "hotmail.com;login.live.com;msn.com;en.wikipedia.org/wiki/Hotmail" , "NULL" ], 
    [951513 , "2019-10-16T12:17:37Z" , "en-us" , "pokemon" , 63 , "pokemon.com;pokemon.com/us;serebii.net" , "pokemon.com" ], 
    [350350 , "2019-10-16T12:18:17Z" , "en-us" , "wolfram" , 30 , "wolframalpha.com;wolfram.com;mathworld.wolfram.com;en.wikipedia.org/wiki/Stephen_Wolfram" , "NULL" ], 
    [641615 , "2019-10-16T12:19:21Z" , "en-us" , "kahn" , 119 , "khanacademy.org;en.wikipedia.org/wiki/Khan_(title);answers.com/topic/genghis-khan;en.wikipedia.org/wiki/Khan_(name)" , "khanacademy.org" ], 
    [321065 , "2019-10-16T12:20:19Z" , "en-us" , "clothes" , 732 , "gap.com;overstock.com;forever21.com;footballfanatics.com/college_washington_state_cougars" , "footballfanatics.com/college_washington_state_cougars" ], 
    [651777 , "2019-10-16T12:20:49Z" , "en-us" , "food recipes" , 183 , "allrecipes.com;foodnetwork.com;simplyrecipes.com" , "foodnetwork.com" ], 
    [666352 , "2019-10-16T12:21:16Z" , "en-us" , "weight loss" , 630 , "en.wikipedia.org/wiki/Weight_loss;webmd.com/diet;exercise.about.com" , "webmd.com/diet" ]
    ]

searchog_schema = sqltypes.StructType([
    sqltypes.StructField('id', sqltypes.IntegerType(), False),
    sqltypes.StructField('time', sqltypes.StringType(), False),
    sqltypes.StructField('market', sqltypes.StringType(), False),
    sqltypes.StructField('searchtext', sqltypes.StringType(), False),
    sqltypes.StructField('latency', sqltypes.IntegerType(), False),
    sqltypes.StructField('links', sqltypes.StringType(), True),
    sqltypes.StructField('clickedlinks', sqltypes.StringType(), True)
])
 
df_searchlog = spark.createDataFrame(searchlog_data, searchog_schema)

def cast_column(df_, colname, t):
    df_ = df_.withColumn("NewCol__", df_[colname].cast(t))
    df_ = df_.drop(colname)
    df_ = df_.withColumnRenamed("NewCol__",colname)
    return df_

df_searchlog = cast_column(df_searchlog, "time", sqltypes.TimestampType() )
df_searchlog.createOrReplaceTempView("searchlog") 
df_searchlog.show()
```

Once you run this cell you can access the search through several mechanisms

The cell created a dataframe called **df_searchlog**. You can use the dataframe directly.

```
%%pyspark
df_searchlog.show()
```

This is the output

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

You can query using the temporary view with Spark SQL

```
%%sql
SELECT * 
FROM searchlog
```

The benefit of using Spark SQL, is that many operations will be familiar to you 
based on your SQL experience. 


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

## Find the dataframe schema

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


## Understanding the SearchLog dataset

The SearchLog dataset is hand-built to teach how to do basic, real-world operations
on data that developers will most commonly need to do. 

The "story" behind the SearchLog dataset is that there's is a search enginer (like Bing).
Users search for things. When they search for something they spend some amount of time seeing links, some of which they click on or not. The time they spend looking through the search results are a user session. The users may be searching from different markets - that is geographical regions. 

Every row in the dataset represents a search session. The schema is shown below:

Now we look at the schema:
* id - integer - the session  
* market - string - the geographical region
* searchtext -  string - what the user searched for
* latency - int - how long the search engine took to get the results in milliseconds
* links - string - semicolon-separated list of all the links the user was presented 
* clickedlinks - string - semicolon-separated list of all the links the user actually clicked on
* time - timestamp - when the search was issued

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


## SELECT

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



