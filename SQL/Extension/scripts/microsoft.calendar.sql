CREATE NONCLUSTERED INDEX idx_microsoft_calendar_calendar_date ON microsoft.calendar (calendar_date) WITH (DROP_EXISTING = OFF);
GO

CREATE STATISTICS stx_microsoft_calendar_all ON microsoft.calendar
	( calendar_date, date_year, date_month, date_day, date_quarter, month_name, day_name, month_of_quarter, week_of_year, week_of_year_iso, week_of_quarter, week_of_month, day_of_year, day_of_quarter, day_of_month, year_start, year_end, quarter_start, quarter_end, month_start, month_end, is_leap_year )
	WITH FULLSCAN;
GO