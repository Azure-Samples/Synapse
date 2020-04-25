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
