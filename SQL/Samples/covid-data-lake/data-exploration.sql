
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


select continent = ISNULL(continent_exp, 'Total'), cases = sum(cases), deaths = sum(deaths)
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',
                format='parquet') as cases
group by continent_exp with rollup
order by sum(cases) desc

select countries_and_territories, geo_id
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',
                format='parquet') as cases
where countries_and_territories like '%ser%'


select DATE_REP, CASES, DEATHS
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',
                format='parquet') as a
where geo_id = 'RS'
order by date_rep

-- cumulative values - running total:
select DATE_REP, CASES,
        CUMULATIVE = SUM(CASES) OVER (ORDER BY date_rep)
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',
                format='parquet') as a
where geo_id = 'RS'
order by date_rep;

select  DATE_REP, 
        CASES,
        CASES_AVG = AVG(CASES) OVER(order by date_rep ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING  )
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet', format='parquet') as a
where geo_id = 'RS' order by date_rep;

with diff as (
        select  geo_id, date_rep, countries_and_territories,
                current_avg = AVG(CASES) OVER(partition by geo_id order by date_rep ROWS BETWEEN 7 PRECEDING AND CURRENT ROW  ),
                prev_avg = AVG(CASES) OVER(partition by geo_id order by date_rep ROWS BETWEEN 14 PRECEDING AND 7 PRECEDING  )
        from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet', format='parquet') as a
)
select  country = countries_and_territories,
        [cases/day (this week)] = current_avg,
        [cases/day (prev week)] = prev_avg, 
        [change%] = CAST( 100*(1.*current_avg / prev_avg - 1) AS NUMERIC(4,1))
from diff
where date_rep = CAST('2020-10-04T00:00:00.0000000' as datetime2)
and current_avg > prev_avg
and prev_avg > 100
order by (1. * current_avg / prev_avg -1)  desc
