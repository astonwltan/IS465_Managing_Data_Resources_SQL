-- Using a subquery in the FROM similar to a temp table)
-- Average monthly sales by year
SELECT
	DATE_PART('year', order_month) AS yr, -- use the columns in the subquery
	AVG(monthly_sales) AS avg_monthly_sales
FROM
	(
		-- get the monthly sales
		SELECT
			DATE_TRUNC('month',order_date) as order_month,
			SUM(sales) as monthly_sales
		FROM orders
		GROUP BY 1
	) AS tmp
GROUP BY 1 -- groups on the yr column
ORDER BY 1 DESC
;


-- Classify customers as supplier, frequent or other
-- And get the total sales by the classifications
SELECT
	customer_type, SUM(total_sales) AS total_sales_by_type
FROM
			(
				SELECT
					customer_id,
					-- count the order by customer
					CASE WHEN COUNT(DISTINCT order_id)>1000 THEN 'Supplier'
						WHEN COUNT(DISTINCT order_id)>100 THEN 'Frequent'
					ELSE 'All Others' END AS customer_type, 
					SUM(sales) AS total_sales
				FROM orders
				GROUP BY 1	
			)	AS tmp
GROUP BY 1
ORDER BY 2 DESC
;


-- subqueries on a WHERE
-- How many orders have products with a cost of $500+
SELECT
	COUNT(*) AS num_orders
FROM orders
WHERE product_id IN
	(
		SELECT 
			product_id
		FROM products
		WHERE product_cost_to_consumer >= 500
	)
;


-- Subqueries in a WHERE
-- How many orders have a profit > the average cost to consumer
SELECT COUNT(*) as num_orders
FROM orders
WHERE profit >
	( -- find the products avg cost
		SELECT AVG(product_cost_to_consumer) FROM products
	)
;


-- Find the % of the total sales for each customer type

SELECT
	customer_type, SUM(total_sales) as total_sales_by_type,
	(SELECT SUM(sales) FROM orders) as total_table_sales,
	ROUND(SUM(total_sales)/(SELECT SUM(sales) FROM orders) *100,2) as percent_of_total_sales
FROM
		( -- count the order by customer
			SELECT customer_id,
			CASE WHEN COUNT(DISTINCT order_id)>= 1000 THEN 'Supplier'
				 WHEN COUNT(DISTINCT order_id)>= 100 THEN 'Frequent'
			ELSE 'All Others' END AS customer_type,
			SUM(sales) as total_sales
			FROM orders	
			GROUP BY 1
		) AS tmp
GROUP BY 1
ORDER BY 2 DESC
;


-- Use Case in subquery to classify profits and get number of orders

SELECT
	cst.segment,
	ord.ship_mode,
	tmp.profit_size, 
	COUNT(tmp.*) AS num_transactions
FROM
	( -- classify the profits
		SELECT 
			order_id,
			CASE WHEN profit >= 1000 THEN 'Large'
			WHEN profit >=40 THEN 'Medium'
			ELSE 'Small' END as profit_size
		FROM orders
	) AS tmp
JOIN orders ord ON tmp.order_id = ord.order_id
JOIN customers cst ON ord.customer_id =cst.customer_id
GROUP BY 1, 2, 3
;


-- Use Case in subquery to create binary values (T/F)

SELECT 
	AVG(over_25) AS pct_over_25
FROM
	(
		SELECT 
			order_id,
			discount,
			CASE WHEN discount > .25 THEN 1 ELSE 0 END AS over_25
		FROM orders
	) AS tmp
;
	

-- Using CTEs
WITH cte_customer AS
			( -- count the order by customer
			SELECT customer_id,
			CASE WHEN COUNT(DISTINCT order_id)>= 1000 THEN 'Supplier'
				 WHEN COUNT(DISTINCT order_id)>= 100 THEN 'Frequent'
			ELSE 'All Others' END AS customer_type,
			SUM(sales) as total_sales
			FROM orders	
			GROUP BY 1
		)

SELECT
	customer_type, SUM(total_sales) as total_sales_by_type,
-- 	(SELECT SUM(sales) FROM orders) as total_orders_table_sales, to demonstrate total
	ROUND(SUM(total_sales) / (SELECT SUM(sales) FROM orders) *100 ,2) as percent_of_total_sales
FROM cte_customer
GROUP BY 1