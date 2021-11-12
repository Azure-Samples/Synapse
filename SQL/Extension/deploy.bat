@ECHO off

cls
setlocal

set _secure_password=**********

ECHO.
ECHO Azure Synapse SQL Extension toolkit v0.11.0.0 deployment script

IF NOT "%~4"=="" IF "%~5"=="" GOTO Deploy
ECHO The deploy script requires the following parameters:
ECHO - server name
ECHO - database name
ECHO - username
ECHO - password
ECHO.
ECHO Examples:
ECHO "%~nx0" demo.database.windows.net demodb user secure_password
exit /b

:Deploy
SET _server=%~1
SET _database=%~2
SET _username=%~3
SET _password=%~4

ECHO.
ECHO *****************************************************************************
ECHO OPTIONS
ECHO.
ECHO Server:      %_server%
ECHO Database:    %_database%
ECHO Username:    %_username%
ECHO Password:    %_secure_password%
ECHO *****************************************************************************
ECHO.


ECHO Deploying schemas

REM Schemas
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\schemas\dbc.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\schemas\microsoft.sql

ECHO Deploying tables

REM Tables
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\tables\microsoft.calendar.sql

ECHO Deploying functions

REM Functions
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.acosh.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.asinh.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.corr.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.date_trunc.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.dayoccurrence_of_month.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.days_between.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.firstdayofmonth.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.firstdayofquarter.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.firstdayofyear.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.getbit.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.initcap.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.instr.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.lpad.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.ltrim.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.months_between.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.next_day.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.random.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.rpad.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.rtrim.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.to_char.sql

REM Note: Dependent on microsoft.LTRIM and microsoft.RTRIM functions.
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.btrim.sql

ECHO Deploying views

REM Views
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\dbc.databases.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\dbc.tables.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_active_queries.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_active_queue.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_calendar.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_configuration.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_extension_version.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_statistics_information.sql
rem sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_table_information.sql


ECHO Deploying procedures

REM Procedures
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\procedures\microsoft.proc_fill_calendar.sql

ECHO Executing procedures

REM Executing code
REM sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -Q "SET NOCOUNT ON; exec microsoft.proc_fill_calendar @startdate = '01/01/1900', @enddate = '12/31/2099';"

ECHO Loading database
bcp microsoft.calendar in .\data\microsoft.calendar.txt -c -S %_server% -d %_database% -U %_username% -P %_password% -q

ECHO Optimizing tables
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\scripts\microsoft.calendar.sql

ECHO.
ECHO Finished
ECHO.