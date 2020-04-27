
# Working with strings

## Capitilization


```
%%sql
query =  """
SELECT searchtext, 
       UPPER(searchtext) AS uc_searchtext, 
       LOWER(searchtext) AS lc_searchtext,
       INITCAP(searchtext) AS ic_searchtext
FROM sparktutorial.searchlog
"""


df = spark.sql(query)
df.show()
```

## Finding Substrings

```
%%sql
query = """
SELECT 
    id, 
    links, 
    locate("mic", links) AS pos
FROM sparktutorial.searchlog
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

