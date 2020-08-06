-- Source: http://www.sqlines.com/oracle/functions/instr
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'instr')
    DROP FUNCTION microsoft.instr;
GO

CREATE FUNCTION microsoft.instr (@expression VARCHAR(8000), @substring VARCHAR(255), @position INT, @occurrence INT)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN

	-- Declarations
	DECLARE @i INT = @occurrence;
	DECLARE @location INT = @position;

	WHILE 1 = 1
	BEGIN
		-- Find the next occurrence
		SET @location = CHARINDEX(@substring, @expression, @location);
 
		-- Nothing found
		IF @location IS NULL OR @location = 0
			RETURN @location;
 
		-- The required occurrence found
		IF @i = 1
			BREAK;
 
		-- Prepare to find another one occurrence
		SET @i = @i - 1;
		SET @location = @location + 1;
	END
 
	RETURN @location;
END
GO