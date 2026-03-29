-- STEP 1 - Write a query
-- For USA customers find the total number of customers and the average score

SELECT 
	COUNT(*) AS TotalCustomers,
	AVG(Score) AS AverageScore
FROM 
	Sales.Customers
WHERE 
	Country = 'USA';

-- STEP 2 - Turning a query into a stored procedure

CREATE PROCEDURE GetCustomerSummary AS
BEGIN
	SELECT 
	COUNT(*) AS TotalCustomers,
	AVG(Score) AS AverageScore
FROM 
	Sales.Customers
WHERE 
	Country = 'USA';
END

-- Step 3 - Execute the stored procedure

EXEC GetCustomerSummary;

-- Step 4 - Modify the stored procedure to accept a parameter for country

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) AS -- Added a parameter for country
BEGIN
	SELECT 
	COUNT(*) AS TotalCustomers,
	AVG(Score) AS AverageScore
FROM 
	Sales.Customers
WHERE 
	Country = @Country; -- Use the parameter in the WHERE clause
END

-- Step 5 - Execute the modified stored procedure with a parameter

EXEC GetCustomerSummary @Country = 'USA';

EXEC GetCustomerSummary @Country = 'Germany';

-- Step 6 - Execute the modified stored procedure with a default parameter value - Parameters pass values into a stored procedure or return values back to the caller


ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS -- Added a parameter for country and set a default value
BEGIN
	SELECT 
	COUNT(*) AS TotalCustomers,
	AVG(Score) AS AverageScore
FROM 
	Sales.Customers
WHERE 
	Country = @Country; -- Use the parameter in the WHERE clause
END

-- Step 7 - Execute the modified stored procedure without passing a parameter to use the default value

EXEC GetCustomerSummary; -- This will use the default value 'USA' for the @Country parameter

EXEC GetCustomerSummary @Country = 'Germany'; -- This will override the default value and use 'Germany' for the @Country parameter

-- Multiple queries inside one stored procedures
-- Find the total number of orders and total sales

-- STEP 1 - Write a query to find the total number of orders and total sales
SELECT 
	COUNT(OrderID) AS TotalOrders,
	SUM(Sales) AS TotalSales
FROM 
	Sales.Orders o
JOIN 
	Sales.Customers c ON o.CustomerID = c.CustomerID
WHERE 
	c.Country = 'USA';

-- STEP 2 - add this query to the existing stored procedure

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
	SELECT 
	COUNT(*) AS TotalCustomers,
	AVG(Score) AS AverageScore
FROM 
	Sales.Customers
WHERE 
	Country = @Country; -- Use the parameter in the WHERE clause

-- Add the new query to find total orders and total sales

SELECT 
	COUNT(OrderID) AS TotalOrders,
	SUM(Sales) AS TotalSales
FROM 
	Sales.Orders o
JOIN 
	Sales.Customers c ON o.CustomerID = c.CustomerID
WHERE 
	c.Country = @Country;

END

-- Step 3 - Execute the modified stored procedure to see both results

EXEC GetCustomerSummary; -- This will use the default value 'USA' for the @Country parameter

EXEC GetCustomerSummary @Country = 'Germany'; -- This will override the default value and use 'Germany' for the @Country parameter

-- Variables - temporarily store and manipulate data during its execution
-- Example : We want to print the message Total Customers from Germany: 2
-- Average Score from Germany: 425
-- But, instead of germany, want to use the parameter value
-- Instead of static numbers, want to use the values from the query

PRINT 'Total Customers from '+@Country+ ':'+ 2; -- we passed the parameter value because it is already declared in the stored procedure, but we need to replace the static number with the value from the query

-- STEP 1 - Declare variables to store the results of the queries

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN

	DECLARE @TotalCustomers INT, @AverageScore FLOAT, @TotalOrders INT, @TotalSales FLOAT; -- Declare a variables immediately after the BEGIN statement

	SELECT 
-- Step 2 - Store the results of the queries in the variables instead of returning them as a result set

	@TotalCustomers = COUNT(*), -- Store the result of the COUNT(*) query in the @TotalCustomers variable - notice the difference between assigning a value to a variable and providing a name for a column in the result set
	@AverageScore = AVG(Score) 
FROM 
	Sales.Customers
WHERE 
	Country = @Country; -- Use the parameter in the WHERE clause

-- Step 3 - Print the message with the parameter value and the variable values

PRINT 'Total Customers from '+@Country+ ':'+CAST(@TotalCustomers AS NVARCHAR); -- Print the message with the parameter value and the variable value - notice that we are concatenating the string with the variable values
PRINT 'Average Score from '+@Country+ ':'+CAST(@AverageScore AS VARCHAR) ;  -- We need to cast the variable values to NVARCHAR or VARCHAR because the PRINT statement expects a string value


-- Add the new query to find total orders and total sales

SELECT 
	@TotalOrders = COUNT(OrderID),
	@TotalSales = SUM(Sales)
FROM 
	Sales.Orders o
JOIN 
	Sales.Customers c ON o.CustomerID = c.CustomerID
WHERE 
	c.Country = @Country;

PRINT 'Total Orders from '+@Country+ ':'+CAST(@TotalOrders AS NVARCHAR);
PRINT 'Total Sales from '+@Country+ ':'+CAST(@TotalSales AS NVARCHAR);

