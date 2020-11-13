@ECHO off

cls
setlocal

set _secure_password=**********

ECHO.
ECHO Azure Synapse SQL Extension toolkit v0.9.0.0 deployment script

IF NOT "%~4"=="" IF "%~5"=="" GOTO Deploy
ECHO The deploy script requires the following parameters:
ECHO - server name
ECHO - database name
ECHO - username
ECHO - password
ECHO.
ECHO Examples:
ECHO "%~nx0" demo.database.windows.net demodb user secure_password
REM TIMEOUT -1 1>NUL
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

REM Schema
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\schemas\microsoft.sql

ECHO Deploying functions

REM Functions
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.acosh.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.asinh.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.btrim.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.dayoccurrence_of_month.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.getbit.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.initcap.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.instr.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.lpad.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.ltrim.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.months_between.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.next_day.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.rpad.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\functions\microsoft.rtrim.sql

ECHO Deploying views

REM Views
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\dbc.databases.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\dbc.tables.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_active_queries.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_active_queue.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_configuration.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_extension_version.sql
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_statistics_information.sql
rem sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\views\microsoft.dw_table_information.sql

ECHO.
ECHO Finished
ECHO.