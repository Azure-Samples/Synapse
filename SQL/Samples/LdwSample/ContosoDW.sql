-- Use data from Azure blob storage in the Contoso Retail Logical Data Warehouse.
--
-- Before you begin:
-- To run this tutorial, you need an Azure account that already has a Synapse Analytics workspace.
-- If you don't already have this, see 
-- https://techcommunity.microsoft.com/t5/azure-synapse-analytics/you-need-just-5-minutes-to-create-synapse-workspace-and-run-your/ba-p/1750253
--

-- Create an external data source
-- LOCATION: Provide Azure storage account name and blob container name.
-- CREDENTIAL: Provide the credential created in the previous step.

CREATE EXTERNAL DATA SOURCE AzureStorage_west_public
WITH 
(  
    LOCATION = 'wasbs://contosoretaildw-tables@contosoretaildw.blob.core.windows.net/'
); 
GO

-- The data is stored in text files in Azure blob storage, and each field is separated with a delimiter. 
-- Run this [CREATE EXTERNAL FILE FORMAT][] command to specify the format of the data in the text files. 
-- The Contoso data is uncompressed and pipe delimited.

CREATE EXTERNAL FILE FORMAT TextFileFormat 
WITH 
(   FORMAT_TYPE = DELIMITEDTEXT
,	FORMAT_OPTIONS	(   FIELD_TERMINATOR = '|'
					,	STRING_DELIMITER = ''
					,	USE_TYPE_DEFAULT = FALSE 
					)
);
GO

-- To create a place to store the Contoso data in your database, create a schema.

CREATE SCHEMA [asb];
GO

-- Now let's create the external tables. All we are doing here is defining column names and data types, 
-- and binding them to the location and format of the Azure blob storage files. The location is the folder 
-- under the root directory of the Azure Storage Blob.

