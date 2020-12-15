IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'firstdayofyear')
    DROP FUNCTION microsoft.firstdayofyear;
GO

CREATE FUNCTION microsoft.firstdayofyear(@expression VARCHAR(8000))
RETURNS DATETIME2
WITH SCHEMABINDING
AS
BEGIN

	RETURN DATEADD(YEAR, DATEDIFF(YEAR, 0, @expression), 0)
END
GO