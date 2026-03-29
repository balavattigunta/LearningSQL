-- Create a table as select statement - CTAS
-- It is similar to view but it creates a physical table that stores the data. This can be useful for performance reasons or when you want to create a snapshot of the data at a specific point in time.

IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL -- U means User defined table
	DROP TABLE Sales.MonthlyOrders ;
GO

SELECT
	DATENAME(MONTH, OrderDate) AS OrderMonth,
	DATENAME(WEEKDAY, OrderDate) AS OrderWeekday, -- WEEKDAY brings up the day of the week not the date
	COUNT(OrderID) AS TotalOrders,
	COUNT(*) OVER (PARTITION BY DATENAME(WEEKDAY, OrderDate)) AS TotalOrdersByWEEKDAY
INTO Sales.MonthlyOrders -- This creates a new table called MonthlyOrders in the Sales schema
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate), DATENAME(WEEKDAY, OrderDate);

/* This above query creates a new table called MonthlyOrders in the Sales schema, which contains the total number of orders for each month. 
The data is grouped by the month of the OrderDate. 
After creating the table, it selects all records from the MonthlyOrders table to display the results. */

SELECT * FROM Sales.MonthlyOrders
ORDER BY OrderMonth; 

