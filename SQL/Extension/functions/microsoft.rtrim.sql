IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'rtrim')
    DROP FUNCTION microsoft.rtrim;
GO

CREATE FUNCTION microsoft.rtrim(@expression NVARCHAR(MAX), @characters VARCHAR(32) = ' ')
RETURNS NVARCHAR(MAX)
WITH SCHEMABINDING
AS
BEGIN

	-- Fast opt out
	IF (@characters IS NULL OR TRIM(@characters) = '')
		RETURN @expression

	SET @characters = REVERSE(@characters);
	SET @expression = REVERSE(@expression);

	WHILE CHARINDEX(@characters, @expression) = 1
	  BEGIN

		SET @expression = RIGHT(@expression, LEN(@expression) - DATALENGTH(@characters));
	  END 
	
	RETURN REVERSE(@expression);
END
GO