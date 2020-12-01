IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'to_char')
    DROP FUNCTION microsoft.to_char;
GO

CREATE FUNCTION microsoft.to_char(@date datetime, @format VARCHAR(32) = '')
RETURNS NVARCHAR(MAX)
WITH SCHEMABINDING
AS
BEGIN

	-- Fast opt out
	IF (@date IS NULL OR TRIM(@format) = '')
		RETURN @date;

	DECLARE @format_internal VARCHAR(48) = @format;

	-- Replacements for year
	SET @format_internal = REPLACE(@format_internal, 'YYYY', 'yyyy');
	SET @format_internal = REPLACE(@format_internal, 'Y4', 'yyyy');
	SET @format_internal = REPLACE(@format_internal, 'YY', 'yy');

	-- Replacements for month
	SET @format_internal = REPLACE(@format_internal, 'M4', 'MMMM');
	SET @format_internal = REPLACE(@format_internal, 'M3', 'MMM');

	-- Replacements for day
	--SET @format_internal = REPLACE(@format_internal, 'DDD', 'ddd');	
	--SET @format_internal = REPLACE(@format_internal, 'D3', 'ddd');
	SET @format_internal = REPLACE(@format_internal, 'DD', 'dd');

	-- Replacements for hour

	-- Replacements for minute
	SET @format_internal = REPLACE(@format_internal, 'MI', 'mm');

	-- Replacements for seconds
	SET @format_internal = REPLACE(@format_internal, 'SS', 'ss');

	-- Replacements for day of the week
	SET @format_internal = REPLACE(@format_internal, 'EEEE', '');
	SET @format_internal = REPLACE(@format_internal, 'E4', '');

	SET @format_internal = REPLACE(@format_internal, 'EEE', '');
	SET @format_internal = REPLACE(@format_internal, 'E3', '');

	-- Replacements for separator B | b
	SET @format_internal = REPLACE(@format_internal, 'B', ' ');
	SET @format_internal = REPLACE(@format_internal, 'b', ' ');

	--RETURN FORMAT(@date, @format_internal);
	RETURN (@format_internal);

END
GO