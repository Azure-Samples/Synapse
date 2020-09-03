IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'btrim')
    DROP FUNCTION microsoft.btrim;
GO

CREATE FUNCTION microsoft.btrim(@expression NVARCHAR(MAX), @characters VARCHAR(32) = ' ')
RETURNS NVARCHAR(MAX)
WITH SCHEMABINDING
AS
BEGIN

	-- Fast opt out
	IF (@characters IS NULL OR TRIM(@characters) = '')
		RETURN @expression

	RETURN
		microsoft.ltrim(microsoft.rtrim(@expression, @characters), @characters)
END
GO