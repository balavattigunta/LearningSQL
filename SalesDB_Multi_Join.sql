SELECT * FROM sales.Customers

SELECT * FROM sales.Employees

SELECT * FROM sales.Products

SELECT OrderID, (sc.FirstName ||' '|| sc.LastName) AS Customer_name, sp.Product, so.Sales, sp.Price, (se.FirstName||' '|| se.LastName) AS SalesPerson_name FROM sales.Orders AS so
LEFT JOIN sales.Customers AS sc ON so.CustomerID = sc.CustomerID
LEFT JOIN sales.Products AS sp ON so.ProductID = sp.ProductID
LEFT JOIN sales.Employees AS se ON so.SalesPersonID = se.EmployeeID

