IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'getbit')
    DROP FUNCTION microsoft.getbit;
GO

CREATE FUNCTION microsoft.getbit(@value INT, @position INT)
RETURNS BIT
WITH SCHEMABINDING
AS
BEGIN
	
	-- Fast opt out for NULL values
	IF (@value IS NULL OR @position IS NULL)
		RETURN NULL;

	DECLARE @temp_value VARCHAR(1000) = '';

	WHILE (@value != 0)
	BEGIN
		IF (@value % 2 = 0)
			SET @temp_value = '0' + @temp_value;
		ELSE
			SET @temp_value = '1' + @temp_value;
   
		SET @value = @value / 2;

	END;

	RETURN SUBSTRING(REVERSE(@temp_value), @position + 1, 1);

END;
GO