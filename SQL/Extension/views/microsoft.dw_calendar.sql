IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('microsoft.dw_calendar'))
BEGIN
    DROP VIEW microsoft.dw_calendar; 
END
GO

CREATE VIEW microsoft.dw_calendar
AS
SELECT
	calendar_date,
	date_year,
	date_month,
	date_day,
	date_quarter,
	month_name,
	day_name,
	month_of_quarter,
	week_of_year,
	week_of_year_iso,
	week_of_quarter,
	week_of_month,
	day_of_year,
	day_of_quarter,
	day_of_month,
	day_of_week = DATEPART(WEEKDAY, calendar_date),
	year_start,
	year_end,
	quarter_start,
	quarter_end,
	month_start,
	month_end,
	week_start = DATEADD(DAY, 1 - DATEPART(WEEKDAY, calendar_date), CAST(calendar_date AS DATE)),
	week_end = DATEADD(DAY, 7 - DATEPART(WEEKDAY, calendar_date), CAST(calendar_date AS DATE)),
	is_leap_year
FROM
	microsoft.calendar;
GO