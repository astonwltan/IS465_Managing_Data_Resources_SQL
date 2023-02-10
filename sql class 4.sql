SELECT -- designate columns we want returned, specifying the table from which they came
	orders.sales,
	regions.region
FROM
	orders -- Name the primary table from which we're pulling data
JOIN
	regions 
ON
	orders.region_id =
	regions.region_id


-- Find orders that have returns only, if no returns order not pulled from the data
SELECT
	orders.order_date,
	orders.order_id,
	returns.reason_returned,
	SUM(orders.sales)
FROM orders
JOIN returns -- JOIN is the same as INNER JOIN
	ON orders.order_id = returns.order_id -- INNER JOIN gives only where the order_id matches in both tables

GROUP BY 1, 2, 3
ORDER BY 1, 2, 3
;


-- Find orders that have returns only, if no returns order not pulled from the data
-- Using aliases
SELECT
	ord.order_date,
	ord.order_id,
	rtn.reason_returned,
	SUM(ord.sales)
FROM orders AS ord -- ord is the alias for orders, AS is optional
JOIN returns rtn -- rtn is the alias for returns
	ON ord.order_id = rtn.order_id -- INNER JOIN gives only where the order_id matches in both tables

GROUP BY 1, 2, 3
ORDER BY 1, 2, 3
;


-- Find orders that have returns only, if no returns order not pulled from the data
-- Using aliases
-- Add customer name
-- Add region
SELECT
	ord.order_date,
	ord.order_id,
	rtn.reason_returned,
	cst.customer_name,
	rgn.region,
	SUM(ord.sales)
FROM orders ord -- ord is the alias for orders
JOIN returns rtn -- rtn is the alias for returns
	ON ord.order_id = rtn.order_id -- INNER JOIN gives only where the order_id matches in both tables
JOIN customers cst
	ON cst.customer_id = ord.customer_id -- join to orders because that's where the keys are in orders and customers
JOIN regions rgn
	ON rgn.region_id = ord.region_id
GROUP BY 1, 2, 3, 4, 5
ORDER BY 1, 2, 3, 4, 5
;


-- Finds all orders and if a return, will show the reason
SELECT
	ord.order_date,
	ord.order_id,
	rtn.reason_returned, -- due to LEFT JOIN if no return we will a a null value
	SUM(ord.sales)
FROM orders AS ord
LEFT JOIN returns rtn  -- Returns all rows in orders and if there is a return we get the value in returns (rtn.return_reason)
	ON ord.order_id = rtn.order_id
GROUP BY 1,2,3
ORDER BY 1,2,3
;


-- Union
SELECT
	region,
	sub_region
FROM regions
WHERE sub_region = 'Central United States'

UNION -- stacks row and removes composite duplicates

SELECT
	region,
	sub_region
FROM regions
WHERE sub_region = 'Caribbean'
;