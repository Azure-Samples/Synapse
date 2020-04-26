# The Searchlog dataset


## Overview

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

## Create the dataset

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

