SELECT c.id, 
	c.first_name, 
	c.country, 
	o.order_id, 
	o.order_date, 
	o.sales  
FROM customers AS c
INNER JOIN orders AS o ON c.id = o.customer_id ;

SELECT c.id, 
	c.first_name, 
	c.country, 
	o.order_id, 
	o.order_date, 
	o.sales  
FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.customer_id ;

SELECT c.id, 
	c.first_name, 
	c.country, 
	o.order_id, 
	o.order_date, 
	o.sales  
FROM customers AS c
RIGHT JOIN orders AS o ON c.id = o.customer_id ;

SELECT c.id, 
	c.first_name, 
	c.country, 
	o.order_id, 
	o.order_date, 
	o.sales  
FROM orders AS o
LEFT JOIN customers AS c ON o.customer_id = c.id ;


SELECT c.id, 
	c.first_name, 
	c.country, 
	o.order_id, 
	o.order_date, 
	o.sales  
FROM customers AS c
FULL JOIN orders AS o ON c.id = o.customer_id ;


SELECT c.id, 
	c.first_name, 
	c.country, 
	o.order_id, 
	o.order_date, 
	o.sales  
FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.customer_id 
WHERE o.customer_id IS NULL;

SELECT c.id, 
	c.first_name, 
	c.country, 
	o.order_id, 
	o.order_date, 
	o.sales  
FROM customers AS c
RIGHT JOIN orders AS o ON c.id = o.customer_id 
WHERE c.id IS NULL;

SELECT c.id, 
	c.first_name, 
	c.country, 
	o.order_id, 
	o.order_date, 
	o.sales  
FROM orders AS o
LEFT JOIN customers AS c ON o.customer_id = c.id 
WHERE c.id IS NULL;

SELECT c.id, 
	c.first_name, 
	c.country, 
	o.order_id, 
	o.order_date, 
	o.sales  
FROM customers AS c
FULL JOIN orders AS o ON c.id = o.customer_id 
WHERE o.customer_id IS NULL OR c.id IS NULL ;

SELECT c.id, 
	c.first_name, 
	c.country, 
	o.order_id, 
	o.order_date, 
	o.sales  
FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.customer_id 
WHERE o.customer_id IS NOT NULL;
