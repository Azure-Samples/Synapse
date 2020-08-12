IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbc')) 
BEGIN
    EXEC ('CREATE SCHEMA [dbc]');
END