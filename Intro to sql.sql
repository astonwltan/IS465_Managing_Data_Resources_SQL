-- Find first 100 rows of products
SELECT * -- * means "choose all columns and rows"; pick from the table
FROM products -- table to find the rows and columns; GPS to find the data
LIMIT 100 -- limit to the first x number of rows
; -- denotes the end of SELECT statement


-- Choose specific columns from the products table
SELECT
	product_name, -- commas separate columns
	product_id,
	category -- NO COMMA before FROM
FROM products
;


-- Find country and salespeople
SELECT
	country, 
	salesperson
FROM regions
;


-- Choose unique values and sort
SELECT DISTINCT -- DISTINCT gives me the unique composite values
	category,
	sub_category
FROM products
-- ORDER BY category DESC, sub_category -- order by sort and default to ascending (ASC), use DESC for descending
-- alternative
ORDER BY 1 DESC,2 -- sort by the column in the SELECT
;


-- Find all products that are furniture
SELECT
	product_name,
	category
FROM products
WHERE category = 'Furniture' -- filters on the rows, when evaluating a column that is text/string use quotes and it is case sensitive
;


-- Find all products that have a product cost >$100
SELECT
	product_name,
	category,
	product_cost_to_consumer
FROM products
WHERE product_cost_to_consumer >100
ORDER BY product_cost_to_consumer -- use sorting to help validate your data
;


-- Find the number of orders with sales over $100
SELECT
	COUNT(*) AS num_orders -- * counts all rows, AS lets you name column header (AKA Alias the column)
FROM orders
WHERE sales > 100 -- limiting to only rows where sales is over $100
;


-- Find all countries not in EMEA
SELECT DISTINCT 
	country,
	region
FROM regions
WHERE region != 'EMEA'
ORDER BY region
;


-- Find all countries and regions where the salesperson is not Anna Andreadi and only in the Americas or APAC
SELECT
	country,
	region,
	salesperson
FROM regions
WHERE (region = 'Americas' OR region = 'APAC') -- parentheses run first
AND salesperson != 'Anna Andreadi'
ORDER BY salesperson
;

