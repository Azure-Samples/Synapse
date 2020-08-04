DROP VIEW IF EXISTS microsoft.dw_table_information;
GO

CREATE VIEW microsoft.dw_table_information
AS
WITH index_types ([type], [name]) AS
(
	SELECT
		0
		, CAST('HEAP' AS VARCHAR(30))
	UNION
	SELECT
		1
		, 'CLUSTERED'
	UNION
	SELECT
		2
		, 'NONCLUSTERED'
	UNION
	SELECT
		3
		, 'XML'
	UNION
	SELECT
		4
		, 'SPATIAL'
	UNION
	SELECT
		5
		, 'CLUSTERED COLUMNSTORE INDEX'
	UNION
	SELECT
		6
		, 'NONCLUSTERED COLUMNSTORE INDEX'
	UNION
	SELECT
		7
		, 'NONCLUSTERED HASH INDEX'
)
SELECT
	[object_id]				= t.[object_id]
	, [schema_name]			= SCHEMA_NAME(t.[schema_id])
	, [name]				= t.[name]
	, [index_type]			= it.[name]
	, [row_count]			= SUM(ndp.[row_count])
FROM
	sys.tables t
	JOIN sys.indexes i ON t.[object_id] = i.[object_id]
	JOIN sys.pdw_table_mappings tm ON t.[object_id] = tm.[object_id]
	JOIN sys.pdw_nodes_tables nt ON tm.[physical_name] = nt.[name]
	JOIN sys.dm_pdw_nodes_db_partition_stats ndp ON nt.[object_id] = ndp.[object_id]
		AND nt.[pdw_node_id] = ndp.[pdw_node_id]
		AND nt.[distribution_id] = ndp.[distribution_id]
	LEFT OUTER JOIN index_types it ON it.[type] = i.[type]
GROUP BY
	t.[object_id]
	, SCHEMA_NAME(t.[schema_id])
	, t.[name]
	, it.[name];
GO