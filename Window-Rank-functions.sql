-- Rank the orders based on their sales from highest to lowest

SELECT
	OrderID,
	ProductID,
	OrderStatus,
	Sales,
	ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRankByRowNumber,
	RANK() OVER (ORDER BY Sales DESC) SalesRank,
	DENSE_RANK() OVER (ORDER BY Sales DESC) SalesDenseRank

FROM Sales.Orders

-- Find the top highest sales for each product
SELECT
*
FROM (
SELECT
	OrderID,
	ProductID,
	OrderStatus,
	Sales,
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct

FROM Sales.Orders

)t WHERE RankByProduct = 1


-- Find the Lowest 2 customers on their total sales

SELECT
*
FROM (
SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER (ORDER BY SUM(Sales)) RankByCustomer
FROM Sales.Orders
GROUP BY CustomerID
)t WHERE RankByCustomer <= 2

-- Assign unique IDs to the rows of the 'Orders Archive' table

SELECT
ROW_NUMBER() OVER (ORDER BY OrderID, OrderDate) UniqueID,
*
FROM Sales.OrdersArchive

-- Identify duplicates rows in the table OrdersArchive and return a clean result without any duplicates

SELECT
*
FROM (
SELECT

ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime) RankOrders,
*

FROM Sales.OrdersArchive
)t WHERE RankOrders = 1

-- Percent Based Ranking - CUME_DIST

SELECT

CUME_DIST() OVER (ORDER BY OrderID) RankOrders,
*

FROM Sales.OrdersArchive

-- Percent Based Ranking - PERCENT_RANK

SELECT

ROUND(PERCENT_RANK() OVER (ORDER BY OrderID),2) RankOrders,
*

FROM Sales.OrdersArchive

-- Find the products that fall within the highest 40% of the prices

SELECT
*
FROM (
SELECT 
Product,
Price,
CUME_DIST() OVER(ORDER BY Price DESC) PriceRank
FROM Sales.Products
)t WHERE PriceRank <= 0.4


SELECT
*
FROM (
SELECT 
Product,
Price,
PERCENT_RANK() OVER(ORDER BY Price DESC) PriceRank
FROM Sales.Products
)t WHERE PriceRank <= 0.4

-- NTILE - Divides the rows into a specified number of approximately equal groups (Buckets)

SELECT
OrderID,
Sales,
NTILE(1) OVER (ORDER BY Sales DESC) OneBkt, -- Bucket size = total number of rows / Ntile size (10/1 = 10)
NTILE(2) OVER (ORDER BY Sales DESC) TwoBkts, -- 10/2 = 5
NTILE(3) OVER (ORDER BY Sales DESC) ThreeBkts, -- 10 / 3 = 3.33 so first bucket will have 4 rows and 2nd and 3rd buckets 3 each
NTILE(4) OVER (ORDER BY Sales DESC) FourBkts -- 10/4 = 2.5 so first and second buckets have 3 rows and the 3rd and 4th buckets 2 rows each
FROM Sales.Orders

-- NTILE - For the purposes of DATA SEGMENTATION 
-- Data segmentation divides a dataset into distinct subsets based on certain criteria
-- Segment all orders into 3 categories: High, Medium and Low Sales

SELECT
*,
	CASE Buckets
		WHEN 1 THEN 'High'
		WHEN 2 THEN 'Medium'
		WHEN 3 THEN 'Low'
	END SegmentedSales
FROM (

Select

	OrderID,
	Sales,
	NTILE(3) OVER (ORDER BY Sales DESC) Buckets
FROM Sales.Orders
)t


-- In order to export the data, divide the orders into 2 groups

SELECT 
NTILE(2) OVER (ORDER BY OrderID) Buckets, -- helps to divide the table into 2 smaller buckets and be able to export each bucket at a time
*
FROM Sales.Orders

