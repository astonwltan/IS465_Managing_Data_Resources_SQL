-- Math functions/Summary (Descriptive Stats) Stats
SELECT
	COUNT(*) AS count_all_rows_includes_null,
	COUNT(postal_code) AS count_not_null_values,
	COUNT (DISTINCT postal_code) AS count_unique_not_null_values,
	
	SUM(sales) AS total_sales,
	MIN(sales) AS smallest_value,
	MAX(sales) AS largest_value,

	AVG(sales) AS avg_sales,
	ROUND(AVG(sales),2) AS avg_sales_rounded
FROM orders
;


-- Rounding in SQL
SELECT 177.3589;
SELECT ROUND(177.3589,2); -- rounds to the right of the decimal because the 2 is positive
SELECT ROUND(177.3589,-1); -- rounds to the left of the decimal because the 1 is negative


-- Integer and Decimal Math
SELECT 3+5;
SELECT 3*5;
SELECT 5/3;

-- Fix division of integers (CASTING)
SELECT CAST(5 as float)/3;
SELECT 5.0/3;
SELECT (1.0*5)/3;
SELECT 5::decimal/3; -- Preferred method for developers


-- Which shipping class has the highest quantity of shipped items?
SELECT 
	ship_mode, 
	SUM(quantity) AS number_of_items
FROM orders
GROUP BY ship_mode
ORDER BY SUM(quantity) DESC
LIMIT 1
;


-- How many orders had three or more items returned?
SELECT COUNT(*)
FROM returns
WHERE return_quantity >=3
;


-- What's the least expensive subcategory of products?
SELECT
	sub_category,
	MIN(product_cost_to_consumer)
FROM products
GROUP BY sub_category
ORDER BY Min(product_cost_to_consumer)
Limit 1


-- using CONCAT (concatenate fields)
SELECT DISTINCT
	category,
	sub_category,
	CONCAT(category, ' - ', sub_category) AS cat_category, -- ANSI method
	category || ' - ' || sub_category AS cat_pipes -- Preferred developer method
FROM products
;


-- using LENGTH (counts the number or bytes/characters in the text)
SELECT DISTINCT
	LENGTH (category),
	LENGTH (sub_category),
	LENGTH (category || ' - ' || sub_category) AS cat_pipes -- spaces count
FROM products
;


-- using REPLACE (replaces text with something else)
SELECT DISTINCT
	category,
	REPLACE (category, 'Supplies', 'Stuff')
FROM products
;


-- using LOWER/UPPER
SELECT DISTINCT
	category,
	UPPER(category),
	LOWER(category)
FROM products
;


-- using LEFT/RIGHT
SELECT DISTINCT
	category,
	LEFT(category,3),
	RIGHT(category,3),
	product_name,
	LEFT(product_name,3) as VENDOR
FROM products
LIMIT 50
;


-- STRPOS to find position of a character
-- SUBSTRING parse specific characters with a start and end position
SELECT DISTINCT
	product_name,
	STRPOS(product_name, ',') AS position_of_comma,
	SUBSTRING(product_name,1,5) AS left_5,
	SUBSTRING(product_name,5,5) AS start_5_pull_next_5 -- MID function
FROM products
LIMIT 100
;


-- Parse manuf and vend
SELECT product_id,
SUBSTRING(product_id,1,3) as manuf,
SUBSTRING(product_id,5,3) as vend
FROM products
LIMIT 100
;


SELECT DISTINCT
	product_name,
	STRPOS(product_name,',') position_of_comma,
	CASE WHEN STRPOS(product_name,',') = 0 Then product_name
		ELSE SUBSTRING(product_name,1,STRPOS(product_name,',')-1) -- use -1 to go back a space to exclude the comma
	END AS parse_at_comma_and_handle_0s
FROM products
Limit 100
;


-- Date Functions - Part 1
SELECT DISTINCT
	CURRENT_DATE,
	order_date,
	ship_date,
	AGE(ship_date,order_date) as date_diff_interval, -- newer date - older date
	DATE(ship_date) - DATE(order_date) AS date_diff_num -- returns numeric value
FROM orders
;


-- Date Functions - Part 2
SELECT DISTINCT
	DATE_PART('month', order_date) as order_month,
	TO_CHAR(order_date, 'MONTH') as order_month_char,
	TO_CHAR(order_date, 'MON') as order_month_char,
	
	DATE_TRUNC('year', order_date) as order_year,
	TO_CHAR(DATE_TRUNC('year', order_date),'YYYY-MM') as order_year_char
FROM orders
ORDER BY 1
;