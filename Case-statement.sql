/* 
Create a report showing total sales for each of the following categories:
High - Sales over 50
Medium - Sales between 20 and 50
Low - Sales 20 and below
And sort the categories from highest to lowest

*/
SELECT
Categories,
SUM(Sales) AS TotalSales
FROM (
SELECT 
	OrderID,
	Sales,
	CASE 
		WHEN Sales > 50 THEN 'High'
		WHEN Sales > 20 THEN 'Medium'
		ELSE 'Low'
	END AS Categories
FROM Sales.Orders
)t
GROUP BY Categories
ORDER BY TotalSales DESC

/*	Find the average scores of customers and treat Nulls as 0
	Additionally provide details such as CustomerID and LastName
*/

SELECT 
	CustomerID,
	LastName,
	Score,
	CASE 
		WHEN Score IS NULL THEN 0
		ELSE Score
	END Cleanscore,
	AVG(CASE 
		WHEN Score IS NULL THEN 0
		ELSE Score
	END) OVER() AvgScores

FROM Sales.Customers

-- Conditional Aggregation - Count how many times each customer has made an order with sales greater than 30

SELECT
CustomerID,
SUM(CASE 
	WHEN Sales > 30 THEN 1
	ELSE 0
END) TotalEligibleOrders,
COUNT(Sales) TotalOrders

FROM Sales.Orders
GROUP BY CustomerID