------------------------------------------------------------------------------------------
--      Part 1 - Cleanup script
--      This part removes objects from sample database
------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS parquet.NYCTaxi
GO
DROP VIEW IF EXISTS json.Books
GO
DROP VIEW IF EXISTS csv.NYCTaxi
GO
IF (EXISTS(SELECT * FROM sys.external_tables WHERE name = 'Population')) BEGIN
    DROP EXTERNAL TABLE csv.Population
END
IF (EXISTS(SELECT * FROM sys.external_file_formats WHERE name = 'QuotedCsvWithHeaderFormat')) BEGIN
    DROP EXTERNAL FILE FORMAT QuotedCsvWithHeaderFormat
END
GO
IF (EXISTS(SELECT * FROM sys.external_file_formats WHERE name = 'QuotedCsvWithoutHeaderFormat')) BEGIN
    DROP EXTERNAL FILE FORMAT QuotedCsvWithoutHeaderFormat
END
GO
IF (EXISTS(SELECT * FROM sys.external_file_formats WHERE name = 'ParquetFormat')) BEGIN
    DROP EXTERNAL FILE FORMAT ParquetFormat
END
GO
DROP SCHEMA IF EXISTS parquet;
GO
DROP SCHEMA IF EXISTS csv;
GO
DROP SCHEMA IF EXISTS json;
GO

IF (EXISTS(SELECT * FROM sys.external_data_sources WHERE name = 'SqlOnDemandDemo')) BEGIN
    DROP EXTERNAL DATA SOURCE SqlOnDemandDemo
END

IF (EXISTS(SELECT * FROM sys.external_data_sources WHERE name = 'AzureOpenDataStorage')) BEGIN
    DROP EXTERNAL DATA SOURCE AzureOpenDataStorage
END

IF (EXISTS(SELECT * FROM sys.external_data_sources WHERE name = 'YellowTaxi')) BEGIN
    DROP EXTERNAL DATA SOURCE YellowTaxi
END

IF EXISTS
   (SELECT * FROM sys.credentials
   WHERE name = 'https://sqlondemandstorage.blob.core.windows.net')
   DROP CREDENTIAL [https://sqlondemandstorage.blob.core.windows.net]
GO

IF EXISTS
   (SELECT * FROM sys.database_scoped_credentials
   WHERE name = 'sqlondemand')
   DROP DATABASE SCOPED CREDENTIAL [sqlondemand]
GO

IF EXISTS
   (SELECT * FROM sys.database_scoped_credentials
   WHERE name = 'AadIdentity')
   DROP DATABASE SCOPED CREDENTIAL [AadIdentity]
GO

IF EXISTS
   (SELECT * FROM sys.database_scoped_credentials
   WHERE name = 'WorkspaceIdentity')
   DROP DATABASE SCOPED CREDENTIAL [WorkspaceIdentity]
GO


------------------------------------------------------------------------------------------
--      Part 2 - initialization script
--      This part creates required objects in sample database
------------------------------------------------------------------------------------------

-- create server-scoped credential for the containers in demo storage account
-- this credential will be used in OPENROWSET function without data source that uses absolute file URL
CREATE CREDENTIAL [https://sqlondemandstorage.blob.core.windows.net]
WITH IDENTITY='SHARED ACCESS SIGNATURE',  
SECRET = 'sv=2018-03-28&ss=bf&srt=sco&sp=rl&st=2019-10-14T12%3A10%3A25Z&se=2061-12-31T12%3A10%3A00Z&sig=KlSU2ullCscyTS0An0nozEpo4tO5JAgGBvw%2FJX2lguw%3D'
GO

-- create database-scoped credential for the containers in demo storage account
-- this credential will be used in OPENROWSET function with data source that uses relative file URL
CREATE DATABASE SCOPED CREDENTIAL [sqlondemand]
WITH IDENTITY='SHARED ACCESS SIGNATURE',  
SECRET = 'sv=2018-03-28&ss=bf&srt=sco&sp=rl&st=2019-10-14T12%3A10%3A25Z&se=2061-12-31T12%3A10%3A00Z&sig=KlSU2ullCscyTS0An0nozEpo4tO5JAgGBvw%2FJX2lguw%3D'
GO
-- Create credential that will allow AAD user to impersonate
CREATE DATABASE SCOPED CREDENTIAL AadIdentity WITH IDENTITY = 'User Identity'
GO
-- Create credential that will allow user to impersonate using Managed Identity assigned to workspace
CREATE DATABASE SCOPED CREDENTIAL WorkspaceIdentity WITH IDENTITY = 'Managed Identity'
GO


CREATE SCHEMA parquet;
GO
CREATE SCHEMA csv;
GO
CREATE SCHEMA json;
GO

-- Create external data source secured using credential
CREATE EXTERNAL DATA SOURCE SqlOnDemandDemo WITH (
    LOCATION = 'https://sqlondemandstorage.blob.core.windows.net',
    CREDENTIAL = sqlondemand
);
GO
-- Create publicly available external data sources
CREATE EXTERNAL DATA SOURCE AzureOpenDataStorage
WITH ( LOCATION = 'https://azureopendatastorage.blob.core.windows.net/')
GO
CREATE EXTERNAL DATA SOURCE YellowTaxi
WITH ( LOCATION = 'https://azureopendatastorage.blob.core.windows.net/nyctlc/yellow/')


CREATE EXTERNAL FILE FORMAT QuotedCsvWithHeaderFormat
WITH (  
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '"',
        FIRST_ROW = 2
    )
);
GO
CREATE EXTERNAL FILE FORMAT QuotedCsvWithoutHeaderFormat
WITH (  
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '"',
        FIRST_ROW = 1
    )
);
GO
CREATE EXTERNAL FILE FORMAT ParquetFormat
WITH (  
    FORMAT_TYPE = PARQUET
);
GO

