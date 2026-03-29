/* SELECT 
CustomerID,
Score,
COALESCE(Score, 0) Score2,
AVG(Score) OVER () AvgScores,
AVG(COALESCE(Score, 0)) OVER () AvgScores2
FROM Sales.Customers 

SELECT
CustomerID,
FirstName,
LastName,
COALESCE(LastName,'') AS Lastname2,
FirstName + ' ' + LastName AS FullName,
FirstName + ' ' + COALESCE(LastName, '') AS Fullname2,
Score,
COALESCE(Score, 0) AS Score2,
COALESCE(Score,0) + 10 AS ScorePlusBonus
FROM Sales.Customers



SELECT 
CustomerID,
Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score

*/

-- Find the sales price for each order by dividing sales by quantity

SELECT OrderID,
	   Sales,
	   Quantity,
	   Sales / NULLIF(Quantity,0) AS Price
FROM Sales.Orders


-- Identify the customers who have no scores

SELECT
*

FROM Sales.Customers
WHERE Score IS NULL

-- Show a list of all customers who have scores

SELECT

*

FROM Sales.Customers
WHERE Score IS NOT NULL


-- Find the list of all customers who have not placed any orders

SELECT
-- CustomerID,
*

FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL

-- Checking the difference between NULL, Empty and Black

WITH Orders AS ( -- Function
SELECT 1 ID, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, ' ' 
)

SELECT
*,
DATALENGTH(Category) CategoryLen,
TRIM(Category) Policy1, -- Remove blank spaces and make it an empty string
NULLIF(TRIM(Category), '') Policy2,-- Convert any blanks and empty spaces into NULL
COALESCE(Category , 'unknown'), -- Convert any null, blank and empty spaces into unknown - the result of this query is that only null would convert to unknown
COALESCE(NULLIF(TRIM(Category), ''), 'unknown') -- This query conerts properly because it has completed the previous 2 steps and then executed the COALESCE function
FROM ORDERS

