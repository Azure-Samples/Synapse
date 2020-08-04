IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'next_day')
    DROP FUNCTION microsoft.next_day;
GO

CREATE FUNCTION microsoft.next_day(@date_timestamp DATETIME2, @day_value VARCHAR(15))
RETURNS DATETIME2
WITH SCHEMABINDING
AS
BEGIN

	IF @day_value IS NULL
		RETURN NULL;

	DECLARE @day_value_internal TINYINT;
	DECLARE @day_value_abbr CHAR(3) = LEFT(UPPER(@day_value), 3);

	SET
		@day_value_internal =
			CASE
				WHEN @day_value_abbr = 'MON' THEN 0
				WHEN @day_value_abbr = 'TUE' THEN 1
				WHEN @day_value_abbr = 'WED' THEN 2
				WHEN @day_value_abbr = 'THU' THEN 3
				WHEN @day_value_abbr = 'FRI' THEN 4
				WHEN @day_value_abbr = 'SAT' THEN 5
				WHEN @day_value_abbr = 'SUN' THEN 6
				ELSE
					CAST('Unknown day abbreviation ''' + @day_value + '''' AS INT)
			END;

	RETURN
		DATEADD(DAY, (DATEDIFF(DAY, @day_value_internal, @date_timestamp) / 7) * 7 + 7, @day_value_internal)
	
END
GO