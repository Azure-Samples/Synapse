IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'initcap')
    DROP FUNCTION microsoft.initcap;
GO

CREATE FUNCTION microsoft.initcap(@expression VARCHAR(8000))
RETURNS VARCHAR(8000)
WITH SCHEMABINDING
AS
BEGIN

	
	-- Declarations
	DECLARE @character CHAR(1);
	DECLARE @isalphanumeric BIT = 0;
	DECLARE @length INT = LEN(@expression);
	DECLARE @output VARCHAR(8000) = LOWER(@expression);
	DECLARE @position INT = 1;
	
    -- Iterate through all characters in the input string
    WHILE @position <= @length BEGIN
 
      -- Get the next character
      SET @character = SUBSTRING(@expression, @position, 1);
 
      -- If the position is first, or the previous characater is not alphanumeric
      -- convert the current character to upper case
      IF @position = 1 OR @isalphanumeric = 0
        SET @output = STUFF(@output, @position, 1, UPPER(@character));
 
      SET @position = @position + 1;
 
      -- Define if the current character is non-alphanumeric
      IF ASCII(@character) <= 47
		OR (ASCII(@character) BETWEEN 58 AND 64)
		OR (ASCII(@character) BETWEEN 91 AND 96)
		OR (ASCII(@character) BETWEEN 123 AND 126)
		SET @isalphanumeric = 0;
      ELSE
		SET @isalphanumeric = 1;
	END
 
	RETURN @output;

END
GO