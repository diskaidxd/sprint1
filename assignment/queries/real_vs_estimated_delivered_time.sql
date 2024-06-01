-- TODO: This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. It will have different 
-- columns: month_no, with the month numbers going from 01 to 12; month, with 
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with 
-- the average delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if 
-- it doesn't exist); Year2018_real_time, with the average delivery time per 
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the 
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_estimated_time, with the average estimated delivery time per month 
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the 
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
-- HINTS
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.
WITH real_times AS (
    SELECT 
        order_id,
        STRFTIME('%m', order_purchase_timestamp) AS month_no,
        STRFTIME('%Y', order_purchase_timestamp) AS year,
        julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp) AS real_time
    FROM 
        olist_orders
    WHERE 
        order_status = 'delivered'
        AND order_delivered_customer_date IS NOT NULL
),
real_times_agg AS (
    SELECT 
        month_no,
        year,
        AVG(real_time) AS avg_real_time
    FROM 
        real_times
    GROUP BY 
        month_no, year
),
estimated_times AS (
    SELECT 
        order_id,
        STRFTIME('%m', order_purchase_timestamp) AS month_no,
        STRFTIME('%Y', order_purchase_timestamp) AS year,
        julianday(order_estimated_delivery_date) - julianday(order_purchase_timestamp) AS estimated_time
    FROM 
        olist_orders
    WHERE 
        order_status = 'delivered'
        AND order_estimated_delivery_date IS NOT NULL
),
estimated_times_agg AS (
    SELECT 
        month_no,
        year,
        AVG(estimated_time) AS avg_estimated_time
    FROM 
        estimated_times
    GROUP BY 
        month_no, year
)
SELECT
    all_months.month_no,
    CASE
        all_months.month_no
        WHEN '01' THEN 'Jan'
        WHEN '02' THEN 'Feb'
        WHEN '03' THEN 'Mar'
        WHEN '04' THEN 'Apr'
        WHEN '05' THEN 'May'
        WHEN '06' THEN 'Jun'
        WHEN '07' THEN 'Jul'
        WHEN '08' THEN 'Aug'
        WHEN '09' THEN 'Sep'
        WHEN '10' THEN 'Oct'
        WHEN '11' THEN 'Nov'
        WHEN '12' THEN 'Dec'
    END AS month,
    AVG(CASE WHEN rt.year = '2016' THEN rt.avg_real_time END) AS Year2016_real_time,
    AVG(CASE WHEN rt.year = '2017' THEN rt.avg_real_time END) AS Year2017_real_time,
    AVG(CASE WHEN rt.year = '2018' THEN rt.avg_real_time END) AS Year2018_real_time,
    AVG(CASE WHEN et.year = '2016' THEN et.avg_estimated_time END) AS Year2016_estimated_time,
    AVG(CASE WHEN et.year = '2017' THEN et.avg_estimated_time END) AS Year2017_estimated_time,
    AVG(CASE WHEN et.year = '2018' THEN et.avg_estimated_time END) AS Year2018_estimated_time
FROM
    (
    SELECT
        '01' AS month_no
    UNION
    SELECT
        '02'
    UNION
    SELECT
        '03'
    UNION
    SELECT
        '04'
    UNION
    SELECT
        '05'
    UNION
    SELECT
        '06'
    UNION
    SELECT
        '07'
    UNION
    SELECT
        '08'
    UNION
    SELECT
        '09'
    UNION
    SELECT
        '10'
    UNION
    SELECT
        '11'
    UNION
    SELECT
        '12'
    ) AS all_months
LEFT JOIN real_times_agg rt ON all_months.month_no = rt.month_no AND rt.year IN ('2016', '2017', '2018')
LEFT JOIN estimated_times_agg et ON all_months.month_no = et.month_no AND et.year IN ('2016', '2017', '2018')
GROUP BY
    all_months.month_no
ORDER BY
    all_months.month_no;
