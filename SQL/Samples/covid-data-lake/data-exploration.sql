
select top 10  *
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.csv',
                format='csv', parser_version='2.0') as a
                
-- Use HEADER_ROW because this file has header                
select top 10  *
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.csv',
                format='csv', parser_version='2.0', FIRSTROW = 2) as a

select top 10
        cases = json_value(doc, '$.cases'),
        *
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.jsonl',
                format='csv', fieldterminator ='0x0b', fieldquote = '0x0b') with (doc nvarchar(max)) as a

select top 10  *
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',
                format='parquet') as a

-- ## Explore your data 
-- As a first step we need to explore data in the file place in Azure storage using `OPENROWSET` function:

select top 10  *  
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',  
                format='parquet') as a


-- Here we can see that some of the columns interesting for analysis are `DATE_REP` and `CASES`. I would like to analyze number of cases reported in Serbia, so I would need to filter the results using `GEO_ID` column. 
-- We are not sure what is `geo_id` value for Serbia, so we will find all distinct countries and `geo_id` values where country is something like Serbia:

select distinct countries_and_territories, geo_id  
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',  
                format='parquet') as a  
where countries_and_territories like '%Ser%'


-- Since we see that `GEO_ID` for Serbia is `RS`, we can find dayly number of cases in Serbia:
select DATE_REP, CASES  
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',  
                format='parquet') as a  
where geo_id = 'RS'  
order by date_rep


-- We can show this in the chart to see trend analysis of reported COVID cases in Serbia. By looking at this chart, we can see that the peek is somewhere between 15th and 20th April and the peak in the second wave is second half of July. 
-- The points on time series charts are shown per daily basis. This might lead to daily variation, so you might want to show the graph with average values calculated in the window with +/- 1-2 days. T-SQL enables you to easily calculate average values if you specify time window: 
-- ``` 
-- AVG(CASES) OVER(order by date_rep ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING  ) 
-- ``` 
-- We need to specify how to locally order data and number of preceding/following rows that AVG function should use to calculate the average value within the window. The time series query that uses average values is shown on the following code:

select  DATE_REP,  
        CASES_AVG = AVG(CASES) OVER(ORDER BY date_rep ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING  )  
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet', format='parquet') as a  
where geo_id = 'RS'  
order by date_rep


-- We can also show cumulative values to see increase of the number of cases over time (this is known as running total):

select DATE_REP,  
        CUMULATIVE = SUM(CASES) OVER (ORDER BY date_rep)  
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',  
                format='parquet') as a  
where geo_id = 'RS'  
order by date_rep


-- If we switch to chart we can see cumulative number of cases that are reported since the first COVID case. 
-- SQL language enables us to easily lookup number of reported cases couple of days after or before using LAG and LEAD functions. the following query will return number of cases reported 7 days ago:

select  TOP 10 date_rep,  
        cases,  
        prev = LAG(CASES, 7) OVER(partition by geo_id order by date_rep )  
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',  
                        format='parquet') as a  
where geo_id = 'RS'  
order by date_rep desc;


-- You can notice in the result that prev column lag 7 days to the current column. Now we can easily compare the difference between the current number of reported cases of the number of reported cases reported or percent of increase: 
-- ``` 
-- WoW% = (cases - prev) / prev 
--      = cases/prev - 1 
-- ``` 
-- Instead of simple comparison of current and previous value, we can make this more reliable and first calculate the average values in the 7-day windows and then calculate increase using these values:

with ecdc as (  
    select  
        date_rep,  
        cases = AVG(CASES) OVER(partition by geo_id order by date_rep ROWS BETWEEN 7 PRECEDING AND CURRENT ROW  ),  
        prev = AVG(CASES) OVER(partition by geo_id order by date_rep ROWS BETWEEN 14 PRECEDING AND 7 PRECEDING  )  
    from  
        openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',  
                    format='parquet') as a  
    where  
        geo_id = 'RS'  
)  
select date_rep, cases, prev, [WoW%] = 100*(1.0*cases/prev - 1)  
from ecdc  
where prev > 10  
order by date_rep asc;

-- This query will calculate the average number of cases in 7-day window and calculate week over week change. 
-- We can go step further and use the same query to run analysis across all countries in the world to calculate weekly changes and find the countries with the highest increase of COVID cases compared to the previous week.


with weekly_cases as (  
        select  geo_id, date_rep, country = countries_and_territories,  
                current_avg = AVG(CASES) OVER(partition by geo_id order by date_rep ROWS BETWEEN 7 PRECEDING AND CURRENT ROW  ),  
                prev_avg = AVG(CASES) OVER(partition by geo_id order by date_rep ROWS BETWEEN 14 PRECEDING AND 7 PRECEDING  )  
        from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',  
                             format='parquet') as a   
)  
select top 10   
    country,   
    current_avg,  
    prev_avg,   
    [WoW%] = CAST((100*(1.* current_avg / prev_avg - 1)) AS smallint)  
from weekly_cases  
where date_rep = CONVERT(date, DATEADD(DAY, -1, GETDATE()), 23)  
and prev_avg > 100  
order by (1. * current_avg / prev_avg -1)  desc
