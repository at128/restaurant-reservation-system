-- ========================================
-- View: vw_EmployeesWithRestaurants
-- ========================================
-- Description: Lists all employees with their restaurant assignments
-- ========================================


CREATE OR ALTER VIEW vw_EmployeesWithRestaurants AS
SELECT 
    e.FirstName + ' ' + e.LastName AS [Employee Name],
    e.Position,
    r.Name AS [Restaurant Name],
    r.OpeningHours AS [Restaurant Opening Hours]
FROM Employees e
LEFT JOIN Restaurants r 
    ON r.RestaurantID = e.RestaurantID;
GO
