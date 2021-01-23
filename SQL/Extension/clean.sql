-- Functions
PRINT 'Removing functions';
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'acosh') DROP FUNCTION [microsoft].[acosh];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'asinh') DROP FUNCTION [microsoft].[asinh];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'btrim') DROP FUNCTION [microsoft].[btrim];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'corr') DROP FUNCTION [microsoft].[corr];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'date_trunc') DROP FUNCTION [microsoft].[date_trunc];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'dayoccurrence_of_month') DROP FUNCTION [microsoft].[dayoccurrence_of_month];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'firstdayofmonth') DROP FUNCTION [microsoft].[firstdayofmonth];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'firstdayofquarter') DROP FUNCTION [microsoft].[firstdayofquarter];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'firstdayofyear') DROP FUNCTION [microsoft].[firstdayofyear];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'getbit') DROP FUNCTION [microsoft].[getbit];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'initcap') DROP FUNCTION [microsoft].[initcap];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'instr') DROP FUNCTION [microsoft].[instr];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'lpad') DROP FUNCTION [microsoft].[lpad];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'ltrim') DROP FUNCTION [microsoft].[ltrim];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'months_between') DROP FUNCTION [microsoft].[months_between];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'next_day') DROP FUNCTION [microsoft].[next_day];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'random') DROP FUNCTION [microsoft].[random];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'rpad') DROP FUNCTION [microsoft].[rpad];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'rtrim') DROP FUNCTION [microsoft].[rtrim];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'to_char') DROP FUNCTION [microsoft].[to_char];

-- Views
PRINT 'Removing views';
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'dw_active_queries') DROP VIEW [microsoft].[dw_active_queries];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'dw_active_queue') DROP VIEW [microsoft].[dw_active_queue];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'dw_configuration') DROP VIEW [microsoft].[dw_configuration];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'dw_extension_version') DROP VIEW [microsoft].[dw_extension_version];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('microsoft') AND name = N'dw_statistics_information') DROP VIEW [microsoft].[dw_statistics_information];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('dbc') AND name = N'databases') DROP VIEW [dbc].[databases];
IF EXISTS (SELECT * FROM sys.objects WHERE schema_id=SCHEMA_ID('dbc') AND name = N'tables') DROP VIEW [dbc].[tables];

-- Schemas
PRINT 'Removing schemas';
IF EXISTS(SELECT * FROM sys.schemas WHERE name = N'dbc') DROP SCHEMA [dbc];
IF EXISTS(SELECT * FROM sys.schemas WHERE name = N'microsoft') DROP SCHEMA [microsoft];
GO