# Working with Spark Dataframes 

## Introduction

If you come from the SQL world, you may be unused to the mechnics of using dataframes in Spark. 
This document will get your productive fast. Just follow the instructions be and by the end you'll be able
to do basic dataframe manipulations.

## Preparing

You'll need
- an Azure Synapse Analytics workspace. 
- to be assigned the Workspace Admin role in the Synpse Workspace.
- to have contributor access to the Workspace (done via the Azure portal)
- read and write permissions to an ADLSGEN2 account

## Spark pool

If you don't already have, one create a spark pool. For this document, we'll assume it has a name of **spark1**.

## Create a notebook and run a Hello World

Create an new notebook. 
Add a new cell.
In the cell put this code

```
%%pyspark
print("Hello World!")
```

This notebook does almost nothing, but running it ensuresthat the worksapce is configured correctly at some minumum level.

## A note about cell magics

You see that the first line in the cell is `%%pyspark` this is called a **cell magic**. Notebooks have a default language, and this magic override the language in the that cell. We'll use cell magics in this doc because we'll be mixing languages often. 

The specific magic we used indicates that this cell will use the Python language to work with spark.

## Manually creating a dataframe

For debugging and learning, it's very useful to have a dataset available that:
* doesn't require permissions to access
* is guartanteed to always be available to the notebook
* is not too large


## The Searchlog dataset

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
    sqltypes.StructField('id', sqltypes.IntegerType(), True),
    sqltypes.StructField('time', sqltypes.StringType(), True),
    sqltypes.StructField('market', sqltypes.StringType(), True),
    sqltypes.StructField('searchtext', sqltypes.StringType(), True),
    sqltypes.StructField('latency', sqltypes.StringType(), True),
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

Run a cell with this in it and you should see this as the output

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


```
%%pyspark
query =  """
SELECT * 
FROM searchlog
"""

df = spark.sql(query)
df.show()
```

you'll see:

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

## Finding out the schema of a dataframe

```
df.printSchema()
```

```
root
 |-- id: integer (nullable = true)
 |-- market: string (nullable = true)
 |-- searchtext: string (nullable = true)
 |-- latency: string (nullable = true)
 |-- links: string (nullable = true)
 |-- clickedlinks: string (nullable = true)
 |-- time: timestamp (nullable = true)

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


### Sorting the rows


```
query =  """
SELECT latency, 
       latency/1000 AS latencysec
FROM searchlog
ORDER BY latency DESC
"""

df = spark.sql(query)
df.show()
```

```
+-------+----------+
|latency|latencysec|
+-------+----------+
|     74|     0.074|
|    732|     0.732|
|     73|     0.073|
|    691|     0.691|
|    630|      0.63|
|     63|     0.063|
|    614|     0.614|
|    612|     0.612|
|    610|      0.61|
|     60|      0.06|
|    502|     0.502|
|    422|     0.422|
|    305|     0.305|
|     30|      0.03|
|    283|     0.283|
|    241|     0.241|
|     24|     0.024|
|    183|     0.183|
|   1270|      1.27|
|   1220|      1.22|
+-------+----------+
only showing top 20 rows
```

# Basic grouping and aggregations

```
query =  """
SELECT market, 
       COUNT(*) AS sessioncount 
FROM searchlog
GROUP BY market
"""

df = spark.sql(query)
df.show()
```


# string functions - capitilization

```
query =  """
SELECT searchtext, 
       UPPER(searchtext) AS uc_searchtext, 
       LOWER(searchtext) AS lc_searchtext,
       INITCAP(searchtext) AS ic_searchtext
FROM searchlog
"""


