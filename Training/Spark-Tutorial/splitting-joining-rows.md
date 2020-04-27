## Splitting a string into an array

```
query =  """
SELECT id,
       links, 
       split(links,";") As linksarray
FROM sparktutorial.searchlog
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


## Exploding arrays to rows

```
query =  """
SELECT id,
       explode( split(links,";")) AS link
FROM sparktutorial.searchlog
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
