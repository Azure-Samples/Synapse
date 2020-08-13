IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'rpad')
    DROP FUNCTION microsoft.rpad;
GO

CREATE FUNCTION microsoft.rpad(@expression VARCHAR(MAX), @length INT, @fill VARCHAR(64) = ' ')
RETURNS VARCHAR(MAX)
WITH SCHEMABINDING
AS
BEGIN

	RETURN
		CASE
			WHEN (@length <= DATALENGTH(@expression)) THEN LEFT(@expression, @length)
			ELSE @expression + LEFT(REPLICATE(@fill, @length), ABS(@length - DATALENGTH(@expression)))
		END

END
GO