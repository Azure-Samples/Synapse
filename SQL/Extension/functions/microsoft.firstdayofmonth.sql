IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'firstdayofmonth')
    DROP FUNCTION microsoft.firstdayofmonth;
GO

CREATE FUNCTION microsoft.firstdayofmonth(@expression VARCHAR(8000))
RETURNS DATETIME2
WITH SCHEMABINDING
AS
BEGIN

	RETURN DATEADD(DAY, 1, EOMONTH(@expression, -1))	
END
GO