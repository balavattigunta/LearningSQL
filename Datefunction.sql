SELECT  first_name, country,
	LOWER(first_name) AS LowerCase,
	UPPER(first_name) AS UpperCase,
	CONCAT(UPPER(LEFT(TRIM(first_name),1)),RIGHT(TRIM(first_name),LEN(TRIM(first_name))-1)) AS CapitalCase,
	TRIM(first_name) AS TrimedName,
	SUBSTRING(country,4,3) AS Substring,
	CONVERT(VARCHAR, score) ConvertedScore, 
	CAST(score AS VARCHAR) CastScore
FROM customers

SELECT order_date,

	DATEADD(year, 3, order_date) AS ThreeYearsLater,
	DATEADD(year, -3, order_date) AS ThreeYearsEarlier,
	DATEADD(MONTH, 5, order_date) AS FiveMonthsLater,
	DATEADD(MONTH, -5, order_date) AS FiveMonthsEarlier,
	DATEADD(DAY, 10, order_date) AS TenDaysLater,
	DATEADD(DAY, -10, order_date) AS TenDaysEarlier

FROM Orders

SELECT 
	ISDATE('2025-08-25') AS fulldate,
	ISDATE('2025-08') AS YearMonth,
	ISDATE('2025') AS OnlyYear