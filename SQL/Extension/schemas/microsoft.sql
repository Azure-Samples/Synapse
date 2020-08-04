IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'microsoft')) 
BEGIN
    EXEC ('CREATE SCHEMA [microsoft]');
END