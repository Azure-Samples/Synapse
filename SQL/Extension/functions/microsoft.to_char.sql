IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'to_char')
    DROP FUNCTION microsoft.to_char;
GO

CREATE FUNCTION microsoft.to_char(@date datetime2, @format VARCHAR(32) = '')
RETURNS VARCHAR(128)
WITH SCHEMABINDING
AS
BEGIN

	-- Fast opt out
	IF (@date IS NULL OR TRIM(@format) = '')
		RETURN @date;

	DECLARE @format_internal VARCHAR(48) = @format;
	DECLARE @date_internal VARCHAR(256);

	-- Special case for Day of Year (DDD or D3)
	IF ( (CHARINDEX('DDD', @format_internal COLLATE Latin1_General_CS_AS) > 0) OR (CHARINDEX('D3', @format_internal COLLATE Latin1_General_CS_AS) > 0) )
	  BEGIN
		-- Ideally will support THROW here in a future Azure Synapse SQL release.
		RETURN 'The format ''DDD'' (Day of Year) is not supported in T-SQL. Please try using the DATEPART(DAYOYYEAR, expression) syntax.'
	  END

	-- Special cases for hour separator
	SET @format_internal = REPLACE(@format_internal COLLATE Latin1_General_CS_AS, 'h', '\h');

	-- Special case for minute separator
	SET @format_internal = REPLACE(@format_internal COLLATE Latin1_General_CS_AS, 'm', '\m');

		-- Special case for second separator
	SET @format_internal = REPLACE(@format_internal COLLATE Latin1_General_CS_AS, 's', '\s');

	-- Replacements for year
	SET @format_internal = REPLACE(@format_internal, 'YYYY', 'yyyy');
	SET @format_internal = REPLACE(@format_internal, 'Y4', 'yyyy');
	SET @format_internal = REPLACE(@format_internal, 'YY', 'yy');

	-- Replacements for month
	SET @format_internal = REPLACE(@format_internal, 'M4', 'MMMM');
	SET @format_internal = REPLACE(@format_internal, 'M3', 'MMM');

	-- Replacements for day
	SET @format_internal = REPLACE(@format_internal, 'DD', 'dd');
	SET @format_internal = REPLACE(@format_internal, 'D', 'd ');

	-- Replacements for hour

	-- Replacements for minute
	SET @format_internal = REPLACE(@format_internal, 'MI', 'mm');

	-- Replacements for 12/24 hour clock
	SET @format_internal = REPLACE(@format_internal, 'T', 'tt');

	-- Replacements for seconds
	SET @format_internal = REPLACE(@format_internal, 'SS', 'ss');

	-- Replacements for day of the week
	SET @format_internal = REPLACE(@format_internal, 'EEEE', 'dddd');
	SET @format_internal = REPLACE(@format_internal, 'E4', 'dddd');

	SET @format_internal = REPLACE(@format_internal, 'EEE', 'ddd');
	SET @format_internal = REPLACE(@format_internal, 'E3', 'ddd');

	-- Replacements for separator B | b
	SET @format_internal = REPLACE(@format_internal, 'B', ' ');
	SET @format_internal = REPLACE(@format_internal, 'b', ' ');

	SET @date_internal = FORMAT(@date, @format_internal);	

	RETURN @date_internal;

END
GO