--DimAccount
CREATE EXTERNAL TABLE [asb].DimAccount 
(
	[AccountKey] [int],
	[ParentAccountKey] [int],
	[AccountLabel] [nvarchar](100),
	[AccountName] [nvarchar](50),
	[AccountDescription] [nvarchar](50),
	[AccountType] [nvarchar](50),
	[Operator] [nvarchar](50),
	[CustomMembers] [nvarchar](300),
	[ValueType] [nvarchar](50),
	[CustomMemberOptions] [nvarchar](200),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH 
(
    LOCATION='/DimAccount/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimChannel
CREATE EXTERNAL TABLE [asb].DimChannel 
(
	[ChannelKey] [int],
	[ChannelLabel] [nvarchar](100),
	[ChannelName] [nvarchar](20),
	[ChannelDescription] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimChannel/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimCurrency
CREATE EXTERNAL TABLE [asb].DimCurrency 
(
	[CurrencyKey] [int],
	[CurrencyLabel] [nvarchar](10),
	[CurrencyName] [nvarchar](20),
	[CurrencyDescription] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimCurrency/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--DimCustomer
CREATE EXTERNAL TABLE [asb].DimCustomer 
(
	[CustomerKey] [int] ,
	[GeographyKey] [int],
	[CustomerLabel] [nvarchar](100),
	[Title] [nvarchar](8),
	[FirstName] [nvarchar](50),
	[MiddleName] [nvarchar](50),
	[LastName] [nvarchar](50),
	[NameStyle] [bit],
	[BirthDate] [datetime],
	[MaritalStatus] [nchar](1),
	[Suffix] [nvarchar](10),
	[Gender] [nvarchar](1),
	[EmailAddress] [nvarchar](50),
	[YearlyIncome] [money],
	[TotalChildren] [tinyint],
	[NumberChildrenAtHome] [tinyint],
	[Education] [nvarchar](40),
	[Occupation] [nvarchar](100),
	[HouseOwnerFlag] [nchar](1),
	[NumberCarsOwned] [tinyint],
	[AddressLine1] [nvarchar](120),
	[AddressLine2] [nvarchar](120),
	[Phone] [nvarchar](20),
	[DateFirstPurchase] [datetime],
	[CustomerType] [nvarchar](15),
	[CompanyName] [nvarchar](100),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimCustomer/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--DimDate
CREATE EXTERNAL TABLE [asb].DimDate
(
	[Datekey] [datetime],
	[FullDateLabel] [nvarchar](20),
	[DateDescription] [nvarchar](20),
	[CalendarYear] [int],
	[CalendarYearLabel] [nvarchar](20),
	[CalendarHalfYear] [int],
	[CalendarHalfYearLabel] [nvarchar](20),
	[CalendarQuarter] [int],
	[CalendarQuarterLabel] [nvarchar](20),
	[CalendarMonth] [int],
	[CalendarMonthLabel] [nvarchar](20),
	[CalendarWeek] [int],
	[CalendarWeekLabel] [nvarchar](20),
	[CalendarDayOfWeek] [int],
	[CalendarDayOfWeekLabel] [nvarchar](10),
	[FiscalYear] [int],
	[FiscalYearLabel] [nvarchar](20),
	[FiscalHalfYear] [int],
	[FiscalHalfYearLabel] [nvarchar](20),
	[FiscalQuarter] [int],
	[FiscalQuarterLabel] [nvarchar](20),
	[FiscalMonth] [int],
	[FiscalMonthLabel] [nvarchar](20),
	[IsWorkDay] [nvarchar](20),
	[IsHoliday] [int],
	[HolidayName] [nvarchar](20),
	[EuropeSeason] [nvarchar](50),
	[NorthAmericaSeason] [nvarchar](50),
	[AsiaSeason] [nvarchar](50)
)
WITH
(
    LOCATION='/DimDate/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimEmployee
CREATE EXTERNAL TABLE [asb].DimEmployee 
(
	[EmployeeKey] [int] ,
	[ParentEmployeeKey] [int],
	[FirstName] [nvarchar](50),
	[LastName] [nvarchar](50),
	[MiddleName] [nvarchar](50),
	[Title] [nvarchar](50),
	[HireDate] [datetime],
	[BirthDate] [datetime],
	[EmailAddress] [nvarchar](50),
	[Phone] [nvarchar](25),
	[MaritalStatus] [nchar](1),
	[EmergencyContactName] [nvarchar](50),
	[EmergencyContactPhone] [nvarchar](25),
	[SalariedFlag] [bit],
	[Gender] [nchar](1),
	[PayFrequency] [tinyint],
	[BaseRate] [money],
	[VacationHours] [smallint],
	[CurrentFlag] [bit],
	[SalesPersonFlag] [bit],
	[DepartmentName] [nvarchar](50),
	[StartDate] [datetime],
	[EndDate] [datetime],
	[Status] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimEmployee/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimEntity
CREATE EXTERNAL TABLE [asb].DimEntity 
(
	[EntityKey] [int],
	[EntityLabel] [nvarchar](100),
	[ParentEntityKey] [int],
	[ParentEntityLabel] [nvarchar](100),
	[EntityName] [nvarchar](50),
	[EntityDescription] [nvarchar](100),
	[EntityType] [nvarchar](100),
	[StartDate] [datetime],
	[EndDate] [datetime],
	[Status] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimEntity/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimGeography
CREATE EXTERNAL TABLE [asb].DimGeography 
(
	[GeographyKey] [int],
	[GeographyType] [nvarchar](50),
	[ContinentName] [nvarchar](50),
	[CityName] [nvarchar](100),
	[StateProvinceName] [nvarchar](100),
	[RegionCountryName] [nvarchar](100),
--	[Geometry] [geometry],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimGeography/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimMachine
CREATE EXTERNAL TABLE [asb].DimMachine 
(
	[MachineKey] [int],
	[MachineLabel] [nvarchar](100),
	[StoreKey] [int],
	[MachineType] [nvarchar](50),
	[MachineName] [nvarchar](100),
	[MachineDescription] [nvarchar](200),
	[VendorName] [nvarchar](50),
	[MachineOS] [nvarchar](50),
	[MachineSource] [nvarchar](100),
	[MachineHardware] [nvarchar](100),
	[MachineSoftware] [nvarchar](100),
	[Status] [nvarchar](50),
	[ServiceStartDate] [datetime],
	[DecommissionDate] [datetime],
	[LastModifiedDate] [datetime],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimMachine/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimOutage
CREATE EXTERNAL TABLE [asb].DimOutage (
	[OutageKey] [int] ,
	[OutageLabel] [nvarchar](100),
	[OutageName] [nvarchar](50),
	[OutageDescription] [nvarchar](200),
	[OutageType] [nvarchar](50),
	[OutageTypeDescription] [nvarchar](200),
	[OutageSubType] [nvarchar](50),
	[OutageSubTypeDescription] [nvarchar](200),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimOutage/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimProduct
CREATE EXTERNAL TABLE [asb].DimProduct (
	[ProductKey] [int],
	[ProductLabel] [nvarchar](255),
	[ProductName] [nvarchar](500),
	[ProductDescription] [nvarchar](400),
	[ProductSubcategoryKey] [int],
	[Manufacturer] [nvarchar](50),
	[BrandName] [nvarchar](50),
	[ClassID] [nvarchar](10),
	[ClassName] [nvarchar](20),
	[StyleID] [nvarchar](10),
	[StyleName] [nvarchar](20),
	[ColorID] [nvarchar](10),
	[ColorName] [nvarchar](20),
	[Size] [nvarchar](50),
	[SizeRange] [nvarchar](50),
	[SizeUnitMeasureID] [nvarchar](20),
	[Weight] [float],
	[WeightUnitMeasureID] [nvarchar](20),
	[UnitOfMeasureID] [nvarchar](10),
	[UnitOfMeasureName] [nvarchar](40),
	[StockTypeID] [nvarchar](10),
	[StockTypeName] [nvarchar](40),
	[UnitCost] [money],
	[UnitPrice] [money],
	[AvailableForSaleDate] [datetime],
	[StopSaleDate] [datetime],
	[Status] [nvarchar](7),
	[ImageURL] [nvarchar](150),
	[ProductURL] [nvarchar](150),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimProduct/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimProductCategory
CREATE EXTERNAL TABLE [asb].DimProductCategory (
	[ProductCategoryKey] [int] ,
	[ProductCategoryLabel] [nvarchar](100),
	[ProductCategoryName] [nvarchar](30),
	[ProductCategoryDescription] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimProductCategory/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimProductSubcategory
CREATE EXTERNAL TABLE [asb].DimProductSubcategory (
	[ProductSubcategoryKey] [int] ,
	[ProductSubcategoryLabel] [nvarchar](100),
	[ProductSubcategoryName] [nvarchar](50),
	[ProductSubcategoryDescription] [nvarchar](100),
	[ProductCategoryKey] [int],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimProductSubcategory/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimPromotion
CREATE EXTERNAL TABLE [asb].DimPromotion (
	[PromotionKey] [int] ,
	[PromotionLabel] [nvarchar](100),
	[PromotionName] [nvarchar](100),
	[PromotionDescription] [nvarchar](255),
	[DiscountPercent] [float],
	[PromotionType] [nvarchar](50),
	[PromotionCategory] [nvarchar](50),
	[StartDate] [datetime],
	[EndDate] [datetime],
	[MinQuantity] [int],
	[MaxQuantity] [int],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimPromotion/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
 
--DimSalesTerritory
CREATE EXTERNAL TABLE [asb].DimSalesTerritory (
	[SalesTerritoryKey] [int] ,
	[GeographyKey] [int],
	[SalesTerritoryLabel] [nvarchar](100),
	[SalesTerritoryName] [nvarchar](50),
	[SalesTerritoryRegion] [nvarchar](50),
	[SalesTerritoryCountry] [nvarchar](50),
	[SalesTerritoryGroup] [nvarchar](50),
	[SalesTerritoryLevel] [nvarchar](10),
	[SalesTerritoryManager] [int],
	[StartDate] [datetime],
	[EndDate] [datetime],
	[Status] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimSalesTerritory/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimScenario
CREATE EXTERNAL TABLE [asb].DimScenario (
	[ScenarioKey] [int],
	[ScenarioLabel] [nvarchar](100),
	[ScenarioName] [nvarchar](20),
	[ScenarioDescription] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimScenario/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--DimStore
CREATE EXTERNAL TABLE [asb].DimStore 
(
	[StoreKey] [int],
	[GeographyKey] [int],
	[StoreManager] [int],
	[StoreType] [nvarchar](15),
	[StoreName] [nvarchar](100),
	[StoreDescription] [nvarchar](300),
	[Status] [nvarchar](20),
	[OpenDate] [datetime],
	[CloseDate] [datetime],
	[EntityKey] [int],
	[ZipCode] [nvarchar](20),
	[ZipCodeExtension] [nvarchar](10),
	[StorePhone] [nvarchar](15),
	[StoreFax] [nvarchar](14),
	[AddressLine1] [nvarchar](100),
	[AddressLine2] [nvarchar](100),
	[CloseReason] [nvarchar](20),
	[EmployeeCount] [int],
	[SellingAreaSize] [float],
	[LastRemodelDate] [datetime],
	[GeoLocation]	NVARCHAR(50) ,
	[Geometry]		NVARCHAR(50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimStore/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--FactExchangeRate
CREATE EXTERNAL TABLE [asb].FactExchangeRate 
(
	[ExchangeRateKey] [int] ,
	[CurrencyKey] [int],
	[DateKey] [datetime],
	[AverageRate] [float],
	[EndOfDayRate] [float],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactExchangeRate/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--FactInventory
CREATE EXTERNAL TABLE [asb].FactInventory (
	[InventoryKey] [int] ,
	[DateKey] [datetime],
	[StoreKey] [int],
	[ProductKey] [int],
	[CurrencyKey] [int],
	[OnHandQuantity] [int],
	[OnOrderQuantity] [int],
	[SafetyStockQuantity] [int],
	[UnitCost] [money],
	[DaysInStock] [int],
	[MinDayInStock] [int],
	[MaxDayInStock] [int],
	[Aging] [int],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactInventory/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--FactITMachine
CREATE EXTERNAL TABLE [asb].FactITMachine (
	[ITMachinekey] [int],
	[MachineKey] [int],
	[Datekey] [datetime],
	[CostAmount] [money],
	[CostType] [nvarchar](200),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactITMachine/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;


--FactITSLA
CREATE EXTERNAL TABLE [asb].FactITSLA 
(
	[ITSLAkey] [int] ,
	[DateKey] [datetime],
	[StoreKey] [int],
	[MachineKey] [int],
	[OutageKey] [int],
	[OutageStartTime] [datetime],
	[OutageEndTime] [datetime],
	[DownTime] [int],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactITSLA/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--FactOnlineSales
CREATE EXTERNAL TABLE [asb].FactOnlineSales 
(
	[OnlineSalesKey] [int] ,
	[DateKey] [datetime],
	[StoreKey] [int],
	[ProductKey] [int],
	[PromotionKey] [int],
	[CurrencyKey] [int],
	[CustomerKey] [int],
	[SalesOrderNumber] [nvarchar](20),
	[SalesOrderLineNumber] [int],
	[SalesQuantity] [int],
	[SalesAmount] [money],
	[ReturnQuantity] [int],
	[ReturnAmount] [money],
	[DiscountQuantity] [int],
	[DiscountAmount] [money],
	[TotalCost] [money],
	[UnitCost] [money],
	[UnitPrice] [money],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactOnlineSales/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--FactSales
CREATE EXTERNAL TABLE [asb].FactSales 
(
	[SalesKey] [int] ,
	[DateKey] [datetime],
	[channelKey] [int],
	[StoreKey] [int],
	[ProductKey] [int],
	[PromotionKey] [int],
	[CurrencyKey] [int],
	[UnitCost] [money],
	[UnitPrice] [money],
	[SalesQuantity] [int],
	[ReturnQuantity] [int],
	[ReturnAmount] [money],
	[DiscountQuantity] [int],
	[DiscountAmount] [money],
	[TotalCost] [money],
	[SalesAmount] [money],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactSales/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--FactSalesQuota
CREATE EXTERNAL TABLE [asb].FactSalesQuota (
	[SalesQuotaKey] [int] ,
	[ChannelKey] [int],
	[StoreKey] [int],
	[ProductKey] [int],
	[DateKey] [datetime],
	[CurrencyKey] [int],
	[ScenarioKey] [int],
	[SalesQuantityQuota] [money],
	[SalesAmountQuota] [money],
	[GrossMarginQuota] [money],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactSalesQuota/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--FactStrategyPlan
CREATE EXTERNAL TABLE [asb].FactStrategyPlan 
(
	[StrategyPlanKey] [int] ,
	[Datekey] [datetime],
	[EntityKey] [int],
	[ScenarioKey] [int],
	[AccountKey] [int],
	[CurrencyKey] [int],
	[ProductCategoryKey] [int],
	[Amount] [money],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactStrategyPlan/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--
-- Enjoy exploring with Logical Data Warehouse created in serverless SQL pool.
