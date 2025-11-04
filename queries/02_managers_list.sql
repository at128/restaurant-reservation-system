-- ========================================
-- Query 2: List of Managers
-- ========================================
-- Description: Retrieves all employees holding 'Manager' position
--              including their restaurant assignment and contact information
-- Output: Manager details with restaurant name and location
-- ========================================

SELECT 
    e.FirstName + ' ' + e.LastName AS [Manager Name],
    r.Name AS [Restaurant Name],
    r.City AS [Restaurant City],
    e.Email AS [Email Address],
    e.PhoneNumber AS [Phone Number],
    e.HireDate AS [Hire Date]
FROM Employees e
INNER JOIN Restaurants r ON e.RestaurantID = r.RestaurantID
WHERE e.Position = 'Manager'
ORDER BY r.Name, e.HireDate;