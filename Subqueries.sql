/* Task: Find the products that have a price higher than the average price of all products. */
SELECT -- This is the mainquery
ProductID,
Price
FROM 
(SELECT
	ProductID,
	Product,
	Category,
	Price,
	AVG(Price) OVER () AvgPrice
FROM
	Sales.Products)t -- Subquery to calculate average price
WHERE
	Price > AvgPrice -- Filter products with price higher than average

-- Rank customers based on their total amount of slaes

SELECT
	CustomerID,
	TotalSales,
	RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM (
	SELECT
		CustomerID,
		SUM(Sales) AS TotalSales
	FROM
		Sales.Orders
	GROUP BY
		CustomerID
) AS CustomerSales -- Subquery to calculate total sales per customer

-- Show the productIDs, product names, prices, and the total number of orders

-- Using SELECT subquery to get the total number of orders

SELECT 
	ProductID,
	Product,
	Price,
	(SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders -- Subquery to count total number of orders
FROM
	Sales.Products ;


-- SUB QUERY within JOIN
-- Show all customer details and find the total orders for each customer
-- Step 1 - Show all customer details - Main Query

SELECT 
c.*,
o.TotalOrders
FROM Sales.Customers c
LEFT JOIN (

-- Step 2 - Find the total orders for each customer - Sub Query

SELECT
	CustomerID,
	COUNT(*) AS TotalOrders
FROM Sales.Orders 
GROUP BY CustomerID) o -- Sub Query to calculate total orders per customer
ON c.CustomerID = o.CustomerID; -- Join the main query with the sub query on CustomerID

-- SUBQUERY within WHERE CLAUSE
-- Find the products that have a price higher than the average price of all products

SELECT 
	ProductID,
	Product,
	Price
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products); -- Subquery to calculate average price and filter products with price higher than average

-- SUBQUERY using IN in WHERE CLAUSE
-- Show the details of orders made by customers in germany

SELECT 
	OrderID,
	ProductID,
	CustomerID,
	OrderDate,
	Sales
FROM Sales.Orders
	WHERE CustomerID IN (
		SELECT 
			CustomerID 
		FROM Sales.Customers 
		WHERE Country = 'Germany'
		); -- Subquery to get CustomerIDs of customers in Germany and filter orders based on those CustomerIDs

-- SUBQUERY using ALL & ANY in WHERE CLAUSE
-- Find female employees whose salaries are greater than the salaries of any male employees


SELECT 
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ANY (

SELECT Salary FROM Sales.Employees WHERE Gender = 'M' ) -- Subquery to get salaries of male employees

-- Find all the male employees whose salaries are greater than the salaries of female employees

SELECT 
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'M' AND Salary > ALL (

SELECT Salary FROM Sales.Employees WHERE Gender = 'F' ) -- Subquery to get salaries of male employees

-- SUBQUERY Dependency - non correlated subquery
-- Show all customer details and find the total orders for each customer

SELECT
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) AS TotalOrders -- Subquery to calculate total orders per customer

FROM Sales.Customers c

-- SUBQUERY Exists
-- Show the details of orders made by customers in germany

SELECT
	*
FROM Sales.Orders o
WHERE EXISTS (
	SELECT 1 
	FROM Sales.Customers c 
	WHERE c.Country = 'Germany' AND c.CustomerID = o.CustomerID 
); -- Subquery to check if there are any customers in Germany for each order and filter orders based on that condition