df = spark.sql(query)
df.show()
```

```
+--------------------+--------------------+--------------------+
|          searchtext|       uc_searchtext|       lc_searchtext|
+--------------------+--------------------+--------------------+
|  how to make nachos|  HOW TO MAKE NACHOS|  how to make nachos|
|    best ski resorts|    BEST SKI RESORTS|    best ski resorts|
|          broken leg|          BROKEN LEG|          broken leg|
| south park episodes| SOUTH PARK EPISODES| south park episodes|
|              cosmos|              COSMOS|              cosmos|
|           microsoft|           MICROSOFT|           microsoft|
| wireless headphones| WIRELESS HEADPHONES| wireless headphones|
|       dominos pizza|       DOMINOS PIZZA|       dominos pizza|
|                yelp|                YELP|                yelp|
|          how to run|          HOW TO RUN|          how to run|
|         what is sql|         WHAT IS SQL|         what is sql|
|mexican food redmond|MEXICAN FOOD REDMOND|mexican food redmond|
|           microsoft|           MICROSOFT|           microsoft|
|            facebook|            FACEBOOK|            facebook|
|           wikipedia|           WIKIPEDIA|           wikipedia|
|                xbox|                XBOX|                xbox|
|             hotmail|             HOTMAIL|             hotmail|
|             pokemon|             POKEMON|             pokemon|
|             wolfram|             WOLFRAM|             wolfram|
|                kahn|                KAHN|                kahn|
+--------------------+--------------------+--------------------+
only showing top 20 rows
```

## Splitting a string into an array

```
query =  """
SELECT id,
       links, 
       split(links,";") As linksarray
FROM searchlog
"""


