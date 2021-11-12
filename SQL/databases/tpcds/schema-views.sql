DROP VIEW IF EXISTS [call_center]; 
GO

DROP VIEW IF EXISTS [catalog_page]; 
GO

DROP VIEW IF EXISTS [catalog_returns]; 
GO

DROP VIEW IF EXISTS [catalog_sales]; 
GO

DROP VIEW IF EXISTS [customer]; 
GO

DROP VIEW IF EXISTS [customer_address]; 
GO

DROP VIEW IF EXISTS [customer_demographics]; 
GO

DROP VIEW IF EXISTS [date_dim]; 
GO

DROP VIEW IF EXISTS [household_demographics]; 
GO

DROP VIEW IF EXISTS [income_band]; 
GO

DROP VIEW IF EXISTS [inventory]; 
GO

DROP VIEW IF EXISTS [item]; 
GO

DROP VIEW IF EXISTS [promotion];
GO

DROP VIEW IF EXISTS [reason]; 
GO

DROP VIEW IF EXISTS [ship_mode]; 
GO

DROP VIEW IF EXISTS [store]; 
GO

DROP VIEW IF EXISTS [store_returns];
GO

DROP VIEW IF EXISTS [store_sales];
GO

DROP VIEW IF EXISTS [time_dim];
GO

DROP VIEW IF EXISTS [warehouse];
GO

DROP VIEW IF EXISTS [web_page];
GO

DROP VIEW IF EXISTS [web_site];
GO

DROP VIEW IF EXISTS [web_returns];
GO

DROP VIEW IF EXISTS [web_sales];
GO


CREATE VIEW [call_center] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/call_center/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    CC_CALL_CENTER_SK         integer,
    CC_CALL_CENTER_ID         char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_REC_START_DATE         date,
    CC_REC_END_DATE           date,
    CC_CLOSED_DATE_SK         integer,
    CC_OPEN_DATE_SK           integer,
    CC_NAME                   varchar(50) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_CLASS                  varchar(50) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_EMPLOYEES              integer,
    CC_SQ_FT                  integer,
    CC_HOURS                  char(20) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_MANAGER                varchar(40) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_MKT_ID                 integer,
    CC_MKT_CLASS              char(50) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_MKT_DESC               varchar(100) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_MARKET_MANAGER         varchar(40) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_DIVISION               integer,
    CC_DIVISION_NAME          varchar(50) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_COMPANY                integer,
    CC_COMPANY_NAME           char(50) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_STREET_NUMBER          char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_STREET_NAME            varchar(60) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_STREET_TYPE            char(15) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_SUITE_NUMBER           char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_CITY                   varchar(60) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_COUNTY                 varchar(30) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_STATE                  char(2) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_ZIP                    char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_COUNTRY                varchar(20) COLLATE Latin1_General_100_BIN2_UTF8,
    CC_GMT_OFFSET             decimal(5,2),
    CC_TAX_PERCENTAGE         decimal(5,2)
) AS call_center;
GO

CREATE VIEW [catalog_page] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/catalog_page/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    CP_CATALOG_PAGE_SK        integer,
    CP_CATALOG_PAGE_ID        char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    CP_START_DATE_SK          integer,
    CP_END_DATE_SK            integer,
    CP_DEPARTMENT             varchar(50) COLLATE Latin1_General_100_BIN2_UTF8,
    CP_CATALOG_NUMBER         integer,
    CP_CATALOG_PAGE_NUMBER    integer,
    CP_DESCRIPTION            varchar(100) COLLATE Latin1_General_100_BIN2_UTF8,
    CP_TYPE                   varchar(100) COLLATE Latin1_General_100_BIN2_UTF8
) AS catalog_page;
GO

