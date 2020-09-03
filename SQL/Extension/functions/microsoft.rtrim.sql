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

	DECLARE @character_length INT = DATALENGTH(@characters);
	SET @characters = REVERSE(@characters);
	SET @characters = REPLACE(@characters, '%', '[%]');
	SET @characters = REPLACE(@characters, '_', '[_]');
	SET @characters = @characters + '%';

	RETURN
		CASE PATINDEX(@characters, REVERSE(@expression))
			WHEN 0 THEN @expression
			ELSE REVERSE(SUBSTRING(REVERSE(@expression), PATINDEX(@characters, REVERSE(@expression)) + @character_length, DATALENGTH(@expression)))
		END
END
GO