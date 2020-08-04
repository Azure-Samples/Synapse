IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'lpad')
    DROP FUNCTION microsoft.lpad;
GO

CREATE FUNCTION microsoft.lpad(@expression VARCHAR(MAX), @length INT, @fill VARCHAR(64) = ' ')
RETURNS VARCHAR(MAX)
WITH SCHEMABINDING
AS
BEGIN

	RETURN
		CASE 
			WHEN (@length <= DATALENGTH(@expression)) THEN LEFT(@expression, @length)
			ELSE LEFT(REPLICATE(@fill, @length), ABS(@length - DATALENGTH(@expression))) + @expression
		END;

END
GO