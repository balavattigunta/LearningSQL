SELECT
OrderDate,
OrderID,
ProductID,
CustomerID,
Sales,
LEAD(Sales,1,0) OVER (ORDER BY OrderDate) LeadSales,
LAG(Sales,1,0) OVER (ORDER BY OrderDate) LagSales,
FIRST_VALUE(Sales) OVER (ORDER BY OrderDate) FirstValue,
LAST_VALUE(Sales) OVER (ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) LastValue

FROM Sales.Orders

-- Time Series Analysis - The process of analysing the data to understand patterns, trends, and behaviors over time
-- Month - Over - Month (MoM) Analysis & Year - Over - Year (YoY) Analysis

SELECT
OrderMonth,
CurrentMonthSales,
PreviousMonthSales,
CurrentMonthSales - PreviousMonthSales AS MoM_Change,
CONCAT(ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT)/PreviousMonthSales * 100,1),'%') AS MoM_Percentage

FROM (

SELECT 
	MONTH(OrderDate) OrderMonth, -- Extracting month from the orderdate
	LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) PreviousMonthSales, -- Getting previous month sales
	SUM(Sales) CurrentMonthSales, -- Totalling sales by the month
	LEAD(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) FutureMonthSales -- Getting future month sales
FROM Sales.Orders
GROUP BY MONTH(OrderDate)
)t

-- Customer Retention Analysis - Measures customers behavior and loyalty to help business build strong relationships with customers
-- In order to analyse customer loyalty, rank customers based on the average days between their orders

SELECT
CustomerID,
AVG(DaysUntilNextOrder) AS AvgOrderDays,
RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder), 99999) ) AS RankAvg

FROM (

SELECT 
	OrderID,
	CustomerID,
	OrderDate AS CurrentOrder,
	LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
	DATEDIFF(Day, OrderDate, LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
FROM Sales.Orders
)t

GROUP BY CustomerID

-- Time Gap Analysis - Find the average shipping duration in days for each month

SELECT
OrderMonth,
AVG(ProcessingDays) AvgDays2Ship

FROM (

SELECT
	OrderID,
	MONTH(OrderDate) OrderMonth,
	OrderDate,
	ShipDate, 
	DATEDIFF(Day, OrderDate, ShipDate) AS ProcessingDays
FROM Sales.Orders
)t
GROUP BY OrderMonth

-- Time Gap Analysis - Find the number of days between each order and the previous order

SELECT
OrderID,
OrderDate AS CurrentOrderDate,
LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
DATEDIFF(Day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) As DaysBetWeenOrders

FROM Sales.Orders


-- First_Value & Last_Value - Lowest and highest sales for each product
-- Find the difference in sales between the current and the lowest sales

SELECT
	OrderID,
	ProductID,
	CustomerID,
	Sales,
	FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) LowestSales,
	LAST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
	FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales DESC) HighestSales, -- instead of using last_value, you can use first_value and change the order by desc
	Sales - FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS SalesDiffLowest
FROM Sales.Orders
