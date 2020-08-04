IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'acosh')
    DROP FUNCTION microsoft.acosh;
GO

CREATE FUNCTION microsoft.acosh(@expression VARCHAR(8000))
RETURNS FLOAT
WITH SCHEMABINDING
AS
BEGIN

	RETURN LOG(@expression + SQRT((CAST(@expression AS FLOAT) * CAST(@expression AS FLOAT)) - 1))
END
GO