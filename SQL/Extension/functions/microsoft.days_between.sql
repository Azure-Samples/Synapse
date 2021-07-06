IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'days_between')
    DROP FUNCTION microsoft.days_between;
GO

CREATE FUNCTION microsoft.days_between(@expression1 DATETIME2, @expression2 DATETIME2)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
	RETURN DATEDIFF(HOUR, @expression1, @expression2) / 24
END
GO

SELECT
    microsoft.days_between('01/01/2021 00:00:00.000000', '01/01/2021 23:59:59.9999999'),
    microsoft.days_between('01/01/2021 00:00:00.000000', '01/02/2021 23:59:59.9999999'),
    microsoft.days_between('01/01/2021 10:00:00.000000', '01/03/2021 10:59:59.9999999');