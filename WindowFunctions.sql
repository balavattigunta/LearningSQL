SELECT
o.OrderDate,
o.OrderID,
o.ProductID,
COUNT(*) OVER(PARTITION BY ProductID) TotalOrdersByProduct,
COUNT(*) OVER() TotalOrders,
SUM(Score) OVER(PARTITION BY ProductID) TotalScoreByProduct,
SUM(Score) OVER() TotalScore,
SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProduct,
SUM(Sales) OVER() TotalSales,
MIN(Score) OVER(PARTITION BY ProductID) MinimumScoreByProduct,
MIN(Sales) OVER(PARTITION BY ProductID) MinimumSalesByProduct,
MAX(Score) OVER(PARTITION BY ProductID) MaximumScoreByProduct,
MAX(Sales) OVER(PARTITION BY ProductID) MaximumSalesByProduct,
AVG(Score) OVER(PARTITION BY ProductID) AverageScoreByProduct,
AVG(Sales) OVER(PARTITION BY ProductID) AverageSalesByProduct,
AVG(Sales) OVER() AverageSales

FROM Sales.Customers c
INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID


-- Window Functions - RANK(),


SELECT 
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER (ORDER BY Sales DESC) RankSales
FROM Sales.Orders

-- Window Functions - Frame Clause


SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (Partition BY OrderStatus ORDER BY OrderDate 
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) PartitionedSales
FROM Sales.Orders


-- Rank customers based on their total sales

SELECT
CustomerID,
SUM(Sales) TotalSales,
RANK() OVER (ORDER BY SUM(Sales) DESC) RankCustomer

FROM Sales.Orders
GROUP BY CustomerID

-- Alternative method

WITH CustomerTotalSales AS (
SELECT	
	CustomerID,
	SUM(Sales) AS TotalSales

FROM Sales.Orders
GROUP BY CustomerID
)

SELECT 
	CustomerID,
	TotalSales,
	RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank

FROM CustomerTotalSales
ORDER BY TotalSales DESC;

-- Check duplicates in Primary Key

SELECT *

FROM (

SELECT
	OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) CheckPK
FROM Sales.OrdersArchive
)s WHERE CheckPK > 1


-- Find the percentage contribution of each product's sales to the total sales

SELECT 
	OrderID,
	ProductID,
	Sales,
	SUM(Sales) OVER () AS TotalSales,
	ROUND(CAST(Sales AS Float) / SUM(Sales) OVER () * 100,2) AS PercentageSales
FROM Sales.Orders

-- Find the average sales for all orders - Also find average sales for each product - additionally proide details such as orderID and OrderDate
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(COALESCE(Sales,0)) OVER () AS AverageSales,
	AVG(COALESCE(Sales, 0)) OVER (PARTITION BY ProductID) AS AverageProductSales
FROM Sales.Orders

-- Fin all orders where sales are higher than the average sales across all orders

SELECT
* 
FROM (
SELECT
	OrderID,
	ProductID,
	Sales,
	AVG(Sales) Over() AverageSales
FROM Sales.Orders
)t WHERE SALES > AverageSales


-- Find the highest and lowest sales across all orders - also find highest and lowest sales for each product, additionally provide details such s orderid and orderdate
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MIN(COALESCE(Sales,0)) OVER () AS LowestSales,
	MIN(COALESCE(Sales, 0)) OVER (PARTITION BY ProductID) AS LowestProductSales,
	MAX(COALESCE(Sales,0)) OVER () AS HighestSales,
	MAX(COALESCE(Sales, 0)) OVER (PARTITION BY ProductID) AS HighestProductSales

FROM Sales.Orders

-- Show the employees who have the highest salaries

SELECT
*
FROM (
SELECT
	EmployeeID,
	Salary,
	Department,
	MAX(Salary) OVER () HighestSalary
FROM Sales.Employees
)t WHERE Salary = HighestSalary 

-- Find the deviation of each sale from the lowest and hight sales amounts
SELECT
OrderID,
Sales,
LowestSales,
Sales - LowestSales AS DeviationFromMin,
HighestSales,
Sales - HighestSales AS DeviationFromMax

FROM (

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MIN(COALESCE(Sales,0)) OVER () AS LowestSales,
	MAX(COALESCE(Sales,0)) OVER () AS HighestSales
FROM Sales.Orders
)t

-- Running and Rolling totals - Tracking and Trending Sales
-- Running total means aggregate all values from the beginnning upto the current point without dropping off older data
-- Rolling total means aggreagate all values within a fixed time window (e.g. 30 days) - As new data is added, the oldest data point will be dropped

SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAverage, -- Running Total
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollngAverage -- Rolling Total
FROM Sales.Orders