END

-- Step 4 - Execute the modified stored procedure to see the printed messages with the parameter values and variable values

EXEC GetCustomerSummary; -- This will use the default value 'USA' for the @Country parameter

EXEC GetCustomerSummary @Country = 'Germany'; -- This will override the default value and use 'Germany' for the @Country parameter

-- Control FLOW - Handling NULL values with IF statement

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN

	DECLARE @TotalCustomers INT, @AverageScore FLOAT, @TotalOrders INT, @TotalSales FLOAT;
-- Prepare & Clean the data 
	IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
	BEGIN
		PRINT 'There are customers with NULL scores in '+@Country+'. Updating their scores to 0.';
		UPDATE Sales.Customers
		SET Score = 0
		WHERE Score IS NULL AND Country = @Country;
	END

	ELSE
	BEGIN
		PRINT 'No customers with NULL scores in '+@Country+'. No updates needed.';
	END;

-- Generating reports
	SELECT 


	@TotalCustomers = COUNT(*),
	@AverageScore = AVG(Score) 
FROM 
	Sales.Customers
WHERE 
	Country = @Country; 


PRINT 'Total Customers from '+@Country+ ':'+CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score from '+@Country+ ':'+CAST(@AverageScore AS VARCHAR) ; 


SELECT 
	@TotalOrders = COUNT(OrderID),
	@TotalSales = SUM(Sales)
FROM 
	Sales.Orders o
JOIN 
	Sales.Customers c ON o.CustomerID = c.CustomerID
WHERE 
	c.Country = @Country;

PRINT 'Total Orders from '+@Country+ ':'+CAST(@TotalOrders AS NVARCHAR);
PRINT 'Total Sales from '+@Country+ ':'+CAST(@TotalSales AS NVARCHAR);

END

-- Query Execution

EXEC GetCustomerSummary; 

EXEC GetCustomerSummary @Country = 'Germany';

-- ERROR HANDING - TRY...CATCH block to handle errors gracefully and provide informative error messages

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN

	DECLARE @TotalCustomers INT, @AverageScore FLOAT, @TotalOrders INT, @TotalSales FLOAT;
-- Prepare & Clean the data 
	IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
	BEGIN
		PRINT 'There are customers with NULL scores in '+@Country+'. Updating their scores to 0.';
		UPDATE Sales.Customers
		SET Score = 0
		WHERE Score IS NULL AND Country = @Country;
	END

	ELSE
	BEGIN
		PRINT 'No customers with NULL scores in '+@Country+'. No updates needed.';
	END;

-- Generating reports
	SELECT 

	@TotalCustomers = COUNT(*),
	@AverageScore = AVG(Score)
	
FROM 
	Sales.Customers
WHERE 
	Country = @Country; 


PRINT 'Total Customers from '+@Country+ ':'+CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score from '+@Country+ ':'+CAST(@AverageScore AS VARCHAR) ; 


SELECT 
	@TotalOrders = COUNT(OrderID),
	@TotalSales = SUM(Sales)	
FROM 
	Sales.Orders o
JOIN 
	Sales.Customers c ON o.CustomerID = c.CustomerID
WHERE 
	c.Country = @Country;

PRINT 'Total Orders from '+@Country+ ':'+CAST(@TotalOrders AS NVARCHAR);
PRINT 'Total Sales from '+@Country+ ':'+CAST(@TotalSales AS NVARCHAR);

BEGIN TRY
	SELECT 1/0 AS ErrorExample; -- This will cause a divide by zero error to demonstrate the error handling block
END TRY

BEGIN CATCH
	PRINT 'An error occurred: ' + ERROR_MESSAGE();
	PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR);
	PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
	PRINT 'Error Procedure: ' + ERROR_PROCEDURE();

END CATCH

END

GO

-- Query Execution

EXEC GetCustomerSummary; 

EXEC GetCustomerSummary @Country = 'Germany'; 

EXEC GetCustomerSummary @Country = 'Australia'; -- This will trigger the error handling block because there are no customers from this country, and the queries will return NULL values which will cause an error when trying to cast them to NVARCHAR.

-- Triggers - 
/*  A trigger is a special type of stored procedure that automatically executes in response to certain events on a particular table or view. 
Triggers can be used to enforce business rules, maintain data integrity, and perform auditing tasks. */

-- STEP 1 - Create a log table to store the audit information

CREATE TABLE Sales.EmployeeLog (
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
);

-- STEP 2 - Create a trigger that inserts a log entry into the EmployeeLog table whenever an employee's score is updated

CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
	AS
		BEGIN
			INSERT INTO Sales.EmployeeLog (EmployeeID, LogMessage, LogDate)
			SELECT 
				EmployeeID, 
				'New Employee Added ='+CAST(EmployeeID AS VARCHAR),
				GETDATE()
			FROM 
				inserted; -- The inserted table is a special table that holds the new rows that were inserted into the Employees table
		END

-- Step 3 - Insert a new employee to test the trigger

INSERT INTO Sales.Employees
	VALUES 
	(6, 'Simran', 'Chawla', 'Clinical', '1976-10-15', 'F', 160000, 3);

-- Step 4 - Check the EmployeeLog table to see the log entry created by the trigger

SELECT * FROM Sales.EmployeeLog;