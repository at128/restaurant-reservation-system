-- ========================================
-- Function: fn_CalculateEmployeeSalary
-- ========================================
-- Description: Calculates employee salary based on:
--              (# orders handled) × (position rank)
-- Position Ranks:
--   VIPOrdersWaiter = 5
--   StandardWaiter = 4
--   AssistantWaiter = 3
--   Others (Manager, etc.) = 0
-- Parameter: @EmployeeId - Employee ID
-- Returns: Calculated salary (0 if no orders or undefined position)
-- ========================================


CREATE OR ALTER FUNCTION fn_CalculateEmployeeSalary(@EmployeeId INT)
RETURNS INT
AS
BEGIN
    DECLARE @orders INT = 0;
    DECLARE @rank   INT = 0;
    

    SELECT @orders = COUNT(*)
    FROM Orders
    WHERE EmployeeID = @EmployeeId;
    

    SELECT @rank = CASE e.Position
                        WHEN 'VIPOrdersWaiter'    THEN 5
                        WHEN 'StandardWaiter'     THEN 4
                        WHEN 'AssistantWaiter'    THEN 3
                        ELSE 0
                   END
    FROM Employees e
    WHERE e.EmployeeID = @EmployeeId;
    

    RETURN ISNULL(@orders, 0) * ISNULL(@rank, 0);
END;
GO
