@ECHO off

cls
setlocal

set _secure_password=**********

ECHO.
ECHO Azure Synapse SQL Extension toolkit v0.11.0.0 clean script

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


ECHO Removing objects

sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\clean.sql

ECHO.
ECHO Finished
ECHO.