with
raw_data as (
select DATE_REP, CASES,
         DEATHS = LAG(DEATHS, 9) OVER (ORDER BY date_rep desc)
from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet',
                format='parquet') as a
where geo_id = 'UK'
and date_rep between '2020-03-03' and '2020-06-06'
),
data as ( select x = CAST(CASES AS BIGINT), y = CAST(DEATHS AS INT) FROM raw_data )
select PearsonsR = (Avg(x * y) - (Avg(x) * Avg(y))) / (StDevP(x) * StDevP(y))
from data



with
raw_data as (
        select  geo_id, date_rep, countries_and_territories,
                deaths = AVG(deaths) OVER(partition by geo_id order by date_rep ROWS BETWEEN 3 PRECEDING AND CURRENT ROW  ),
                cases = AVG(cases) OVER(partition by geo_id order by date_rep desc ROWS BETWEEN 11 PRECEDING AND 7 PRECEDING  )
        from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet', format='parquet') as a
),
data as ( 
    select
        x = CAST(cases AS BIGINT),
        y = CAST(deaths AS BIGINT)
    from raw_data where cases > 100 and deaths > 10 
)
SELECT PearsonsR = (Avg(x * y) - (Avg(x) * Avg(y))) / (StDevP(x) * StDevP(y)),
       SpearmanRho = 1 - (6 * SUM(POWER(x - y, 2))) / CONVERT(NUMERIC(36, 2), (COUNT(*) * (POWER(COUNT_BIG(*), 2) - 1)))
FROM data;

--Kendall's rank correlation sample estimate τ
with
raw_data as (
        select  geo_id, date_rep, countries_and_territories,
                deaths = AVG(deaths) OVER(partition by geo_id order by date_rep ROWS BETWEEN 3 PRECEDING AND CURRENT ROW  ),
                cases = AVG(cases) OVER(partition by geo_id order by date_rep desc ROWS BETWEEN 11 PRECEDING AND 7 PRECEDING  )
        from openrowset(bulk 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/ecdc_cases/latest/ecdc_cases.parquet', format='parquet') as a
),
data as ( 
    select
        x = CAST(cases AS BIGINT),
        y = CAST(deaths AS BIGINT),
        class = geo_id,
        id = date_rep
    from raw_data where cases > 100 and deaths > 10 
)
SELECT 
    CONVERT(NUMERIC(8,2),(SUM(CASE WHEN (i.x < j.x AND i.y < j.y) OR (i.x > j.x AND i.y > j.y) THEN 1 ELSE 0 END)) -- concordant
    - SUM(CASE WHEN (i.x < j.x AND i.y > j.y) OR (i.x > j.x AND i.y < j.y) THEN 1 ELSE 0 END)) -- discordant
    /COUNT(*) AS Tau
FROM  data i CROSS JOIN data j
WHERE i.class = j.class
AND i.id<>j.id
