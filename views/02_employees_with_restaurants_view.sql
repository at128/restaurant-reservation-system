-- ========================================
-- View: vw_EmployeesWithRestaurants
-- ========================================
-- Description: Lists all employees with their restaurant assignments
-- ========================================

DROP VIEW IF EXISTS vw_EmployeesWithRestaurants;
GO

CREATE VIEW vw_EmployeesWithRestaurants AS
SELECT 
    e.FirstName + ' ' + e.LastName AS [Employee Name],
    e.Position,
    r.Name AS [Restaurant Name],
    r.OpeningHours AS [Restaurant Opening Hours]
FROM Employees e
LEFT JOIN Restaurants r 
    ON r.RestaurantID = e.RestaurantID;
GO
