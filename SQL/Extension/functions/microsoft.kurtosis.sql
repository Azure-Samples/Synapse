IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'kurtosis')
    DROP FUNCTION microsoft.kurtosis;
GO

CREATE FUNCTION microsoft.kurtosis(@expression REAL)
RETURNS FLOAT
WITH SCHEMABINDING
AS
BEGIN
	
	DECLARE @result FLOAT;
	
	SET @result = (SUM( CAST ( POWER(1.0 * CAST(@expression AS FLOAT), 4) AS FLOAT ) ) - 4 * SUM( CAST ( POWER(1.0 * CAST(@expression AS FLOAT), 3) AS FLOAT ) ) * CAST(AVG(1.0 * @expression) AS FLOAT) + 6 * SUM( CAST ( POWER(1.0 * CAST(@expression AS FLOAT), 2) AS FLOAT ) ) * CAST(AVG(1.0 * @expression) AS FLOAT) * CAST(AVG(1.0 * @expression) AS FLOAT) - 4 * SUM(1.0 * @expression) * CAST(AVG(1.0 * @expression) AS FLOAT) * CAST(AVG(1.0 * @expression) AS FLOAT) * CAST(AVG(1.0 * @expression) AS FLOAT) + COUNT_BIG(1.0 * @expression) * CAST(AVG(1.0 * @expression) AS FLOAT) * CAST(AVG(1.0 * @expression) AS FLOAT) * CAST(AVG(1.0 * @expression) AS FLOAT) * CAST(AVG(1.0 * @expression) AS FLOAT)) / (STDEV(@expression) * STDEV(@expression) * STDEV(@expression) * STDEV(@expression)) * COUNT_BIG(1.0 * @expression) * (COUNT_BIG(1.0 * @expression) + 1) / (COUNT_BIG(1.0 * @expression) - 1) / (COUNT_BIG(1.0 * @expression) - 2) / (COUNT_BIG(1.0 * @expression) - 3) - 3.0 * (COUNT_BIG(1.0 * @expression) - 1) * (COUNT_BIG(1.0 * @expression) - 1) / (COUNT_BIG(1.0 * @expression) - 2) / (COUNT_BIG(1.0 * @expression) - 3);

	RETURN @result;

END
GO