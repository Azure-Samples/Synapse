IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'firstdayofquarter')
    DROP FUNCTION microsoft.firstdayofquarter;
GO

CREATE FUNCTION microsoft.firstdayofquarter(@expression DATETIME2)
RETURNS DATETIME2
WITH SCHEMABINDING
AS
BEGIN
	RETURN DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @expression), 0)
END
GO