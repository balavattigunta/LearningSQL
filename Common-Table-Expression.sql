-- CTE - Common Table Expression
-- Step 1 : Find the total sales per customer from the Orders table (standalone CTE)

WITH CTE_TotalSales AS (
SELECT
	CustomerID,
	SUM(Sales) AS TotalSales
FROM
	Sales.Orders
	GROUP BY CustomerID
)
-- Find the last order date for each customer (Standalone CTE)
, CTE_LastOrderDate AS (
SELECT
	CustomerID,
	MAX(OrderDate) AS LastOrderDate
FROM
	Sales.Orders
	GROUP BY CustomerID
)
-- Rank Customers based on total sales per customer (Nested CTE)
, CTE_CustomerRank AS (
SELECT
	CustomerID,
	TotalSales,
	RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM CTE_TotalSales
)

-- Segment customers based on their total sales (Nested CTE)
,CTE_CustomerSegment AS (
SELECT
	CustomerID,
	TotalSales,
	CASE 
		WHEN TotalSales >= 100 THEN 'High'
		WHEN TotalSales >= 50 THEN 'Medium'
		ELSE 'Low'
	END AS CustomerSegment
FROM CTE_TotalSales
)
-- Main Query

SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.TotalSales,
	cld.LastOrderDate,
	ccr.SalesRank,
	ccs.CustomerSegment
	
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cts ON c.CustomerID = cts.CustomerID
LEFT JOIN CTE_LastOrderDate cld ON c.CustomerID = cld.CustomerID
LEFT JOIN CTE_CustomerRank ccr ON c.CustomerID = ccr.CustomerID
LEFT JOIN CTE_CustomerSegment ccs ON c.CustomerID = ccs.CustomerID
ORDER BY ccr.SalesRank;

-- RECURSIVE CTE - Generate a sequence of numbers from 1 to 20


WITH Series AS (
-- Anchor Query
SELECT 
	1 AS MyNumber

UNION ALL

-- Recursive Query

SELECT 
	MyNumber + 1
FROM Series
WHERE MyNumber < 120
)
-- Main Query

SELECT
	MyNumber
FROM Series
OPTION (MAXRECURSION 0); -- Remove the default recursion limit of 100

-- Show the hierarchy of employees and their managers using a recursive CTE

WITH CTE_EmployeeHierarchy AS (
-- Anchor Query: Manager with no manager (top-level)
SELECT
	EmployeeID,
	FirstName,
	LastName,
	ManagerID,
	1 AS Level
FROM Sales.Employees
WHERE ManagerID IS NULL

UNION ALL	

-- Recursive Query: Employees reporting to the manager

SELECT
	e.EmployeeID,
	e.FirstName,
	e.LastName,
	e.ManagerID,
	Level + 1
FROM Sales.Employees e
INNER JOIN CTE_EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)

-- Main Query
SELECT
	EmployeeID,
	FirstName,
	LastName,
	ManagerID,
	Level
FROM CTE_EmployeeHierarchy