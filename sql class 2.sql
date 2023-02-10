-- Find all products in furniture and tech
SELECT
	product_name,
	category
FROM products
WHERE -- category = 'Furniture' OR category = 'Technology'
	category IN ('Furniture', 'Technology')  -- streamlined ways to find rows that meet at least 1 criteria for a column
;


-- Find all products NOT in furniture and tech
SELECT
	product_name,
	category
FROM products
WHERE -- NOT (category = 'Furniture' OR category = 'Technology')
	category NOT IN ('Furniture', 'Technology')  -- streamlined ways to find rows that meet at least 1 criteria for a column
;


-- Find all products with a cost to consumer between $25 and $100
SELECT
	product_name,
	product_cost_to_consumer
FROM products
WHERE product_cost_to_consumer BETWEEN 25 AND 100 -- BETWEEN includes boundary values if in the data
ORDER BY product_cost_to_consumer DESC
;


-- Find orders in Q1 2019
SELECT * -- asterisk indicates looking for everything
FROM orders
WHERE order_date BETWEEN '2019-01-01' AND '2019-03-31'
ORDER BY order_date DESC
;


-- Find all calculators that we offer for sale
SELECT 
	product_name
FROM products
WHERE
	-- product_name LIKE 'Calculator%' -- % at the back = Starts With
	-- product_name LIKE '%Calculator' -- % at the front = Ends With
	-- product_name LIKE '%Calculator%' -- % at the front and back = contains
	product_name ILIKE '%Calculator%' -- ILIKE ignores case sensitivity
;

-- How many countries are in the "Americas" region?
SELECT * 
	
FROM regions
WHERE region ILIKE 'Americas'
; -- 29 rows

SELECT count(country) 
FROM regions
WHERE region ILIKE '%Americas%'
; -- Validate count

-- Which tech products are sold to consumers for more than $1,000?
SELECT
	product_name,
	category,
	product_cost_to_consumer
FROM products
WHERE category IN ('Technology') AND product_cost_to_consumer >1000
ORDER BY product_cost_to_consumer
;



-- How many product items were returned in 2019 for unknown reasons?


-- looking at discount levels
SELECT DISTINCT -- use distinct to test the case
	discount, -- use to test
	CASE
		WHEN discount = 1 THEN 'FREE'
		WHEN discount = 0 THEN 'None'
		WHEN discount >= .25 THEN 'High' -- note: 1 is handled above so this goes from .25 to .999999~
		WHEN discount < .25 THEN 'Low' -- note: zeros handled above
	END as discount_level	
FROM orders
ORDER BY discount
;


-- The number of orders placed on March 31, 2019
Select count(*)
FROM orders
WHERE order_date = '2019-03-31'
;


-- The highest profit for orders shipped via Standard Class
SELECT MAX(profit)
FROM orders
WHERE ship_mode = 'Standard Class'
GROUP BY ship_mode -- Groups to understand how to display if you SELECT more columns
;


-- Aggregate functions

-- The typical quantity of product id
SELECT AVG(quantity)
	product_id,
	quantity
FROM orders
WHERE product_id ILIKE 'TEC-BRO-10000381'
GROUP BY quantity
;


-- Calculate the % of orders with a high discount

SELECT
	AVG(
	CASE WHEN discount > .25 THEN 1 ELSE 0 END)
	as disc_level
FROM orders
;


-- Find the number of customers by segment
SELECT
	segment, -- dimension to group on; similar to rows of a pivot table
	COUNT (*) as num_customers
FROM customers
GROUP BY segment
;


-- Find the number of customers by segment
SELECT
	segment, -- dimension to group on; similar to rows of a pivot table
	COUNT (*) as num_customers
FROM customers
GROUP BY segment
HAVING COUNT (*) > 300
;


-- Find the number of products by category in the Superstore data set
SELECT category,
	COUNT (*) as num_products
FROM products
GROUP BY category
;


-- Include only products with "computer or "color" (case-insensitive) in the name
-- Further refine to those that have an aggregate 100 or more products
-- Alias your aggregate column to "count_of_products."
-- Sort the results by the "count_of_products" column
-- Limit the output to the first 10 rows

SELECT category,
	COUNT (*) as num_products,
FROM products
WHERE (product_name ILIKE '%computer%') OR (product_name ILIKE '%color%')
GROUP BY category
HAVING COUNT(*) > 100
ORDER BY 2 DESC
LIMIT 10
;
