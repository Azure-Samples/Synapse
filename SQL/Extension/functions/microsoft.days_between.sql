IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'days_between')
    DROP FUNCTION microsoft.days_between;
GO

CREATE FUNCTION microsoft.days_between(@expression1 DATETIME2, @expression2)
RETURNS DATETIME2
WITH SCHEMABINDING
AS
BEGIN
	RETURN DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @expression), 0)
END
GO