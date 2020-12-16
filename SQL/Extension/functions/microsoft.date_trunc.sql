IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'date_trunc')
    DROP FUNCTION microsoft.date_trunc;
GO

/*
Note: The DATEDIFF function returns a 4-byte integer (int). Until Azure Synapse SQL supports DATEDIFF_BIG 
	  with an 8-byte integer return type, date_trunc can and likely will throw an overflow exception when
	  truncating small date_part units like second or smaller.
*/

CREATE FUNCTION microsoft.date_trunc(@unit VARCHAR(15), @expression VARCHAR(8000))
RETURNS DATETIME2
WITH SCHEMABINDING
AS
BEGIN

	-- Declarations
	DECLARE @result DATETIME2;

	SET @unit = UPPER(@unit);

	SET
		@result = 
		(
			CASE
				-- Year
				WHEN @unit = 'Y' OR @unit = 'YEAR' THEN DATEADD(YEAR, DATEDIFF(YEAR, 0, @expression), 0) 

				-- Month
				WHEN @unit = 'M' OR @unit = 'MONTH' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, @expression), 0) 

				-- Day
				WHEN @unit = 'D' OR @unit = 'DAY' THEN DATEADD(DAY, DATEDIFF(DAY, 0, @expression), 0) 

				-- Hour
				WHEN @unit = 'H' OR @unit = 'HOUR' THEN DATEADD(HOUR, DATEDIFF(HOUR, 0, @expression), 0) 

				-- Minute
				WHEN @unit = 'MINUTE' THEN DATEADD(MINUTE, DATEDIFF(MINUTE, 0, @expression), 0) 

				-- Second
				WHEN @unit = 'S' OR @unit = 'SECOND' THEN DATEADD(SECOND, DATEDIFF(SECOND, 0, @expression), 0) 

				-- Millisecond 
				WHEN @unit = 'MILLISECOND' THEN DATEADD(MILLISECOND, DATEDIFF(MILLISECOND, 0, @expression), 0) 

				-- Microsecond 
				WHEN @unit = 'MICROSECOND' THEN DATEADD(MICROSECOND, DATEDIFF(MICROSECOND, 0, @expression), 0) 

				-- Nanosecond 
				WHEN @unit = 'NANOSECOND' THEN DATEADD(NANOSECOND, DATEDIFF(NANOSECOND, 0, @expression), 0) 
			END
		);

	RETURN @result;

END
GO