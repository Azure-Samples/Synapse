DROP VIEW IF EXISTS [microsoft].[dw_active_queue];
GO

CREATE VIEW [microsoft].[dw_active_queue] AS
SELECT
    *
    , [queued_sec] = DATEDIFF(MILLISECOND, request_time, GETDATE()) / 1000.0
FROM
    sys.dm_pdw_resource_waits
WHERE
    [state] = 'Queued';
GO