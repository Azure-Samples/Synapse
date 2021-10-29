/*
with views as (
select format_type = CASE
				WHEN (UPPER(m.definition) LIKE '%''PARQUET''%' AND UPPER(m.definition) LIKE '%''CSV''%' ) THEN 'PARQUET&TEXT'
				WHEN (UPPER(m.definition) LIKE '%''PARQUET''%' AND UPPER(m.definition) LIKE '%''DELTA''%' ) THEN 'PARQUET&DELTA'
				WHEN (UPPER(m.definition) LIKE '%''PARQUET''%' AND UPPER(m.definition) LIKE '%''COSMOSDB''%' ) THEN 'PARQUET&COSMOSDB'
				WHEN (UPPER(m.definition) LIKE '%''CSV''%' AND UPPER(m.definition) LIKE '%''DELTA''%' ) THEN 'TEXT&DELTA'
				WHEN (UPPER(m.definition) LIKE '%''CSV''%' AND UPPER(m.definition) LIKE '%''COSMOSDB''%' ) THEN 'TEXT&COSMOSDB'
				WHEN (UPPER(m.definition) LIKE '%''DELTA''%' AND UPPER(m.definition) LIKE '%''COSMOSDB''%' ) THEN 'DELTA&COSMOSDB'
				WHEN UPPER(m.definition) LIKE '%''PARQUET''%' THEN 'PARQUET'
				WHEN UPPER(m.definition) LIKE '%''DELTA''%' THEN 'DELTA'
				WHEN UPPER(m.definition) LIKE '%''CSV''%' THEN 'TEXT'
				WHEN UPPER(m.definition) LIKE '%''COSMOSDB''%' THEN 'COSMOSDB'
				WHEN 		UPPER(m.definition) NOT LIKE '%''PARQUET''%'
						AND (UPPER(m.definition) NOT LIKE '%''CSV''%' )
						AND (UPPER(m.definition) NOT LIKE '%''DELTA''%' )
						AND (UPPER(m.definition) NOT LIKE '%''COSMOSDB''%' )
						THEN 'COMPOSITE'
				ELSE 'MIXED'
			END, 
		[Number of views] = count(*)
from sys.views v
join sys.sql_modules m on v.object_id = m.object_id
GROUP BY CASE
				WHEN (UPPER(m.definition) LIKE '%''PARQUET''%' AND UPPER(m.definition) LIKE '%''CSV''%' ) THEN 'PARQUET&TEXT'
				WHEN (UPPER(m.definition) LIKE '%''PARQUET''%' AND UPPER(m.definition) LIKE '%''DELTA''%' ) THEN 'PARQUET&DELTA'
				WHEN (UPPER(m.definition) LIKE '%''PARQUET''%' AND UPPER(m.definition) LIKE '%''COSMOSDB''%' ) THEN 'PARQUET&COSMOSDB'
				WHEN (UPPER(m.definition) LIKE '%''CSV''%' AND UPPER(m.definition) LIKE '%''DELTA''%' ) THEN 'TEXT&DELTA'
				WHEN (UPPER(m.definition) LIKE '%''CSV''%' AND UPPER(m.definition) LIKE '%''COSMOSDB''%' ) THEN 'TEXT&COSMOSDB'
				WHEN (UPPER(m.definition) LIKE '%''DELTA''%' AND UPPER(m.definition) LIKE '%''COSMOSDB''%' ) THEN 'DELTA&COSMOSDB'
				WHEN UPPER(m.definition) LIKE '%''PARQUET''%' THEN 'PARQUET'
				WHEN UPPER(m.definition) LIKE '%''DELTA''%' THEN 'DELTA'
				WHEN UPPER(m.definition) LIKE '%''CSV''%' THEN 'TEXT'
				WHEN UPPER(m.definition) LIKE '%''COSMOSDB''%' THEN 'COSMOSDB'
				WHEN 		UPPER(m.definition) NOT LIKE '%''PARQUET''%'
						AND (UPPER(m.definition) NOT LIKE '%''CSV''%' )
						AND (UPPER(m.definition) NOT LIKE '%''DELTA''%' )
						AND (UPPER(m.definition) NOT LIKE '%''COSMOSDB''%' )
						THEN 'COMPOSITE'
				ELSE 'MIXED'
			END
),
external_tables as (
select format_type = iif(f.format_type = 'DELIMITEDTEXT', 'TEXT', f.format_type), [Number of external tables] = count(*)
from sys.external_tables as e
join sys.external_file_formats f on e.file_format_id = f.file_format_id
group by f.format_type, f.encoding
)
select format_type = ISNULL(v.format_type, e.format_type), [Number of external tables], [Number of views]
from views v full outer join external_tables e on v.format_type = e.format_type
*/
/*
declare @type varchar(100) = 'PARQUET&DELTA'

select schema_name(v.schema_id), v.name, m.definition
from sys.views v
join sys.sql_modules m on v.object_id = m.object_id
where CASE
				WHEN (UPPER(m.definition) LIKE '%''PARQUET''%' AND UPPER(m.definition) LIKE '%''CSV''%' ) THEN 'PARQUET&CSV'
				WHEN (UPPER(m.definition) LIKE '%''PARQUET''%' AND UPPER(m.definition) LIKE '%''DELTA''%' ) THEN 'PARQUET&DELTA'
				WHEN (UPPER(m.definition) LIKE '%''PARQUET''%' AND UPPER(m.definition) LIKE '%''COSMOSDB''%' ) THEN 'PARQUET&COSMOSDB'
				WHEN (UPPER(m.definition) LIKE '%''CSV''%' AND UPPER(m.definition) LIKE '%''DELTA''%' ) THEN 'CSV&DELTA'
				WHEN (UPPER(m.definition) LIKE '%''CSV''%' AND UPPER(m.definition) LIKE '%''COSMOSDB''%' ) THEN 'CSV&COSMOSDB'
				WHEN (UPPER(m.definition) LIKE '%''DELTA''%' AND UPPER(m.definition) LIKE '%''COSMOSDB''%' ) THEN 'DELTA&COSMOSDB'
				WHEN UPPER(m.definition) LIKE '%''PARQUET''%' THEN 'PARQUET'
				WHEN UPPER(m.definition) LIKE '%''DELTA''%' THEN 'DELTA'
				WHEN UPPER(m.definition) LIKE '%''CSV''%' THEN 'CSV'
				WHEN UPPER(m.definition) LIKE '%''COSMOSDB''%' THEN 'COSMOSDB'
				WHEN 		UPPER(m.definition) NOT LIKE '%''PARQUET''%'
						AND (UPPER(m.definition) NOT LIKE '%''CSV''%' )
						AND (UPPER(m.definition) NOT LIKE '%''DELTA''%' )
						AND (UPPER(m.definition) NOT LIKE '%''COSMOSDB''%' )
						THEN 'COMPOSITE'
				ELSE 'MIXED'
			END = @type

*/


