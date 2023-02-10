-- Advanced Joins


-- Products returned without a given reason in 2020; show all orders even if not returned
SELECT
	rtn.reason_returned,
	ord.order_id,
	ord.product_id
FROM returns rtn
RIGHT JOIN orders ord -- Orders it the table on the right so we want to get all orders
	ON rtn.order_id = ord.order_id
; -- convert right join to a left


-- Exception Join returns only the data from the primary table selected that doesn't have matching data to JOIN to in the secondary table
-- Find products that have not sold in 2019
SELECT product_id, product_name
FROM products
WHERE category = 'Furniture'

EXCEPT

SELECT product_id, '' as product_name -- columns need to match up
FROM orders
WHERE DATE_PART('year', order_date) = 2019

ORDER BY 1


-- Dealing with NULLs in SQL
-- Find NULLs in the WHERE

SELECT DISTINCT
	postal_code
FROM orders
WHERE postal_code IS NOT NULL -- IS or IS NOT NULL
;


-- the number of sales each salesperson made, based on orders that were not returned

SELECT 
	salesperson, 
	COUNT(*) -- or COUNT(sales)
FROM orders ord
JOIN regions rgn
	on ord.region_id = rgn.region_id
JOIN returns rtn
	on ord.order_id = rtn.order_id -- Inner join think middle of Venn diagram
GROUP BY salesperson -- GROUP BY needed because of aggregation (COUNT)
;


-- NULLIF, COALESCE, CASE
-- NULLIF, If I have a value, turn it into a NULL
SELECT
	product_id,
	quantity,
	discount,
	NULLIF(discount,0),
	quantity/NULLIF(discount,0) as disc_per_item
FROM orders
WHERE ship_mode = 'Standard Class'
;


-- Handle zeros with CASE
SELECT
	quantity,
	discount,
	ROUND (CASE WHEN discount = 0 THEN NULL
	ELSE quantity/discount
	END, 2) as disc_per_item
FROM orders
WHERE ship_mode = 'Standard Class'
ORDER BY 2 DESC
;


-- COALESCE
SELECT DISTINCT
	postal_code,
	region_id,
	COALESCE (postal_code, region_id::text,'missing') as new_zip -- cast region_id to text
FROM orders
WHERE postal_code IS NULL AND region_id IS NULL
;