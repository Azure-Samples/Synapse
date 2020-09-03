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

	DECLARE @character_length INT = DATALENGTH(@characters);
	SET @characters = REPLACE(@characters, '%', '[%]');
	SET @characters = REPLACE(@characters, '_', '[_]');
	SET @characters = @characters + '%';

	RETURN
		CASE PATINDEX(@characters, @expression)
			WHEN 0 THEN @expression
			ELSE SUBSTRING(@expression, PATINDEX(@characters, @expression) + @character_length, DATALENGTH(@expression))
		END
END
GO