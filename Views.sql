-- Find the running total of sales for each month
WITH CTE_RunningTotals AS (
SELECT
	DATETRUNC(MONTH, OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrders,
	SUM(Quantity) TotalQuantities

FROM Sales.Orders
GROUP BY DATETRUNC(MONTH, OrderDate)
)
SELECT 
OrderMonth,
TotalSales,
SUM(TotalSales) OVER (ORDER BY OrderMonth) CumulativeSales,
TotalOrders,
SUM(TotalOrders) OVER (ORDER BY OrderMonth) CumulativeOrders,
TotalQuantities,
SUM(TotalQuantities) OVER (ORDER BY OrderMonth) CumulativeQty

FROM CTE_RunningTotals

-- Creating a view for monthly summary
IF OBJECT_ID('Sales.v_monthly_summary', 'V') IS NOT NULL -- Check if the view already exists
	DROP VIEW Sales.v_monthly_summary; -- Drop the view if it exists to avoid errors when creating it again
GO
CREATE VIEW Sales.v_monthly_summary AS (
	SELECT
		DATETRUNC(MONTH, OrderDate) OrderMonth,
		SUM(Sales) TotalSales,
		COUNT(OrderID) TotalOrders,
		SUM(Quantity) TotalQuantities
	FROM Sales.Orders
	GROUP BY DATETRUNC(MONTH, OrderDate)
)

-- Using view to pull the running totals from the monthly summary

SELECT 
	OrderMonth,
	TotalSales,
	SUM(TotalSales) OVER (ORDER BY OrderMonth) CumulativeSales,
	TotalOrders,
	SUM(TotalOrders) OVER (ORDER BY OrderMonth) CumulativeOrders,
	TotalQuantities,
	SUM(TotalQuantities) OVER (ORDER BY OrderMonth) CumulativeQty
FROM Sales.v_monthly_summary

-- View task - Provide a view that combines details from the orders, products, customers and employees

IF OBJECT_ID('Sales.v_combined_details', 'V') IS NOT NULL -- Check if the view already exists
	DROP VIEW Sales.v_combined_details; -- Drop the view if it exists to avoid errors when creating it again
GO
CREATE VIEW Sales.v_combined_details AS (
	SELECT 
		-- c.CustomerID,
		COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') AS CustomerName,
		c.Score AS CustScore,
		c.Country AS CustCountry,
		-- e.EmployeeID,
		COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') AS EmpName,
		e.Gender AS EmpGender,
		e.BirthDate AS EmpDOB,
		e.ManagerID AS EmpMgrID,
		e.Department AS EmpDept,
		e.Salary AS EmpSalary,
		o.OrderID,
		-- p.ProductID,
		p.Product,
		p.Category AS ProdCategory,
		p.Price AS ProdPrice,
		o.Sales,
		o.Quantity,
		o.OrderDate,
		o.ShipDate,
		o.OrderStatus,
		o.CreationTime AS OrdTime

	FROM Sales.Orders o
	LEFT JOIN Sales.Products p ON o.ProductID = p.ProductID
	LEFT JOIN Sales.Customers c ON o.CustomerID = c.CustomerID
	LEFT JOIN Sales.Employees e ON o.SalesPersonID = e.EmployeeID
)

-- Querying the combined details view

SELECT *
FROM sales.v_combined_details

-- Provide a viw for EU Sales Team
-- That combines details from all tables and excludes data related to the USA

IF OBJECT_ID('Sales.v_eu_combined_details', 'V') IS NOT NULL -- Check if the view already exists
	DROP VIEW Sales.v_eu_combined_details; -- Drop the view if it exists to avoid errors when creating it again
GO
CREATE VIEW Sales.v_eu_combined_details AS (
	SELECT 
		-- c.CustomerID,
		COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') AS CustomerName,
		c.Score AS CustScore,
		c.Country AS CustCountry,
		-- e.EmployeeID,
		COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') AS EmpName,
		e.Gender AS EmpGender,
		e.BirthDate AS EmpDOB,
		e.ManagerID AS EmpMgrID,
		e.Department AS EmpDept,
		e.Salary AS EmpSalary,
		o.OrderID,
		-- p.ProductID,
		p.Product,
		p.Category AS ProdCategory,
		p.Price AS ProdPrice,
		o.Sales,
		o.Quantity,
		o.OrderDate,
		o.ShipDate,
		o.OrderStatus,
		o.CreationTime AS OrdTime

	FROM Sales.Orders o
	LEFT JOIN Sales.Products p ON o.ProductID = p.ProductID
	LEFT JOIN Sales.Customers c ON o.CustomerID = c.CustomerID
	LEFT JOIN Sales.Employees e ON o.SalesPersonID = e.EmployeeID
	WHERE c.Country <> 'USA' 
)

-- Querying the EU combined details view

SELECT *
FROM sales.v_eu_combined_details

