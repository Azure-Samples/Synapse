DROP VIEW IF EXISTS microsoft.dw_extension_version;
GO

CREATE VIEW microsoft.dw_extension_version
AS

	SELECT
		[version] =	CAST('0.8.0.0' AS VARCHAR(20));
GO