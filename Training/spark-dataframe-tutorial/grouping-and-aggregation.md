
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

