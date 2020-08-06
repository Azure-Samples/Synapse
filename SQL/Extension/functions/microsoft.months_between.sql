IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'months_between')
    DROP FUNCTION microsoft.months_between;
GO

CREATE FUNCTION microsoft.months_between(@date_timestamp2 DATETIME2, @date_timestamp1 DATETIME2)
RETURNS DECIMAL(38,14)
WITH SCHEMABINDING
AS
BEGIN

	RETURN
		CAST((DATEDIFF(MONTH, @date_timestamp1, @date_timestamp2) + ((DATEDIFF(DAY, DATEADD(MONTH, DATEDIFF(MONTH, DATEADD(YEAR, DATEDIFF(YEAR, @date_timestamp1, @date_timestamp2), @date_timestamp1), @date_timestamp2), DATEADD(YEAR, DATEDIFF(YEAR, @date_timestamp1, @date_timestamp2), @date_timestamp1)), @date_timestamp2)) / 31.0)) AS DECIMAL(38,14))
END
GO