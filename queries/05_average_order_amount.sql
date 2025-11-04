-- ========================================
-- Query 5: Calculate Average Order Amount by Employee
-- ========================================
-- Description: Calculates statistics for orders handled by a specific employee
--              including average, minimum, maximum order amounts
-- Input: @EmployeeID - The ID of the employee
-- Output: Employee name, order statistics (count, avg, min, max)
-- ========================================

DECLARE @EmployeeID INT = 2;

SELECT 
    e.FirstName + ' ' + e.LastName AS [Employee Name],
    COUNT(ord.OrderID) AS [Total Orders],
    MIN(ord.TotalAmount) AS [Min Order],
    MAX(ord.TotalAmount) AS [Max Order],
    AVG(ord.TotalAmount) AS [Average Order Amount],
    SUM(ord.TotalAmount) AS [Total Revenue]  -- Optional bonus!
FROM Employees e
INNER JOIN Orders ord ON ord.EmployeeID = e.EmployeeID
WHERE e.EmployeeID = @EmployeeID
GROUP BY e.FirstName, e.LastName;