CREATE EXTERNAL TABLE csv.population
(
    [country_code] VARCHAR (5) COLLATE Latin1_General_BIN2,
    [country_name] VARCHAR (100) COLLATE Latin1_General_BIN2,
    [year] smallint,
    [population] bigint
)
WITH (
    LOCATION = 'csv/population/population.csv',
    DATA_SOURCE = SqlOnDemandDemo,
    FILE_FORMAT = QuotedCsvWithHeaderFormat
);
GO

CREATE VIEW parquet.NYCTaxi
AS SELECT *, nyc.filepath(1) AS [year], nyc.filepath(2) AS [month]
FROM
    OPENROWSET(
        BULK 'https://sqlondemandstorage.blob.core.windows.net/parquet/taxi/year=*/month=*/*.parquet',
        FORMAT='PARQUET'
    ) AS nyc
GO

CREATE VIEW csv.NYCTaxi
AS
SELECT  *, nyc.filepath(1) AS [year], nyc.filepath(2) AS [month]
FROM OPENROWSET(
    BULK 'https://sqlondemandstorage.blob.core.windows.net/csv/taxi/yellow_tripdata_*-*.csv',
        FORMAT = 'CSV', 
        FIRSTROW = 2
    )
    WITH (
          vendor_id VARCHAR(100) COLLATE Latin1_General_BIN2, 
          pickup_datetime DATETIME2, 
          dropoff_datetime DATETIME2,
          passenger_count INT,
          trip_distance FLOAT,
          rate_code INT,
          store_and_fwd_flag VARCHAR(100) COLLATE Latin1_General_BIN2,
          pickup_location_id INT,
          dropoff_location_id INT,
          payment_type INT,
          fare_amount FLOAT,
          extra FLOAT,
          mta_tax FLOAT,
          tip_amount FLOAT,
          tolls_amount FLOAT,
          improvement_surcharge FLOAT,
          total_amount FLOAT
    ) AS nyc
GO

CREATE VIEW json.Books
AS SELECT *
FROM
    OPENROWSET(
        BULK 'https://sqlondemandstorage.blob.core.windows.net/json/books/*.json',
        FORMAT='CSV',
        FIELDTERMINATOR ='0x0b',
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0b'
    )
    WITH (
        content varchar(8000)
    ) AS books;