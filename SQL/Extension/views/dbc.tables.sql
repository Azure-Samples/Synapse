DROP VIEW IF EXISTS [dbc].[tables];
GO

CREATE VIEW [dbc].[tables] AS
SELECT
	[DatabaseName]					= SCHEMA_NAME(o.schema_id)
	, [TableName]					= o.[name]
	, [Version]						= 1
	, [TableKind]					= CASE o.type
										WHEN '' THEN 'A'		-- Aggregate Function
										WHEN '' THEN 'B'		-- Combined aggregate and ordered analytical function
										WHEN '' THEN 'C'		-- Table operator parser contract function
										WHEN '' THEN 'D'		-- JAR
										WHEN '' THEN 'E'		-- External stored procedure
										WHEN 'FN' THEN 'F'		-- Standard Function
										WHEN '' THEN 'G'		-- Trigger
										WHEN '' THEN 'H'		-- Instance or constructor method
										WHEN '' THEN 'I'		-- Join Index
										WHEN '' THEN 'J'		-- Journal
										WHEN '' THEN 'K'		-- Foreign server object.
																-- Note: K is supported on the Teradata-to-Hadoop connector only.
										WHEN '' THEN 'L'		-- User-defined table operator
										WHEN '' THEN 'M'		-- Macro
										WHEN '' THEN 'N'		-- Hash Index
										WHEN '' THEN 'O'		-- Table with no primary index and no paritioning
										WHEN 'P' THEN 'P'		-- Stored procedure
										WHEN '' THEN 'Q'		-- Queue table
										WHEN '' THEN 'R'		-- Table function
										WHEN '' THEN 'S'		-- Ordered analytical function
										WHEN 'U' THEN 'T'		-- Table with a primary index or primary AMP index, partitioning, or both. Or a partitioned table with NoPI
										WHEN '' THEN 'U'		-- User-defined type
										WHEN 'V' THEN 'V'		-- View
										WHEN '' THEN 'X'		-- Authorization
										WHEN '' THEN 'Y'		-- GLOP set
										WHEN '' THEN 'Z'		-- UIF
									ELSE
										o.type
									END
	, [ProtectionType]				= 'N'
	, [JournalFlag]					= 'N'
	, [CreatorName]					= COALESCE(p.name, p.name, 'dbo')
	, [RequestText]					= NULL --= OBJECT_DEFINITION(OBJECT_ID(N'Purchasing.vVendor'))
	, [CommentString]				= NULL
	, [ParentCount]					= 0
	, [ChildCount]					= 0
	, [NamedTblCheckCount]			= 0
	, [UnnamedTblCheckExist]		= 'N'
	, [PrimaryKeyIndexId]			= NULL
	, [RepStatus]					= NULL
	, [CreateTimeStamp]				= o.create_date
	, [LastAlterName]				= 'dbo'
	, [LastAlterTimestamp]			= o.modify_date
	, [RequestTxtOverflow]			= NULL
	, [AccessCount]					= NULL
	, [LastAccessTimeStamp]			= NULL
	, [UtilVersion]					= NULL
	, [QueueFlag]					= 'N'
	, [CommitOpt]					= 'N'
	, [TransLog]					= 'N'
	, [CheckOpt]					= 'Y'
	, [TemporalProperty]			= 'N' -- OR NULL
	, [ResolvedCurrentDate]			= NULL
	, [ResolvedCurrentTimestamp]	= NULL
	, [SystemDefinedJI]				= 'N' -- OR NULL
	, [VTQualifier]					= NULL
	, [TTQualifier]					= NULL
	, o.*
FROM
	sys.objects o
	LEFT JOIN sys.server_principals p ON p.principal_id = o.principal_id ;
GO