CREATE VIEW [catalog_returns] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/catalog_returns/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    CR_RETURNED_DATE_SK             integer,
    CR_RETURNED_TIME_SK             integer,
    CR_ITEM_SK                      integer,
    CR_REFUNDED_CUSTOMER_SK         integer,
    CR_REFUNDED_CDEMO_SK            integer,
    CR_REFUNDED_HDEMO_SK            integer,
    CR_REFUNDED_ADDR_SK             integer,
    CR_RETURNING_CUSTOMER_SK        integer,
    CR_RETURNING_CDEMO_SK           integer,
    CR_RETURNING_HDEMO_SK           integer,
    CR_RETURNING_ADDR_SK            integer,
    CR_CALL_CENTER_SK               integer,
    CR_CATALOG_PAGE_SK              integer,
    CR_SHIP_MODE_SK                 integer,
    CR_WAREHOUSE_SK                 integer,
    CR_REASON_SK                    integer,
    CR_ORDER_NUMBER                 bigint,
    CR_RETURN_QUANTITY              integer,
    CR_RETURN_AMOUNT                decimal(7,2),
    CR_RETURN_TAX                   decimal(7,2),
    CR_RETURN_AMT_INC_TAX           decimal(7,2),
    CR_FEE                          decimal(7,2),
    CR_RETURN_SHIP_COST             decimal(7,2),
    CR_REFUNDED_CASH                decimal(7,2),
    CR_REVERSED_CHARGE              decimal(7,2),
    CR_STORE_CREDIT                 decimal(7,2),
    CR_NET_LOSS                     decimal(7,2)
) AS catalog_returns;
GO

CREATE VIEW [catalog_sales] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/catalog_sales/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
	CS_SOLD_DATE_SK                 integer,
    CS_SOLD_TIME_SK                 integer,
    CS_SHIP_DATE_SK                 integer,
    CS_BILL_CUSTOMER_SK             integer,
    CS_BILL_CDEMO_SK                integer,
    CS_BILL_HDEMO_SK                integer,
    CS_BILL_ADDR_SK                 integer,
    CS_SHIP_CUSTOMER_SK             integer,
    CS_SHIP_CDEMO_SK                integer,
    CS_SHIP_HDEMO_SK                integer,
    CS_SHIP_ADDR_SK                 integer,
    CS_CALL_CENTER_SK               integer,
    CS_CATALOG_PAGE_SK              integer,
    CS_SHIP_MODE_SK                 integer,
    CS_WAREHOUSE_SK                 integer,
    CS_ITEM_SK                      integer,
    CS_PROMO_SK                     integer,
    CS_ORDER_NUMBER                 bigint,
    CS_QUANTITY                     integer,
    CS_WHOLESALE_COST               decimal(7,2),
    CS_LIST_PRICE                   decimal(7,2),
    CS_SALES_PRICE                  decimal(7,2),
    CS_EXT_DISCOUNT_AMT             decimal(7,2),
    CS_EXT_SALES_PRICE              decimal(7,2),
    CS_EXT_WHOLESALE_COST           decimal(7,2),
    CS_EXT_LIST_PRICE               decimal(7,2),
    CS_EXT_TAX                      decimal(7,2),
    CS_COUPON_AMT                   decimal(7,2),
    CS_EXT_SHIP_COST                decimal(7,2),
    CS_NET_PAID                     decimal(7,2),
    CS_NET_PAID_INC_TAX             decimal(7,2),
    CS_NET_PAID_INC_SHIP            decimal(7,2),
    CS_NET_PAID_INC_SHIP_TAX        decimal(7,2),
    CS_NET_PROFIT                   decimal(7,2)
) AS catalog_sales;
GO

CREATE VIEW [customer] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/customer/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    C_CUSTOMER_SK                   integer,
    C_CUSTOMER_ID                   char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    C_CURRENT_CDEMO_SK              integer,
    C_CURRENT_HDEMO_SK              integer,
    C_CURRENT_ADDR_SK               integer,
    C_FIRST_SHIPTO_DATE_SK          integer,
    C_FIRST_SALES_DATE_SK           integer,
    C_SALUTATION                    char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    C_FIRST_NAME                    char(20) COLLATE Latin1_General_100_BIN2_UTF8,
    C_LAST_NAME                     char(30) COLLATE Latin1_General_100_BIN2_UTF8,
    C_PREFERRED_CUST_FLAG           char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    C_BIRTH_DAY                     integer,
    C_BIRTH_MONTH                   integer,
    C_BIRTH_YEAR                    integer,
    C_BIRTH_COUNTRY                 varchar(20) COLLATE Latin1_General_100_BIN2_UTF8,
    C_LOGIN                         char(13) COLLATE Latin1_General_100_BIN2_UTF8,
    C_EMAIL_ADDRESS                 char(50) COLLATE Latin1_General_100_BIN2_UTF8,
    C_LAST_REVIEW_DATE_SK           integer
) AS customer;
GO

