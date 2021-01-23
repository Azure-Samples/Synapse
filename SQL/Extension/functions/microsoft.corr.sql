IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'corr')
    DROP FUNCTION microsoft.corr;
GO

CREATE FUNCTION microsoft.corr(@expression1 REAL, @expression2 REAL)
RETURNS FLOAT
WITH SCHEMABINDING
AS
BEGIN

	RETURN CAST((COUNT(*) * SUM(@expression1 * @expression2) - SUM(@expression1) * SUM(@expression2)) / (SQRT(COUNT(*) * SUM(@expression1 * @expression1) - SUM(@expression1) * SUM(@expression1)) * SQRT(COUNT(*) * SUM(@expression2* @expression2) - SUM(@expression2) * SUM(@expression2))) AS DECIMAL(7,6))
    
END
GO