IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'random')
    DROP FUNCTION microsoft.random;
GO

CREATE FUNCTION microsoft.random(@lower_bound INT, @upper_bound INT, @random float)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
	
	-- Add error handling when Azure Synapse SQL supports THROW
	--IF (@lower_bound > @upper_bound)
	--  BEGIN
	--	THROW 51000, 'The RANDOM function has invalid arguments.';
	--  END	
	
	-- Declarations
	DECLARE @range INT = (@upper_bound - @lower_bound + 1);
	
	RETURN FLOOR( ( @random * @range ) + @lower_bound);

END
GO