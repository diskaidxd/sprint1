-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).
WITH revenue_2016 AS (SELECT
    STRFTIME('%m', sub.order_delivered_customer_date) as month_no,
    SUM(sub.payment_value) AS total_payment_value
FROM
    (
    SELECT
        oop.order_id,
        oop.payment_value,
        oo.order_delivered_customer_date
    FROM
        olist_order_payments oop
    JOIN
        olist_orders oo ON
        oop.order_id = oo.order_id
    WHERE
        STRFTIME('%Y', oo.order_delivered_customer_date) = '2016'
        AND oo.order_status = 'delivered'
    GROUP BY
        oop.order_id
) AS sub
GROUP BY 
    month_no
),
revenue_2017 AS (SELECT
    STRFTIME('%m', sub.order_delivered_customer_date) as month_no,
    SUM(sub.payment_value) AS total_payment_value
FROM
    (
    SELECT
        oop.order_id,
        oop.payment_value,
        oo.order_delivered_customer_date
    FROM
        olist_order_payments oop
    JOIN
        olist_orders oo ON
        oop.order_id = oo.order_id
    WHERE
        STRFTIME('%Y', oo.order_delivered_customer_date) = '2017'
        AND oo.order_status = 'delivered'
    GROUP BY
        oop.order_id
) AS sub
GROUP BY 
    month_no
),
revenue_2018 AS (SELECT
    STRFTIME('%m', sub.order_delivered_customer_date) as month_no,
    SUM(sub.payment_value) AS total_payment_value
FROM
    (
    SELECT
        oop.order_id,
        oop.payment_value,
        oo.order_delivered_customer_date
    FROM
        olist_order_payments oop
    JOIN
        olist_orders oo ON
        oop.order_id = oo.order_id
    WHERE
        STRFTIME('%Y', oo.order_delivered_customer_date) = '2018'
        AND oo.order_status = 'delivered'
    GROUP BY
        oop.order_id
) AS sub
GROUP BY 
    month_no
)

SELECT
    all_months.month_no,
    substr('--JanFebMarAprMayJunJulAugSepOctNovDec',(all_months.month_no * 3 ) ,3) AS month,
    COALESCE(rv16.total_payment_value, 0) AS Year2016,
    COALESCE(rv17.total_payment_value, 0) AS Year2017,
    COALESCE(rv18.total_payment_value, 0) AS Year2018
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
        '12') AS all_months
LEFT JOIN revenue_2016 rv16 ON
    all_months.month_no = rv16.month_no
LEFT JOIN revenue_2017 rv17 ON
    all_months.month_no = rv17.month_no
LEFT JOIN revenue_2018 rv18 ON
    all_months.month_no = rv18.month_no
ORDER BY
    all_months.month_no;
