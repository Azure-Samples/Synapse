

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
