-- ========================================
-- Function: fn_CalculateRevenue
-- ========================================
-- Description: Calculates total revenue for a specific restaurant
--              by summing all order amounts through restaurant employees
-- Parameter: @RestaurantId - Restaurant ID
-- Returns: Total revenue (0 if no orders)
-- ========================================

DROP FUNCTION IF EXISTS fn_CalculateRevenue;
GO

CREATE FUNCTION fn_CalculateRevenue(@RestaurantId INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @revenue DECIMAL(18,2);
    
    SELECT @revenue = COALESCE(SUM(o.TotalAmount), 0)
    FROM Restaurants r
    INNER JOIN Employees em ON em.RestaurantID = r.RestaurantID
    INNER JOIN Orders o ON o.EmployeeID = em.EmployeeID
    WHERE r.RestaurantID = @RestaurantId;
    
    RETURN @revenue;
END;
GO