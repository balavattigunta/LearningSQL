SELECT FirstName, Country,
	LOWER(FirstName) AS LowerCase,
	UPPER(FirstName) AS UpperCase,
	CONCAT(UPPER(LEFT(LOWER(FirstName),1)),RIGHT(LOWER(FirstName),LEN(FirstName)-1)) AS CapitalCase,
	OrderID,
	OrderDate,
	DAY(OrderDate) AS Day_,
	MONTH(OrderDate) AS Month_,
	YEAR(OrderDate) AS Year_,
	DATEPART(QUARTER, OrderDate) Quarter,
	DATEPART(WEEK, OrderDate) Week,
	DATEPART(DAYOFYEAR, OrderDate) Day_of_the_year,
	DATEPART(WEEKDAY, OrderDate) Weekday_of_the_year,
	DATENAME(WEEKDAY, OrderDate) Weekday_Name,
	ShipDate,
	DATETRUNC(MONTH, ShipDate) AS Trunk_Month,
	CreationTime,
	FORMAT(CreationTime, 'MM-dd-yyyy') USA_Date,
	'Day '+ FORMAT(CreationTime, 'ddd MMM') +' Q' + DATENAME(quarter, CreationTime) +' '+ FORMAT(CreationTime, 'yyyy hh:mm:ss tt')  AS CustomFormat
	
FROM sales.Customers AS sc
FULL JOIN Sales.Orders AS so ON sc.CustomerID = so.CustomerID

SELECT FORMAT(OrderDate, 'MMM yy') Date_of_orders,
	Sum(Sales) SumSales
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy') 
ORDER BY Date_of_orders DESC

