@ECHO off

cls
setlocal

set _secure_password=**********

ECHO.
ECHO Azure Synapse New York Taxi database deployment script

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


ECHO Deploying tables

REM tables
ECHO dbo.date
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\tables\dbo.date.sql

ECHO dbo.geography
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\tables\dbo.geography.sql

ECHO dbo.hackneylicense
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\tables\dbo.hackneylicense.sql

ECHO dbo.medallion
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\tables\dbo.medallion.sql

ECHO dbo.time
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\tables\dbo.time.sql

ECHO dbo.trip
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\tables\dbo.trip.sql

ECHO dbo.weather
sqlcmd -S %_server% -d %_database% -U %_username% -P %_password% -I -i .\tables\dbo.weather.sql

ECHO.
ECHO Finished
ECHO.