CREATE VIEW [customer_address] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/customer_address/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    CA_ADDRESS_SK                   integer,
    CA_ADDRESS_ID                   char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    CA_STREET_NUMBER                char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    CA_STREET_NAME                  varchar(60) COLLATE Latin1_General_100_BIN2_UTF8,
    CA_STREET_TYPE                  char(15) COLLATE Latin1_General_100_BIN2_UTF8,
    CA_SUITE_NUMBER                 char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    CA_CITY                         varchar(60) COLLATE Latin1_General_100_BIN2_UTF8,
    CA_COUNTY                       varchar(30) COLLATE Latin1_General_100_BIN2_UTF8,
    CA_STATE                        char(2) COLLATE Latin1_General_100_BIN2_UTF8,
    CA_ZIP                          char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    CA_COUNTRY                      varchar(20) COLLATE Latin1_General_100_BIN2_UTF8,
    CA_GMT_OFFSET                   decimal(5,2),
    CA_LOCATION_TYPE                char(20) COLLATE Latin1_General_100_BIN2_UTF8
) AS customer_address;
GO

CREATE VIEW [customer_demographics] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/customer_demographics/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    CD_DEMO_SK                      integer,
    CD_GENDER                       char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    CD_MARITAL_STATUS               char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    CD_EDUCATION_STATUS             char(20) COLLATE Latin1_General_100_BIN2_UTF8,
    CD_PURCHASE_ESTIMATE            integer,
    CD_CREDIT_RATING                char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    CD_DEP_COUNT                    integer, 
    CD_DEP_EMPLOYED_COUNT           integer,
    CD_DEP_COLLEGE_COUNT            integer
) AS customer_demographics;
GO

CREATE VIEW [date_dim] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/date_dim/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    D_DATE_SK                 integer,
    D_DATE_ID                 char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    D_DATE                    date,
    D_MONTH_SEQ               integer,
    D_WEEK_SEQ                integer,
    D_QUARTER_SEQ             integer,
    D_YEAR                    integer,
    D_DOW                     integer,
    D_MOY                     integer,
    D_DOM                     integer,
    D_QOY                     integer,
    D_FY_YEAR                 integer,
    D_FY_QUARTER_SEQ          integer,
    D_FY_WEEK_SEQ             integer,
    D_DAY_NAME                char(9) COLLATE Latin1_General_100_BIN2_UTF8,
    D_QUARTER_NAME            char(6) COLLATE Latin1_General_100_BIN2_UTF8,
    D_HOLIDAY                 char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    D_WEEKEND                 char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    D_FOLLOWING_HOLIDAY       char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    D_FIRST_DOM               integer,
    D_LAST_DOM                integer,
    D_SAME_DAY_LY             integer,
    D_SAME_DAY_LQ             integer,
    D_CURRENT_DAY             char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    D_CURRENT_WEEK            char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    D_CURRENT_MONTH           char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    D_CURRENT_QUARTER         char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    D_CURRENT_YEAR            char(1) COLLATE Latin1_General_100_BIN2_UTF8
) AS date_dim;
GO

CREATE VIEW [household_demographics] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/household_demographics/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    HD_DEMO_SK                      integer,
    HD_INCOME_BAND_SK               integer,
    HD_BUY_POTENTIAL                char(15) COLLATE Latin1_General_100_BIN2_UTF8,
    HD_DEP_COUNT                    integer,
    HD_VEHICLE_COUNT                integer
) AS household_demographics;
GO