-- Views created on Delta Lake, Cosmos DB, Parquet and CSV/UTF-8 files with NVARCHAR/NCHAR columns or CHAR/VARCHAR without UTF8 collation:
;
with sql_definition as (
		select 
		object_id,
		format_type = CASE
				WHEN UPPER(m.definition) LIKE '%''PARQUET''%' THEN 'PARQUET'
				WHEN UPPER(m.definition) LIKE '%''DELTA''%' THEN 'DELTA'
				WHEN UPPER(m.definition) LIKE '%''CSV''%' THEN 'CSV'
				WHEN UPPER(m.definition) LIKE '%''COSMOSDB''%' THEN 'COSMOSDB'
				WHEN 		UPPER(m.definition) NOT LIKE '%''PARQUET''%'
						AND (UPPER(m.definition) NOT LIKE '%''CSV''%' )
						AND (UPPER(m.definition) NOT LIKE '%''DELTA''%' )
						AND (UPPER(m.definition) NOT LIKE '%''COSMOSDB''%' )
						THEN 'COMPOSITE'
				ELSE 'MIXED'
			END
		from sys.sql_modules m
),
bulkpath as (
select schema_name = schema_name(v.schema_id), v.name, val =TRIM(SUBSTRING( LOWER(m.definition) , PATINDEX('%bulk%', LOWER(m.definition)), 2048)), m.definition
from sys.views v
join sys.sql_modules m on v.object_id = m.object_id
where PATINDEX('%bulk%', LOWER(m.definition)) > 0
),
view_path as (
select  name,
		schema_name,
		path = SUBSTRING(val, 
						CHARINDEX('''', val, 0)+1,
						(CHARINDEX('''', val, CHARINDEX('''', val, 0)+1) - CHARINDEX('''', val, 0) - 1)) 
from bulkpath
where CHARINDEX('''', val, 0) > 0
),
recommendations as (

select	impact = 1.0,
		type = 'WRONG TYPE', 
		schema_name = schema_name(v.schema_id),
		object = v.name,
		column_name = c.name,
		message =	CONCAT('The view ', v.name, ' that is created on ', m.format_type,' dataset has ', count(c.column_id), ' columns with ') +
					IIF( t.name = 'nchar', 'NVARCHAR/NCHAR type.', 'VARCHAR/CHAR type without UTF-8 collation.') +
					' You might get conversion error.' +
					' Change the column types to VARCHAR with some UTF8 collation.'
from sys.views as v join sys.columns as c on v.object_id = c.object_id
join sql_definition m on v.object_id = m.object_id
join sys.types t on c.user_type_id = t.user_type_id
where (	m.format_type IN ('PARQUET', 'DELTA', 'COSMOSDB', 'MIXED') )
AND	( (t.name iN ('nchar', 'nvarhar')) OR (t.name iN ('nchar', 'nvarhar') AND c.collation_name NOT LIKE '%UTF8') )
group by v.schema_id, v.name, t.name, m.format_type, c.name
union all
-- Tables on UTF-8 files with NVARCHAR/NCHAR columns or CHAR/VARCHAR without UTF8 collation:
select	impact = IIF( t.name LIKE 'n%', 0.3, 1.0),
		type = 'WRONG TYPE',
		schema_name = schema_name(e.schema_id),
		object = e.name,
		column_name = IIF(count(c.column_id)=1, max(c.name), CONCAT(count(c.column_id), ' columns')),
		message =	CONCAT('The table "', schema_name(e.schema_id), '.', e.name, '" that is created on ', f.format_type, ' files ') +
					CONCAT(IIF( f.encoding = 'UTF8', ' with UTF-8 encoding ', ''), ' has ',
					IIF(count(c.column_id)=1, '"' + max(c.name) + '" column', CONCAT(count(c.column_id), ' columns') ), ' with ') +
					IIF( t.name LIKE 'n%', 'NVARCHAR/NCHAR', 'VARCHAR/CHAR without UTF-8 collation.') +
					' type. Change the column types to VARCHAR with some UTF8 collation.'
from sys.external_tables as e join sys.columns as c on e.object_id = c.object_id
join sys.external_file_formats f on e.file_format_id = f.file_format_id
join sys.types t on c.user_type_id = t.user_type_id
where ( (f.format_type IN ('PARQUET', 'DELTA')) OR f.encoding = 'UTF8' )
AND	( (t.name iN ('nchar', 'nvarhar')) OR (t.name iN ('nchar', 'nvarhar') AND c.collation_name NOT LIKE '%UTF8'))
group by e.schema_id, f.format_type, e.name, f.encoding , t.name, c.name
union all
-- Tables on UTF-16 files with VARCHAR/CHAR columns:
select	impact = 1.0,
		type = 'WRONG TYPE',
		schema_name = schema_name(e.schema_id),
		object = e.name,
		column_name = IIF(count(c.column_id)=1, max(c.name), CONCAT(count(c.column_id), ' columns')),
		message =	CONCAT('The table "',  schema_name(e.schema_id), '.', e.name, '" created on CSV files with UTF16 encoding has ', 
						IIF(count(c.column_id)=1, '"' + max(c.name) + '" column', CONCAT(count(c.column_id), ' columns') ), ' with ') +
					'VARCHAR/CHAR type. Change the column type to NVARCHAR.'
from sys.external_tables as e join sys.columns as c on e.object_id = c.object_id
join sys.external_file_formats f on e.file_format_id = f.file_format_id
join sys.types t on c.user_type_id = t.user_type_id
where (f.encoding = 'UTF16' )
AND	(t.name iN ('nchar', 'nvarhar'))
group by e.schema_id, f.format_type, e.name, f.encoding , t.name
union all
-- Views created on Delta Lake, CosmosDB, or Parquet datasets with the columns without BIN2 UTF-8 collation:
/*;
with sql_definition as (
		select 
		object_id,
		format_type = CASE
				WHEN UPPER(m.definition) LIKE '%''PARQUET''%' THEN 'PARQUET'
				WHEN UPPER(m.definition) LIKE '%''DELTA''%' THEN 'DELTA'
				WHEN UPPER(m.definition) LIKE '%''CSV''%' THEN 'CSV'
				WHEN UPPER(m.definition) LIKE '%''COSMOSDB''%' THEN 'COSMOSDB'
				WHEN 		UPPER(m.definition) NOT LIKE '%''PARQUET''%'
						AND (UPPER(m.definition) NOT LIKE '%''CSV''%' )
						AND (UPPER(m.definition) NOT LIKE '%''DELTA''%' )
						AND (UPPER(m.definition) NOT LIKE '%''COSMOSDB''%' )
						THEN 'COMPOSITE'
				ELSE 'MIXED'
			END
		from sys.sql_modules m
)
*/
select	impact = case
					when string_agg(c.name,',') like '%id%' then 0.9
					when string_agg(c.name,',') like '%code%' then 0.9
					when count(c.column_id) > 1 then 0.81
					else 0.71
					end,
		type = 'SLOW STRING FILTERS',
		schema_name = schema_name(v.schema_id),
		object = v.name,
		column_name = IIF(count(c.column_id)=1, max(c.name), CONCAT(count(c.column_id), ' columns')),
		message =	CONCAT('The view "',  schema_name(v.schema_id), '.', v.name, '" that is created on ', m.format_type, ' dataset has ',
							IIF(count(c.column_id)=1, '"' + max(c.name) + '" column', CONCAT(count(c.column_id), ' columns') ), ' with ') +
					IIF( t.name = 'nchar', 'NVARCHAR/NCHAR type.', 'VARCHAR/CHAR type without BIN2 UTF8 collation.') +
					' Change the column types to VARCHAR with the Latin1_General_100_BIN2_UTF8 collation.'
from sys.views as v join sys.columns as c on v.object_id = c.object_id
join sql_definition m on v.object_id = m.object_id
join sys.types t on c.user_type_id = t.user_type_id
where (	m.format_type IN ('PARQUET', 'DELTA', 'COSMOSDB', 'MIXED') )
AND	( t.name IN ('char', 'varchar') AND c.collation_name <> 'Latin1_General_100_BIN2_UTF8' )
group by v.schema_id, v.name, t.name, m.format_type

union all

-- Tables on Parquet/Delta Lake files with the columns without BIN2 UTF-8 collation:
select	impact = 0.6,
		type = 'SLOW STRING FILTERS',
		schema_name = schema_name(e.schema_id),
		object = e.name,
		column_name = c.name,
		message = CONCAT('The string column "', c.name, '" in table "', schema_name(t.schema_id), '.', t.name, '" doesn''t have "Latin1_General_100_BIN2_UTF8". String filter on this column are suboptimal')
from sys.external_tables as e join sys.columns as c on e.object_id = c.object_id
join sys.external_file_formats f on e.file_format_id = f.file_format_id
join sys.types t on c.user_type_id = t.user_type_id
where ( (f.format_type IN ('PARQUET', 'DELTA'))) AND t.name IN ('char', 'varchar') AND c.collation_name <> 'Latin1_General_100_BIN2_UTF8'

union all
-- Oversized string columns:
select	impact = ROUND(0.3 + (IIF(c.max_length=-1, 0.7*12000., c.max_length)/12000.),1),
		type = 'BIG COLUMN',
		schema_name = schema_name(o.schema_id),
		object = o.name,
		column_name = c.name,
		message = CONCAT('The string column "', c.name, '" has a max size ', 
				IIF(c.max_length=-1, ' 2 GB', CAST( c.max_length AS VARCHAR(10)) + ' bytes'), '. Check could you use a column with a smaller size.',
				IIF(o.type = 'U', ' Table ', ' View '), '"', schema_name(o.schema_id), '.', o.name, '"')
from sys.objects as o join sys.columns as c on o.object_id = c.object_id
join sys.types t on c.user_type_id = t.user_type_id
where t.name LIKE '%char' AND (c.max_length > 256 OR c.max_length = -1)
and o.type in ('U', 'V')
and lower(c.name) not like '%desc%'
and lower(c.name) not like '%comment%'
and lower(c.name) not like '%note%'
and lower(c.name) not like '%exception%'
and lower(c.name) not like '%reason%'
and lower(c.name) not like '%explanation%'
union all

-- Oversized key columns:
select	impact = 0.4 + ROUND((1-EXP(-IIF(c.max_length=-1, 1000., c.max_length)/1000.)),1),
		type = 'BIG KEY',
		schema_name = schema_name(o.schema_id),
		object = o.name,
		column_name = c.name,
		message = CONCAT('Are you using the column "', c.name, '" in join/filter predicates? ',
							'The column type is ', t.name, '(size:',IIF(c.max_length=-1, ' 2 GB', CAST( c.max_length AS VARCHAR(10)) + ' bytes'),'). ',
							'Try to use a column with a smaller type or size.')
from sys.objects as o join sys.columns as c on o.object_id = c.object_id
join sys.types t on c.user_type_id = t.user_type_id
where (c.name LIKE '%code' OR  c.name LIKE '%id') AND (c.max_length > 8 OR c.max_length = -1)
and o.type in ('U', 'V')

union all

-- The tables that are referencing the same location:
select	impact = 0.9,
		type = 'DUPLICATE REFERENCES',
		schema_name = NULL,
		object = NULL,
		column_name = NULL,
		message = CONCAT('The tables ', string_agg(concat('"',schema_name(e.schema_id),'.',e.name,'"'), ','), ' are referencing the same location')
from sys.external_tables e
group by data_source_id, location
having count(*) > 1

union all

-- Partitioned external table
select	impact = 1.0,
		type = 'PARTITIONED TABLES',
		schema_name = schema_name(e.schema_id),
		object = e.name,
		column_name = NULL,
		message = CONCAT('The table ', e.name, ' is created on a partitioned data set, but cannot leverage partition elimination. Replace it with a partitioned view.')
from sys.external_tables e
where location like '%*%'

union all

select	impact = IIF(c.max_length=-1, 1.0, 0.2 + ROUND((1-EXP(-c.max_length/50.))/2,1)),
		type = 'BAD TYPE',
		schema_name = schema_name(o.schema_id),
		object = o.name,
		column_name = c.name,
		message =	CONCAT('Do you need to use the type "', t.name, '(size:',IIF(c.max_length=-1, ' 2 GB', CAST( c.max_length AS VARCHAR(10)) + ' bytes'),') in column "', c.name, '" in view: "', schema_name(o.schema_id), '.', o.name, '"')
from sys.objects as o join sys.columns as c on o.object_id = c.object_id
join sys.types t on c.user_type_id = t.user_type_id
where
	t.name IN ('nchar', 'nvarchar', 'char', 'varchar', 'binary', 'varbinary')
AND
	(	LOWER(c.name) like '%date%' OR LOWER(c.name) like '%time%' 
	OR	LOWER(c.name) like '%guid%'
	OR	LOWER(c.name) like '%price%' OR LOWER(c.name) like '%amount%' )
AND
	o.type in ('U', 'V')
and lower(c.name) not like '%desc%'
and lower(c.name) not like '%comment%'
and lower(c.name) not like '%note%'
and lower(c.name) not like '%exception%'
and lower(c.name) not like '%reason%'
and lower(c.name) not like '%explanation%'

union all

select	impact = 0.9,
		type = 'DUPLICATE REFERENCES',
		schema_name = NULL,
		object = NULL,
		column_name = NULL,
		message = CONCAT('Views ', string_agg(concat(schema_name,'.',name), ','), ' are referencing the same path: ', path)
from view_path
group by path
having count(*) > 1
)
--/*
select * from recommendations
order by impact desc
--*/
/*
select type = isnull(type,'TOTAL'), issues = count(*)
from recommendations
group by type
with rollup
*/
/*
select type = isnull(type,'total'), impact, issues = count(*)
from recommendations
group by type, impact
*/
