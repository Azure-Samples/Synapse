# Views

## dbc.tables
The `dbc.tables` script installs a view that mimics the `DBC.TABLES` view found in Teradata. 
Note: See the [`DBC.TABLES`](https://docs.teradata.com/reader/b7YPw3QMO~fsDCrY39kyiQ/NWKolQulMcPxjjpRzelZxA)

## microsoft.dw_active_queries
The `microsoft.dw_active_queries` script installs a view that shows the active queries from the `sys.dm_pdw_exec_requests` view.

Note: See the [`sys.dm_pdw_exec_requests`](https://docs.microsoft.com/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql) DMV for column details.

## microsoft.dw_active_queue
The `microsoft.dw_active_queue` script installs a view that shows the queued statements from the `sys.dm_pdw_resource_waits` view.

Note: See the [`sys.dm_pdw_resource_waits`](https://docs.microsoft.com/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-resource-waits-transact-sql) DMV for column details.

## microsoft.dw_configuration
The `microsoft.dw_configuration` script installs a view that shows the configuration for the Azure Synapse SQL database.

| Column name | Data type | Description |
| -           | -         | -           |
| **database_name** | **sysname(varchar(128))** | The name of the database. |
| **nodes** | **int** | The number of compute nodes of the database. |
| **collation_name** | **sysname(varchar(128))** | The collation for the database.|
| **compat_level** | **tinyint** | The compatibility level of the database. |
| **is_auto_create_stats_on** | **bit** | A flag that indicates if AUTO CREATE STATISTICS is enabled. |
| **is_auto_update_stats_on** | **bit** | A flag that indicates if AUTO UPDATE STATISTICS is enabled. |
| **is_result_set_caching_on** | **bit** | A flag that indicates if RESULTSET CACHING is enabled.|

## microsoft.dw_extension_version
The `microsoft.dw_extension_version` script installs a view that contains a single row indicating the installed extension version.

| Column name | Data type | Description |
| -           | -         | -           |
| **version** | **varchar(20)** | The installed version of the Azure Synapse SQL Extension toolkit. |

## microsoft.dw_table_information
The *microsoft.dw_table_information.sql* script installs a view that contains a row per index or heap of a table.

| Column name | Data type | Description |
| -           | -         | -           |
| **object_id** | **int** | ID of the table |
| **schema_name** | **sysname** | The schema name of the table |
| **name** | **sysname** | The name of the table |
| **index_type** | **varchar(30)** | The type of index |
| **row_count** | **bigint** | The total number of rows in the table |

