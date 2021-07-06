IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('microsoft.calendar'))
BEGIN
    DROP TABLE microsoft.calendar; 
END
GO

CREATE TABLE microsoft.calendar
(
    calendar_date       DATE            NOT NULL
    , date_year         SMALLINT        NOT NULL
    , date_month        TINYINT         NOT NULL
    , date_day          TINYINT         NULL
    , date_quarter      TINYINT         NULL

    , month_name        VARCHAR(10)     NULL
    , day_name          VARCHAR(10)     NULL

    , month_of_quarter  TINYINT         NULL

    , week_of_year      TINYINT         NULL
    , week_of_year_iso  TINYINT         NULL
    , week_of_quarter   TINYINT         NULL
    , week_of_month     TINYINT         NULL

    , day_of_year       SMALLINT        NULL
    , day_of_quarter    TINYINT         NULL
    , day_of_month      TINYINT         NULL

    , year_start        DATE            NULL
    , year_end          DATE            NULL
    , quarter_start     DATE            NULL
    , quarter_end       DATE            NULL
    , month_start       DATE            NULL
    , month_end         DATE            NULL

    , is_leap_year      BIT             NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	HEAP
);
GO