DROP VIEW IF EXISTS [microsoft].[dw_active_queries];
GO

CREATE VIEW [microsoft].[dw_active_queries] AS
SELECT
	*
FROM
	sys.dm_pdw_exec_requests
WHERE
	status NOT IN ('Completed', 'Failed');
GO