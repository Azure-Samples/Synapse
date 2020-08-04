IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'dayoccurrence_of_month')
    DROP FUNCTION microsoft.dayoccurrence_of_month;
GO

CREATE FUNCTION microsoft.dayoccurrence_of_month(@expression VARCHAR(8000))
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN

	RETURN CASE WHEN DATEPART(DAY, @expression) % 7 = 0 THEN DATEPART(DAY, @expression) / 7 ELSE DATEPART(DAY, @expression) / 7 + 1 END
END
GO