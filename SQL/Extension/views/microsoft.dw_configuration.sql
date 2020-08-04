DROP VIEW IF EXISTS microsoft.dw_configuration;
GO

CREATE VIEW microsoft.dw_configuration AS
WITH dw_nodes AS
(
	SELECT
		[node_type] = type,
		[node_count] = COUNT(*)
	FROM
		sys.dm_pdw_nodes
	GROUP BY
		type
), 
dw_config AS
(
	SELECT
		[database_name] = name
		, [compat_level] = compatibility_level
		, [collation_name] = collation_name
		, is_auto_create_stats_on
		, is_auto_update_stats_on
		, is_result_set_caching_on
	FROM
		sys.databases
	WHERE
		name = DB_NAME()
)
SELECT
	  [database_name]
	, [nodes] = node_count
	, [collation_name]
	, [compat_level]
	, is_auto_create_stats_on
	, is_auto_update_stats_on
	, is_result_set_caching_on
FROM
	dw_nodes,
	dw_config
WHERE
	node_type = 'COMPUTE';
GO