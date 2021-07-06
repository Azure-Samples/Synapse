IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('microsoft.proc_fill_calendar'))
BEGIN
    DROP PROCEDURE microsoft.proc_fill_calendar; 
END
GO

CREATE PROCEDURE microsoft.proc_fill_calendar
    @startdate DATETIME, -- = '01/01/1900',
    @enddate DATETIME --= '12/31/2100'
AS
BEGIN

    DECLARE	@year INT, 
			@month TINYINT, 
			@day TINYINT, 
			@date_quarter TINYINT,
			@quarter TINYINT,
			@month_name VARCHAR(10),
			@day_name VARCHAR(10),
			@month_of_quarter TINYINT,
			
			@week_of_year TINYINT,
			@week_of_year_iso TINYINT,
			@week_of_quarter TINYINT,
			@week_of_month TINYINT,
			
			@day_of_year SMALLINT,
			@day_of_quarter TINYINT,
			@day_of_month TINYINT,
			
			@year_start DATE,
			@year_end DATE,
			@quarter_start DATE,
			@quarter_end DATE, 			
			@month_start DATE,
			@month_end DATE,
			
			@is_leap_year BIT;

	-- Clear the existing table
    TRUNCATE TABLE microsoft.calendar;

    WHILE @startdate <= @enddate
    BEGIN

        SET @year = YEAR(@startdate);
        SET @month = MONTH(@startdate);
        SET @day = DAY(@startdate);
		SET @quarter = DATEPART(QUARTER, @startdate);

		SET @month_name = DATENAME(MONTH, @startdate);
		SET @day_name = DATENAME(WEEKDAY, @startdate);

		SET @month_of_quarter = DATEDIFF(MONTH, DATEADD(QUARTER, DATEDIFF(QUARTER, 0 , @startdate), 0), @startdate) + 1;

		SET @week_of_year = DATEPART(WEEK, @startdate);
		SET @week_of_year_iso = DATEPART(ISO_WEEK, @startdate);
		SET @week_of_quarter = DATEDIFF(DAY, DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @startdate), 0), @startdate) / 7 + 1;
		SET @week_of_month = DATEDIFF(WEEK, DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(MONTH, DATEDIFF(MONTH, 0, @startdate), 0)), 0), @startdate) + 1;

		SET @day_of_year = DATEPART(DAYOFYEAR, @startdate);
		SET @day_of_quarter = DATEDIFF(DAY, DATEADD(QUARTER, DATEDIFF(QUARTER, 0 , @startdate), 0), @startdate) + 1;
		SET @day_of_month = @day;

		SET @year_start = DATEFROMPARTS(YEAR(@startdate), 1, 1);
		SET @year_end = DATEFROMPARTS(YEAR(@startdate), 12, 31);

		SET @quarter_start = DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @startdate), 0);
		SET @quarter_end = DATEADD(DAY, -1, DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @startdate) + 1, 0));

		SET @month_start = DATEFROMPARTS(YEAR(@startdate), MONTH(@startdate), 1);
		SET @month_end = EOMONTH(@startdate);

		SET @is_leap_year = CASE WHEN (@year % 400) = 0 THEN 1 ELSE CASE WHEN (@year % 100) = 0 THEN 0 ELSE CASE WHEN (@year % 4) = 0 THEN 1 ELSE 0 END END END;

        INSERT INTO microsoft.calendar
        (
            calendar_date
            , date_year
            , date_month
            , date_day
            , date_quarter
            
            , month_name
            , day_name

            , month_of_quarter

            , week_of_year
            , week_of_year_iso
            , week_of_quarter
            , week_of_month

            , day_of_year
            , day_of_quarter
            , day_of_month

            , year_start
            , year_end
            , quarter_start
            , quarter_end
            , month_start
            , month_end

            , is_leap_year
        )
        VALUES
        (
            -- calendar_date
            @startdate
            -- date_year
            , @year
            -- date_month
            , @month
            -- date_day
            , @day
			-- date_quarter
			, @quarter

			-- month_name
			, @month_name
			-- day_name
			, @day_name

			-- month_of_quarter
			, @month_of_quarter

            -- week_of_year
			, @week_of_year
			-- week_of_year_iso
			, @week_of_year_iso
			-- week_of_quarter
			, @week_of_quarter
			-- week_of_month
			, @week_of_year

			-- day_of_year
			, @day_of_year
			-- day_of_quarter
			, @day_of_quarter
			-- day_of_month
			, @day_of_month

			-- year_start
			, @year_start
			-- year_end
			, @year_end
                                                                            
            -- quarter_start
			, @quarter_start
			-- quarter_end
			, @quarter_end
			-- month_start
			, @month_start
			-- month_end
			, @month_end

            -- is_leap_year
			, @is_leap_year
        );

        SET @startdate = DATEADD(DAY, 1, @startdate);
    END

END;
GO