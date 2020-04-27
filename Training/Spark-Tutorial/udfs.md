# User-Defined Functions (UDFs)

## Python UDFs

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
FROM sparktutorial.searchlog
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
## C# UDFs

NOTE: There is a current limitation with .NET for Spark that requires
the UDFs to be registered in a separate cell than when they are used.

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

spark.Udf().Register<string, string>("UDF_MyUpper", Helpers.MyUpper);

```

```
%%csharp

string query = @"
SELECT 
    id, 
    links,
    UDF_MyUpper(links) AS linksupper 
FROM sparktutorial.searchlog
";

var df = spark.Sql(query);
df.Show();
```
