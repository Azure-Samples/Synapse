
# Basic grouping and aggregations

```
query =  """
SELECT market, 
       COUNT(*) AS sessioncount 
FROM sparktutorial.searchlog
GROUP BY market
"""

df = spark.sql(query)
df.show()
```

## Common aggregates

* AVG
* COUNT
* COUNTDISTINCT
* MAX
* MIN
* STDDEV 
* STDDEV_SAMPLE
* STDDEV_POP
* SUM
* VAR_SAMP
* VAR_POP

