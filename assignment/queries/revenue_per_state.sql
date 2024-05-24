-- TODO: This query will return a table with two columns; customer_state, and 
-- Revenue. The first one will have the letters that identify the top 10 states 
-- with most revenue and the second one the total revenue of each.
-- HINT: All orders should have a delivered status and the actual delivery date 
-- should be not null. 
SELECT oc.customer_state,
SUM(oop.payment_value) as Revenue 
FROM
    olist_order_payments oop
JOIN 
	olist_orders oo 
ON 
	oop.order_id = oo.order_id
JOIN olist_customers oc 
ON oc.customer_id = oo.customer_id 
WHERE 
	oo.order_status = 'delivered' and oo.order_delivered_customer_date is not null
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10