CREATE VIEW [income_band] AS 
SELECT * FROM
OPENROWSET(
	BULK N'parquet/income_band/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    IB_INCOME_BAND_SK         integer,
    IB_LOWER_BOUND            integer,
    IB_UPPER_BOUND            integer
) AS income_band;
GO

CREATE VIEW [inventory] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/inventory/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    INV_DATE_SK                     integer,
    INV_ITEM_SK                     integer,
    INV_WAREHOUSE_SK                integer,
    INV_QUANTITY_ON_HAND            integer
) AS inventory;
GO

CREATE VIEW [item] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/item/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    I_ITEM_SK                       integer,
    I_ITEM_ID                       char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    I_REC_START_DATE                date,
    I_REC_END_DATE                  date,
    I_ITEM_DESC                     varchar(200) COLLATE Latin1_General_100_BIN2_UTF8,
    I_CURRENT_PRICE                 decimal(7,2),
    I_WHOLESALE_COST                decimal(7,2),
    I_BRAND_ID                      integer,
    I_BRAND                         char(50) COLLATE Latin1_General_100_BIN2_UTF8,
    I_CLASS_ID                      integer,
    I_CLASS                         char(50) COLLATE Latin1_General_100_BIN2_UTF8,
    I_CTGRY_ID                      integer,
    I_CTGRY                         char(50) COLLATE Latin1_General_100_BIN2_UTF8,
    I_MANUFACT_ID                   integer,
    I_MANUFACT                      char(50) COLLATE Latin1_General_100_BIN2_UTF8,
    I_SIZE                          char(20) COLLATE Latin1_General_100_BIN2_UTF8,
    I_FORMULATION                   char(20) COLLATE Latin1_General_100_BIN2_UTF8,
    I_COLOR                         char(20) COLLATE Latin1_General_100_BIN2_UTF8,
    I_UNITS                         char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    I_CONTAINER                     char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    I_MANAGER_ID                    integer,
    I_PRODUCT_NAME                  char(50) COLLATE Latin1_General_100_BIN2_UTF8
) AS item;
GO
 
CREATE VIEW [promotion] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/promotion/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    P_PROMO_SK                      integer,
    P_PROMO_ID                      char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    P_START_DATE_SK                 integer,
    P_END_DATE_SK                   integer,
    P_ITEM_SK                       integer,
    P_COST                          decimal(15,2),
    P_RESPONSE_TARGET               integer,
    P_PROMO_NAME                    char(50) COLLATE Latin1_General_100_BIN2_UTF8,
    P_CHANNEL_DMAIL                 char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    P_CHANNEL_EMAIL                 char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    P_CHANNEL_CATALOG               char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    P_CHANNEL_TV                    char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    P_CHANNEL_RADIO                 char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    P_CHANNEL_PRESS                 char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    P_CHANNEL_EVENT                 char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    P_CHANNEL_DEMO                  char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    P_CHANNEL_DETAILS               varchar(100) COLLATE Latin1_General_100_BIN2_UTF8,
    P_PURPOSE                       char(15) COLLATE Latin1_General_100_BIN2_UTF8,
    P_DISCOUNT_ACTIVE               char(1) COLLATE Latin1_General_100_BIN2_UTF8
) AS promotion;
GO

CREATE VIEW [reason] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/reason/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    R_REASON_SK               integer,
    R_REASON_ID               char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    R_REASON_DESC             char(100) COLLATE Latin1_General_100_BIN2_UTF8
) AS reason;
GO

CREATE VIEW [ship_mode] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/ship_mode/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    SM_SHIP_MODE_SK           integer,
    SM_SHIP_MODE_ID           char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    SM_TYPE                   char(30) COLLATE Latin1_General_100_BIN2_UTF8,
    SM_CODE                   char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    SM_CARRIER                char(20) COLLATE Latin1_General_100_BIN2_UTF8,
    SM_CONTRACT               char(20) COLLATE Latin1_General_100_BIN2_UTF8
) AS ship_mode;
GO

