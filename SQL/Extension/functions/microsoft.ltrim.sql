IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'ltrim')
    DROP FUNCTION microsoft.ltrim;
GO

CREATE FUNCTION microsoft.ltrim(@expression NVARCHAR(MAX), @characters VARCHAR(32) = ' ')
RETURNS NVARCHAR(MAX)
WITH SCHEMABINDING
AS
BEGIN

	-- Fast opt out
	IF (@characters IS NULL OR TRIM(@characters) = '')
		RETURN @expression

	WHILE CHARINDEX(@characters, @expression) = 1
	  BEGIN

		SET @expression = RIGHT(@expression, LEN(@expression) - DATALENGTH(@characters));
	  END 
	
	RETURN @expression;
END
GO