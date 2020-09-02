CREATE TABLE [dbo].[Date]
(
	[DateID] int NOT NULL,
	[Date] datetime NULL,
	[DateBKey] char(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DayOfMonth] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DaySuffix] varchar(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DayName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DayOfWeek] char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DayOfWeekInMonth] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DayOfWeekInYear] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DayOfQuarter] varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DayOfYear] varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WeekOfMonth] varchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WeekOfQuarter] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WeekOfYear] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Month] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MonthName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MonthOfQuarter] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Quarter] char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuarterName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Year] char(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[YearName] char(7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MonthYear] char(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MMYYYY] char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstDayOfMonth] date NULL,
	[LastDayOfMonth] date NULL,
	[FirstDayOfQuarter] date NULL,
	[LastDayOfQuarter] date NULL,
	[FirstDayOfYear] date NULL,
	[LastDayOfYear] date NULL,
	[IsHolidayUSA] bit NULL,
	[IsWeekday] bit NULL,
	[HolidayUSA] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);