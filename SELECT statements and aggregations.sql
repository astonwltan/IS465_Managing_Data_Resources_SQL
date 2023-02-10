/* SQL Class 1 */

SELECT customername, creditlimit
FROM customers
WHERE creditlimit > 80000
;

SELECT employeenumber, firstname, lastname, reportsto
FROM employees
WHERE reportsto = 1002
;

SELECT employeenumber, firstname, lastname, jobtitle
FROM employees
WHERE jobtitle ILIKE '%VP%' OR jobtitle ILIKE '%Manager%'
;

/* ILIKE is case insensitive */

SELECT productcode, productname, productline
FROM products
WHERE productline ILIKE 'Classic Cars'
;

SELECT AVG(buyprice) AS "Average Price"
FROM products
;

SELECT productname, productvendor, (buyprice/msrp) AS "Price Fraction"
FROM products
WHERE productvendor ILIKE 'Exoto Designs'
;


------------------------------------------------

SELECT *
FROM orders
ORDER BY orderdate
;

/* Date - 'yyyy-mm-dd' */

SELECT *
FROM orders
WHERE orderdate :: text LIKE '2003%'
ORDER BY orderdate
;

SElECT *
FROM orders
WHERE orderdate :: text LIKE '2005%'
ORDER BY status, orderdate
;

--------------------------------------------------

/* JOINS */

SELECT customers.customername,
	employees.firstname,
	employees.lastname,
	offices.city,
	offices.state
FROM employees 
	JOIN customers ON customers.salesrepemployeenumber = employees.employeenumber
	JOIN offices ON employees.officecode = offices.officecode
;

/* OUTER JOINS */

-- Shows customers that made orders and also customers that haven't made orders
SELECT customers.customernumber,
	customers.customername,
	orders.ordernumber
FROM customers 
	LEFT OUTER JOIN orders ON customers.customernumber = orders.customernumber
;

SELECT customers.customernumber,
	customers.customername,
	orders.ordernumber,
	customers.country
FROM customers 
	LEFT OUTER JOIN orders ON customers.customernumber = orders.customernumber
WHERE customers.country ILIKE 'USA'
;

----------------------------------------------

SELECT 
	productname,
	buyprice
FROM products	
WHERE 
	productline IN ('Classic Cars')
	AND buyprice = 
		(SELECT MAX(buyprice)
		 FROM products
		 WHERE productline IN ('Classic Cars')
		)
;

SELECT customers.customernumber
	FROM customers
	WHERE customers.customernumber NOT IN 
		(SELECT DISTINCT orders.customernumber
			FROM products
				JOIN orderdetails ON products.productcode = orderdetails.productcode
				JOIN orders ON orderdetails.ordernumber = orders.ordernumber
			WHERE products.productline = 'Classic Cars'
		)
;

SELECT COUNT(customername),
	country
FROM customers c
GROUP BY country
HAVING COUNT(*)>=5
;

SELECT 
	COUNT(*),
	of.officecode,
	of.city
FROM orders od, customers c, employees e, offices of
WHERE od.customernumber = c.customernumber
	AND c.salesrepemployeenumber = e.employeenumber
	AND e.officecode = of.officecode
GROUP BY of.officecode, of.city
ORDER BY of.officecode ASC
;

--------------------------------------------------------------

SELECT e2.firstname,
	e2.lastname,
	e2.reportsto,
	e1.firstname,
	e1.lastname
FROM employees e1, employees e2
WHERE e1.employeenumber = e2.reportsto
	AND e1.firstname = 'Anthony'
	AND e1.lastname = 'Bow'
;

SELECT 
customers.customername,
payments.paymentdate,
payments.amount
FROM payments,customers
WHERE 
	payments.customernumber = customers.customernumber
	AND amount > 100000
ORDER BY payments.amount DESC
;