CREATE VIEW [store] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/store/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    S_STORE_SK                      integer,
    S_STORE_ID                      char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    S_REC_START_DATE                date,
    S_REC_END_DATE                  date,
    S_CLOSED_DATE_SK                integer,
    S_STORE_NAME                    varchar(50) COLLATE Latin1_General_100_BIN2_UTF8,
    S_NUMBER_EMPLOYEES              integer,
    S_FLOOR_SPACE                   integer,
    S_HOURS                         char(20) COLLATE Latin1_General_100_BIN2_UTF8,
    S_MANAGER                       varchar(40) COLLATE Latin1_General_100_BIN2_UTF8,
    S_MARKET_ID                     integer,
    S_GEOGRAPHY_CLASS               varchar(100) COLLATE Latin1_General_100_BIN2_UTF8,
    S_MARKET_DESC                   varchar(100) COLLATE Latin1_General_100_BIN2_UTF8,
    S_MARKET_MANAGER                varchar(40) COLLATE Latin1_General_100_BIN2_UTF8,
    S_DIVISION_ID                   integer,
    S_DIVISION_NAME                 varchar(50) COLLATE Latin1_General_100_BIN2_UTF8,
    S_COMPANY_ID                    integer,
    S_COMPANY_NAME                  varchar(50) COLLATE Latin1_General_100_BIN2_UTF8,
    S_STREET_NUMBER                 varchar(10) COLLATE Latin1_General_100_BIN2_UTF8,
    S_STREET_NAME                   varchar(60) COLLATE Latin1_General_100_BIN2_UTF8,
    S_STREET_TYPE                   char(15) COLLATE Latin1_General_100_BIN2_UTF8,
    S_SUITE_NUMBER                  char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    S_CITY                          varchar(60) COLLATE Latin1_General_100_BIN2_UTF8,
    S_COUNTY                        varchar(30) COLLATE Latin1_General_100_BIN2_UTF8,
    S_STATE                         char(2) COLLATE Latin1_General_100_BIN2_UTF8,
    S_ZIP                           char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    S_COUNTRY                       varchar(20) COLLATE Latin1_General_100_BIN2_UTF8,
    S_GMT_OFFSET                    decimal(5,2),
    S_TAX_PRECENTAGE                decimal(5,2)
) AS store;
GO

CREATE VIEW [store_returns] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/store_returns/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    SR_RETURNED_DATE_SK       integer,
    SR_RETURN_TIME_SK         integer,
    SR_ITEM_SK                integer,
    SR_CUSTOMER_SK            integer,
    SR_CDEMO_SK               integer,
    SR_HDEMO_SK               integer,
    SR_ADDR_SK                integer,
    SR_STORE_SK               integer,
    SR_REASON_SK              integer,
    SR_TICKET_NUMBER          integer,
    SR_RETURN_QUANTITY        integer,
    SR_RETURN_AMT             decimal(7,2),
    SR_RETURN_TAX             decimal(7,2),
    SR_RETURN_AMT_INC_TAX     decimal(7,2),
    SR_FEE                    decimal(7,2),
    SR_RETURN_SHIP_COST       decimal(7,2),
    SR_REFUNDED_CASH          decimal(7,2),
    SR_REVERSED_CHARGE        decimal(7,2),
    SR_STORE_CREDIT           decimal(7,2),
    SR_NET_LOSS               decimal(7,2)
) AS store_returns;
GO

CREATE VIEW [store_sales] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/store_sales/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    SS_SOLD_DATE_SK                   integer,
    SS_SOLD_TIME_SK                   integer,
    SS_ITEM_SK                        integer,
    SS_CUSTOMER_SK                    integer,
    SS_CDEMO_SK                       integer,
    SS_HDEMO_SK                       integer,
    SS_ADDR_SK                        integer,
    SS_STORE_SK                       integer,
    SS_PROMO_SK                       integer,
    SS_TICKET_NUMBER                  integer,
    SS_QUANTITY                       integer,
    SS_WHOLESALE_COST                 decimal(7, 2),
    SS_LIST_PRICE                     decimal(7, 2),
    SS_SALES_PRICE                    decimal(7, 2),
    SS_EXT_DISCOUNT_AMT               decimal(7, 2),
    SS_EXT_SALES_PRICE                decimal(7, 2),
    SS_EXT_WHOLESALE_COST             decimal(7, 2),
    SS_EXT_LIST_PRICE                 decimal(7, 2),
    SS_EXT_TAX                        decimal(7, 2),
    SS_COUPON_AMT                     decimal(7, 2),
    SS_NET_PAID                       decimal(7, 2),
    SS_NET_PAID_INC_TAX               decimal(7, 2),
    SS_NET_PROFIT                     decimal(7, 2)
) AS store_sales;
GO