df = spark.sql(query)
df.show()
```

```
+------+--------------------+--------------------+
|    id|               links|          linksarray|
+------+--------------------+--------------------+
|399266|www.nachos.com;ww...|[www.nachos.com, ...|
|382045|skiresorts.com;sk...|[skiresorts.com, ...|
|382045|mayoclinic.com/he...|[mayoclinic.com/h...|
|106479|southparkstudios....|[southparkstudios...|
|906441|cosmos.com;wikipe...|[cosmos.com, wiki...|
|351530|microsoft.com;wik...|[microsoft.com, w...|
|640806|www.amazon.com;re...|[www.amazon.com, ...|
|304305|dominos.com;wikip...|[dominos.com, wik...|
|460748|yelp.com;apple.co...|[yelp.com, apple....|
|354841|running.about.com...|[running.about.co...|
|354068|wikipedia.org/wik...|[wikipedia.org/wi...|
|674364|eltoreador.com;ye...|[eltoreador.com, ...|
|347413|microsoft.com;wik...|[microsoft.com, w...|
|848434|facebook.com;face...|[facebook.com, fa...|
|604846|wikipedia.org;en....|[wikipedia.org, e...|
|840614|xbox.com;en.wikip...|[xbox.com, en.wik...|
|656666|hotmail.com;login...|[hotmail.com, log...|
|951513|pokemon.com;pokem...|[pokemon.com, pok...|
|350350|wolframalpha.com;...|[wolframalpha.com...|
|641615|khanacademy.org;e...|[khanacademy.org,...|
+------+--------------------+--------------------+
only showing top 20 rows
```


## Exploding arrows to rows

```
query =  """
SELECT id,
       explode( split(links,";")) AS link
FROM searchlog
"""


df = spark.sql(query)
df.show()
```

```
+------+--------------------+
|    id|                link|
+------+--------------------+
|399266|      www.nachos.com|
|399266|   www.wikipedia.com|
|382045|      skiresorts.com|
|382045|      ski-europe.com|
|382045|www.travelersdige...|
|382045|mayoclinic.com/he...|
|382045|webmd.com/a-to-z-...|
|382045|     mybrokenleg.com|
|382045|wikipedia.com/Bon...|
|106479|southparkstudios.com|
|106479|wikipedia.org/wik...|
|106479|imdb.com/title/tt...|
|106479|      simon.com/mall|
|906441|          cosmos.com|
|906441|wikipedia.org/wik...|
|906441|     hulu.com/cosmos|
|351530|       microsoft.com|
|351530|wikipedia.org/wik...|
|351530|            xbox.com|
|640806|      www.amazon.com|
+------+--------------------+
only showing top 20 rows

```


# Finding a substring

```
query = """
SELECT 
    id, 
    links, 
    locate("mic", links) AS pos
FROM searchlog
"""

df = spark.sql(query)
df.show()

```

```
+------+--------------------+---+
|    id|               links|pos|
+------+--------------------+---+
|399266|www.nachos.com;ww...|  0|
|382045|skiresorts.com;sk...|  0|
|382045|mayoclinic.com/he...|  0|
|106479|southparkstudios....|  0|
|906441|cosmos.com;wikipe...|  0|
|351530|microsoft.com;wik...|  1|
|640806|www.amazon.com;re...|  0|
|304305|dominos.com;wikip...|  0|
|460748|yelp.com;apple.co...|  0|
|354841|running.about.com...|  0|
|354068|wikipedia.org/wik...|  0|
|674364|eltoreador.com;ye...|  0|
|347413|microsoft.com;wik...|  1|
|848434|facebook.com;face...|  0|
|604846|wikipedia.org;en....|  0|
|840614|xbox.com;en.wikip...|  0|
|656666|hotmail.com;login...|  0|
|951513|pokemon.com;pokem...|  0|
|350350|wolframalpha.com;...|  0|
|641615|khanacademy.org;e...|  0|
+------+--------------------+---+
only showing top 20 rows

```

## UDFs

```
import pyspark.sql.functions

def MyUpper(s):
    return s.str.upper()

UDF_MyUpper = pyspark.sql.functions.pandas_udf(MyUpper, sqltypes.StringType())
spark.udf.register("UDF_MyUpper", UDF_MyUpper)

query = """
SELECT 
    id, 
    links,
    UDF_MyUpper(links) AS linksupper 
FROM searchlog
"""

df = spark.sql(query)
df.show()
```

```
+------+--------------------+--------------------+
|    id|               links|          linksupper|
+------+--------------------+--------------------+
|399266|www.nachos.com;ww...|WWW.NACHOS.COM;WW...|
|382045|skiresorts.com;sk...|SKIRESORTS.COM;SK...|
|382045|mayoclinic.com/he...|MAYOCLINIC.COM/HE...|
|106479|southparkstudios....|SOUTHPARKSTUDIOS....|
|906441|cosmos.com;wikipe...|COSMOS.COM;WIKIPE...|
|351530|microsoft.com;wik...|MICROSOFT.COM;WIK...|
|640806|www.amazon.com;re...|WWW.AMAZON.COM;RE...|
|304305|dominos.com;wikip...|DOMINOS.COM;WIKIP...|
|460748|yelp.com;apple.co...|YELP.COM;APPLE.CO...|
|354841|running.about.com...|RUNNING.ABOUT.COM...|
|354068|wikipedia.org/wik...|WIKIPEDIA.ORG/WIK...|
|674364|eltoreador.com;ye...|ELTOREADOR.COM;YE...|
|347413|microsoft.com;wik...|MICROSOFT.COM;WIK...|
|848434|facebook.com;face...|FACEBOOK.COM;FACE...|
|604846|wikipedia.org;en....|WIKIPEDIA.ORG;EN....|
|840614|xbox.com;en.wikip...|XBOX.COM;EN.WIKIP...|
|656666|hotmail.com;login...|HOTMAIL.COM;LOGIN...|
|951513|pokemon.com;pokem...|POKEMON.COM;POKEM...|
|350350|wolframalpha.com;...|WOLFRAMALPHA.COM;...|
|641615|khanacademy.org;e...|KHANACADEMY.ORG;E...|
+------+--------------------+--------------------+
only showing top 20 rows
```
## C# UDF
```
%%csharp

using Functions = Microsoft.Spark.Sql.Functions;

public static class Helpers
{
    public static string MyUpper(string s)
    {
        return s.ToUpper();
    }
}

var UDF_MyUpper = Functions.Udf<string, string>(Helpers.MyUpper);

string query = @"
SELECT 
    id, 
    links,
    UDF_MyUpper(links) AS linksupper 
FROM searchlog
";

var df = spark.Sql(query);
df.Show();
```
