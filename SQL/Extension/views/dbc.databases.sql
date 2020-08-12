DROP VIEW IF EXISTS [dbc].[databases];
GO

CREATE VIEW [dbc].[databases] AS
SELECT
	[DatabaseName]						= d.name
	, [CreatorName]						= 'dbo'
	, [OwnerName]						= 'dbo'
	, [AccountName]						= 'dbo'
	, [ProtectionType]					= 'N'
	, [JournalFlag]						= 'NN'
	, [PermSpace]						= 0
	, [SpoolSpace]						= 0
	, [TempSpace]						= 0
	, [CommentString]					= NULL
	, [CreateTimeStamp]					= d.create_date
	, [LastAlterName]					= 'dbo'
	, [LastAlterTimeStamp]				= d.create_date
	, [DBKind]							= 'U' -- or 'D'
	, [AccessCount]						= NULL
	, [LastAccessTimeStamp]				= NULL
FROM
	sys.databases d
GO