CREATE VIEW [time_dim] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/time_dim/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    T_TIME_SK                 integer,
    T_TIME_ID                 char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    T_TIME                    integer,
    T_HOUR                    integer,
    T_MINUTE                  integer,
    T_SECOND                  integer,
    T_AM_PM                   char(2) COLLATE Latin1_General_100_BIN2_UTF8,
    T_SHIFT                   char(20) COLLATE Latin1_General_100_BIN2_UTF8,
    T_SUB_SHIFT               char(20) COLLATE Latin1_General_100_BIN2_UTF8,
    T_MEAL_TIME               char(20) COLLATE Latin1_General_100_BIN2_UTF8
) AS time_dim;
GO

CREATE VIEW [warehouse] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/warehouse/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    W_WAREHOUSE_SK            integer,
    W_WAREHOUSE_ID            char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    W_WAREHOUSE_NAME          varchar(20) COLLATE Latin1_General_100_BIN2_UTF8,
    W_WAREHOUSE_SQ_FT         integer,
    W_STREET_NUMBER           char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    W_STREET_NAME             varchar(60) COLLATE Latin1_General_100_BIN2_UTF8,
    W_STREET_TYPE             char(15) COLLATE Latin1_General_100_BIN2_UTF8,
    W_SUITE_NUMBER            char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    W_CITY                    varchar(60) COLLATE Latin1_General_100_BIN2_UTF8,
    W_COUNTY                  varchar(30) COLLATE Latin1_General_100_BIN2_UTF8,
    W_STATE                   char(2) COLLATE Latin1_General_100_BIN2_UTF8,
    W_ZIP                     char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    W_COUNTRY                 varchar(20) COLLATE Latin1_General_100_BIN2_UTF8,
    W_GMT_OFFSET              decimal(5,2)
) AS warehouse;
GO

CREATE VIEW [web_page] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/web_page/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    WP_WEB_PAGE_SK            integer,
    WP_WEB_PAGE_ID            char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    WP_REC_START_DATE         date,
    WP_REC_END_DATE           date,
    WP_CREATION_DATE_SK       integer,
    WP_ACCESS_DATE_SK         integer,
    WP_AUTOGEN_FLAG           char(1) COLLATE Latin1_General_100_BIN2_UTF8,
    WP_CUSTOMER_SK            integer,
    WP_URL                    varchar(100) COLLATE Latin1_General_100_BIN2_UTF8,
    WP_TYPE                   char(50) COLLATE Latin1_General_100_BIN2_UTF8,
    WP_CHAR_COUNT             integer,
    WP_LINK_COUNT             integer,
    WP_IMAGE_COUNT            integer,
    WP_MAX_AD_COUNT           integer
) AS web_page;
GO

CREATE VIEW [web_returns] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/web_returns/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    WR_RETURNED_DATE_SK             integer,
    WR_RETURNED_TIME_SK             integer,
    WR_ITEM_SK                      integer,
    WR_REFUNDED_CUSTOMER_SK         integer,
    WR_REFUNDED_CDEMO_SK            integer,
    WR_REFUNDED_HDEMO_SK            integer,
    WR_REFUNDED_ADDR_SK             integer,
    WR_RETURNING_CUSTOMER_SK        integer,
    WR_RETURNING_CDEMO_SK           integer,
    WR_RETURNING_HDEMO_SK           integer,
    WR_RETURNING_ADDR_SK            integer,
    WR_WEB_PAGE_SK                  integer,
    WR_REASON_SK                    integer,
    WR_ORDER_NUMBER                 integer,
    WR_RETURN_QUANTITY              integer,
    WR_RETURN_AMT                   decimal(7,2),
    WR_RETURN_TAX                   decimal(7,2),
    WR_RETURN_AMT_INC_TAX           decimal(7,2),
    WR_FEE                          decimal(7,2),
    WR_RETURN_SHIP_COST             decimal(7,2),
    WR_REFUNDED_CASH                decimal(7,2),
    WR_REVERSED_CHARGE              decimal(7,2),
    WR_ACCOUNT_CREDIT               decimal(7,2),
    WR_NET_LOSS                     decimal(7,2)
) AS web_returns;
GO

