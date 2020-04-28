
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

## Removing whitespace


```
%%sql
query =  """
SELECT searchtext, 
       trim(searchtext) AS trim_searchtext, 
       rtrim(searchtext) AS rtrim_searchtext,
       rtrim(searchtext) AS rtrim_searchtext
FROM sparktutorial.searchlog
"""

df = spark.sql(query)
df.show()
```

## Finding Substrings

```
%%pyspark
query = """
SELECT 
    id, 
    links, 
    locate("mic", links) AS pos
FROM sparktutorial.searchlog
LIMIT 5
"""

df = spark.sql(query)
df.show()
```

```
+------+--------------------+---+
|    id|               links|pos|
+------+--------------------+---+
|382045|mayoclinic.com/he...|  0|
|106479|southparkstudios....|  0|
|906441|cosmos.com;wikipe...|  0|
|351530|microsoft.com;wik...|  1|
|460748|yelp.com;apple.co...|  0|
+------+--------------------+---+
```

## Splitting a string into an array

```
query =  """
SELECT id,
       links, 
       split(links,";") As linksarray
FROM sparktutorial.searchlog
"""

df = spark.sql(query)
df.show(5)
```

```
+------+--------------------+--------------------+
|    id|               links|          linksarray|
+------+--------------------+--------------------+
|382045|mayoclinic.com/he...|[mayoclinic.com/h...|
|106479|southparkstudios....|[southparkstudios...|
|906441|cosmos.com;wikipe...|[cosmos.com, wiki...|
|351530|microsoft.com;wik...|[microsoft.com, w...|
|321065|gap.com;overstock...|[gap.com, oversto...|
+------+--------------------+--------------------+
only showing top 5 rows
```