if db_name() = 'master'
    throw 50001, 'This script cannot be executed in master database. Create new database and run the script there.', 1;

if SERVERPROPERTY('EngineEdition') <> 11
    throw 50001, 'This script must be executed on Azure Synapse - Serverless SQL endpoint.', 1;

------------------------------------------------------------------------------------------
--      Part 1 - Cleanup script
--      This part removes objects from sample database
------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS parquet.YellowTaxi
GO
DROP VIEW IF EXISTS json.Books
GO
DROP VIEW IF EXISTS csv.YellowTaxi
GO
IF (EXISTS(SELECT * FROM sys.external_tables WHERE name = 'Population')) BEGIN
    DROP EXTERNAL TABLE csv.Population
END
IF (EXISTS(SELECT * FROM sys.external_tables WHERE name = 'Covid')) BEGIN
    DROP EXTERNAL TABLE delta.Covid
END
IF (EXISTS(SELECT * FROM sys.external_file_formats WHERE name = 'QuotedCsvWithHeader')) BEGIN
    DROP EXTERNAL FILE FORMAT QuotedCsvWithHeader
END
GO
IF (EXISTS(SELECT * FROM sys.external_file_formats WHERE name = 'QuotedCsvWithoutHeader')) BEGIN
    DROP EXTERNAL FILE FORMAT QuotedCsvWithoutHeader
END
GO
IF (EXISTS(SELECT * FROM sys.external_file_formats WHERE name = 'NativeParquet')) BEGIN
    DROP EXTERNAL FILE FORMAT NativeParquet
END
GO
IF (EXISTS(SELECT * FROM sys.external_file_formats WHERE name = 'DeltaLakeFormat')) BEGIN
    DROP EXTERNAL FILE FORMAT DeltaLakeFormat
END
GO
DROP SCHEMA IF EXISTS parquet;
GO
DROP SCHEMA IF EXISTS csv;
GO
DROP SCHEMA IF EXISTS json;
GO
DROP SCHEMA IF EXISTS cosmosdb;
GO
DROP SCHEMA IF EXISTS delta;
GO
IF (EXISTS(SELECT * FROM sys.external_data_sources WHERE name = 'SqlOnDemandDemo')) BEGIN
    DROP EXTERNAL DATA SOURCE SqlOnDemandDemo
END

IF (EXISTS(SELECT * FROM sys.external_data_sources WHERE name = 'DeltaLakeStorage')) BEGIN
    DROP EXTERNAL DATA SOURCE DeltaLakeStorage
END

IF (EXISTS(SELECT * FROM sys.external_data_sources WHERE name = 'AzureOpenData')) BEGIN
    DROP EXTERNAL DATA SOURCE AzureOpenData
END

IF (EXISTS(SELECT * FROM sys.external_data_sources WHERE name = 'YellowTaxi')) BEGIN
    DROP EXTERNAL DATA SOURCE YellowTaxi
END

IF (EXISTS(SELECT * FROM sys.external_data_sources WHERE name = 'GreenTaxi')) BEGIN
    DROP EXTERNAL DATA SOURCE GreenTaxi
END

IF NOT EXISTS (SELECT * FROM sys.symmetric_keys) BEGIN
    declare @pasword nvarchar(400) = CAST(newid() as VARCHAR(400));
    EXEC('CREATE MASTER KEY ENCRYPTION BY PASSWORD = ''' + @pasword + '''')
END

IF EXISTS
   (SELECT * FROM sys.database_scoped_credentials
   WHERE name = 'sqlondemand')
   DROP DATABASE SCOPED CREDENTIAL [sqlondemand]
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

-- Create credential that will allow user to impersonate using Managed Identity assigned to workspace
CREATE DATABASE SCOPED CREDENTIAL WorkspaceIdentity WITH IDENTITY = 'Managed Identity'
GO

CREATE SCHEMA parquet;
GO
CREATE SCHEMA csv;
GO
CREATE SCHEMA json;
GO
CREATE SCHEMA cosmosdb;
GO
CREATE SCHEMA delta;
GO

-- Create external data source
CREATE EXTERNAL DATA SOURCE SqlOnDemandDemo 
WITH ( LOCATION = 'https://fabrictutorialdata.blob.core.windows.net/sampledata/Synapse');
GO

-- Data source referencing Delta Lake folders
CREATE EXTERNAL DATA SOURCE DeltaLakeStorage 
WITH (LOCATION = 'https://fabrictutorialdata.blob.core.windows.net/sampledata/Synapse/delta-lake');
GO

-- Create publicly available external data sources
CREATE EXTERNAL DATA SOURCE AzureOpenData
WITH ( LOCATION = 'https://azureopendatastorage.blob.core.windows.net/')
GO
CREATE EXTERNAL DATA SOURCE YellowTaxi
WITH ( LOCATION = 'https://azureopendatastorage.blob.core.windows.net/nyctlc/yellow/')
GO
CREATE EXTERNAL DATA SOURCE GreenTaxi
WITH ( LOCATION = 'https://azureopendatastorage.blob.core.windows.net/nyctlc/green/')
GO

CREATE EXTERNAL FILE FORMAT QuotedCsvWithHeader
WITH (  
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '"',
        FIRST_ROW = 2
    )
);
GO
CREATE EXTERNAL FILE FORMAT QuotedCsvWithoutHeader
WITH (  
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '"',
        FIRST_ROW = 1
    )
);
GO
CREATE EXTERNAL FILE FORMAT NativeParquet
WITH (  
    FORMAT_TYPE = PARQUET
);
GO
CREATE EXTERNAL FILE FORMAT DeltaLakeFormat
WITH (  
    FORMAT_TYPE = DELTA
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
    FILE_FORMAT = QuotedCsvWithHeader
);
GO

CREATE VIEW parquet.YellowTaxi
AS SELECT *, nyc.filepath(1) AS [year], nyc.filepath(2) AS [month]
FROM
    OPENROWSET(
        BULK 'parquet/taxi/year=*/month=*/*.parquet',
        DATA_SOURCE = 'SqlOnDemandDemo',
        FORMAT='PARQUET'
    ) AS nyc
GO

CREATE VIEW csv.YellowTaxi
AS
SELECT  *, nyc.filepath(1) AS [year], nyc.filepath(2) AS [month]
FROM OPENROWSET(
        BULK 'csv/taxi/yellow_tripdata_*-*.csv',
        DATA_SOURCE = 'SqlOnDemandDemo',
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
        BULK 'json/books/*.json',
        DATA_SOURCE = 'SqlOnDemandDemo',
        FORMAT='CSV',
        FIELDTERMINATOR ='0x0b',
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0b',
		ROWSET_OPTIONS = '{"READ_OPTIONS":["ALLOW_INCONSISTENT_READS"]}'
    )
    WITH (
        content varchar(8000)
    ) AS books;
GO

CREATE EXTERNAL TABLE delta.Covid (
     date_rep date,
     cases int,
     geo_id varchar(6)
) WITH (
        LOCATION = 'covid', --> the root folder containing the Delta Lake files
        data_source = DeltaLakeStorage,
        FILE_FORMAT = DeltaLakeFormat
);