CREATE VIEW [web_sales] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/web_sales/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    WS_SOLD_DATE_SK                 integer,
    WS_SOLD_TIME_SK                 integer,
    WS_SHIP_DATE_SK                 integer,
    WS_ITEM_SK                      integer,
    WS_BILL_CUSTOMER_SK             integer,
    WS_BILL_CDEMO_SK                integer,
    WS_BILL_HDEMO_SK                integer,
    WS_BILL_ADDR_SK                 integer,
    WS_SHIP_CUSTOMER_SK             integer,
    WS_SHIP_CDEMO_SK                integer,
    WS_SHIP_HDEMO_SK                integer,
    WS_SHIP_ADDR_SK                 integer,
    WS_WEB_PAGE_SK                  integer,
    WS_WEB_SITE_SK                  integer,
    WS_SHIP_MODE_SK                 integer,
    WS_WAREHOUSE_SK                 integer,
    WS_PROMO_SK                     integer,
    WS_ORDER_NUMBER                 integer,
    WS_QUANTITY                     integer,
    WS_WHOLESALE_COST               decimal(7,2),
    WS_LIST_PRICE                   decimal(7,2),
    WS_SALES_PRICE                  decimal(7,2),
    WS_EXT_DISCOUNT_AMT             decimal(7,2),
    WS_EXT_SALES_PRICE              decimal(7,2),
    WS_EXT_WHOLESALE_COST           decimal(7,2),
    WS_EXT_LIST_PRICE               decimal(7,2),
    WS_EXT_TAX                      decimal(7,2),
    WS_COUPON_AMT                   decimal(7,2),
    WS_EXT_SHIP_COST                decimal(7,2),
    WS_NET_PAID                     decimal(7,2),
    WS_NET_PAID_INC_TAX             decimal(7,2),
    WS_NET_PAID_INC_SHIP            decimal(7,2),
    WS_NET_PAID_INC_SHIP_TAX        decimal(7,2),
    WS_NET_PROFIT                   decimal(7,2)
) AS web_sales;
GO

CREATE VIEW [web_site] AS
SELECT * FROM
OPENROWSET(
	BULK N'parquet/web_site/*', FORMAT = 'PARQUET', FIELDTERMINATOR = '|', DATA_SOURCE = 'tpcds_data') 
	WITH (
    WEB_SITE_SK               integer,
    WEB_SITE_ID               char(16) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_REC_START_DATE        date,
    WEB_REC_END_DATE          date,
    WEB_NAME                  varchar(50) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_OPEN_DATE_SK          integer,
    WEB_CLOSE_DATE_SK         integer,
    WEB_CLASS                 varchar(50) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_MANAGER               varchar(40) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_MKT_ID                integer,
    WEB_MKT_CLASS             varchar(50) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_MKT_DESC              varchar(100) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_MARKET_MANAGER        varchar(40) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_COMPANY_ID            integer,
    WEB_COMPANY_NAME          char(50) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_STREET_NUMBER         char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_STREET_NAME           varchar(60) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_STREET_TYPE           char(15) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_SUITE_NUMBER          char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_CITY                  varchar(60) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_COUNTY                varchar(30) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_STATE                 char(2) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_ZIP                   char(10) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_COUNTRY               varchar(20) COLLATE Latin1_General_100_BIN2_UTF8,
    WEB_GMT_OFFSET            decimal(5,2),
    WEB_TAX_PERCENTAGE        decimal(5,2)
) AS web_site;
GO
