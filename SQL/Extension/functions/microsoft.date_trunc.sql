IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'date_trunc')
    DROP FUNCTION microsoft.date_trunc;
GO

CREATE FUNCTION microsoft.date_trunc(@unit VARCHAR(15), @expression DATETIME2)
RETURNS DATETIME2
WITH SCHEMABINDING
AS
BEGIN

	-- Declarations
	DECLARE @result DATETIME2;
    DECLARE @template VARCHAR(27)

	SET @unit = UPPER(@unit);

	-- Special handle Century, Quarter and Week
	IF (@unit = 'CENTURY')
		RETURN CAST('01/01/' + CAST((((1 + (YEAR(@expression) -1)) / 100) * 100) AS VARCHAR(4)) + ' 00:00:00.00000' AS DATETIME2)

	IF (@unit = 'WEEK')
		RETURN DATEADD(DAY, -(DATEPART(WEEKDAY, @expression) - 1), DATEADD(DAY, DATEDIFF(DAY, 0, @expression), 0) )

	IF (@unit = 'QUARTER')
		RETURN microsoft.FirstDayOfQuarter(@expression);

	SET
		@template = 
		(
			CASE
				-- Year
				WHEN @unit = 'Y' OR @unit = 'YEAR' THEN '01/01/yyyy'

				-- Month
				WHEN @unit = 'M' OR @unit = 'MONTH' THEN 'MM/01/yyyy'

				-- Day
				WHEN @unit = 'D' OR @unit = 'DAY' THEN 'MM/dd/yyyy'

				-- Hour
				WHEN @unit = 'H' OR @unit = 'HOUR' THEN 'MM/dd/yyyy hh:00:00.000000'

				-- Minute
				WHEN @unit = 'MINUTE' THEN 'MM/dd/yyyy hh:mm:00.000000'

				-- Second
				WHEN @unit = 'S' OR @unit = 'SECOND' THEN 'MM/dd/yyyy hh:mm:ss.000000'

				-- Millisecond 
				WHEN @unit = 'MS' OR @unit = 'MILLISECOND' THEN 'MM/dd/yyyy hh:mm:ss.ff0000'

				-- Microsecond 
				WHEN @unit = 'MICROSECOND' THEN 'MM/dd/yyyy hh:mm:ss.ffffff'

				-- Nanosecond 
				-- Note: Nanosecond is not a supported datetime unit in the DATEADD function

				ELSE 'MM/dd/yyyy hh:mm:ss.fffffff'
			END
		);

	RETURN FORMAT(@expression, @template);

END
GO