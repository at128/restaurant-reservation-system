-- ========================================
-- Stored Procedure: sp_AddNewOrder
-- ========================================
-- Description: Adds a new order with validation
-- Parameters:
--   @ReservationId - Reservation ID
--   @EmployeeId - Employee ID
--   @OrderDate - Order date/time
--   @TotalAmount - Total order amount
-- Returns: New OrderID or error message
-- ========================================

DROP PROCEDURE IF EXISTS sp_AddNewOrder;
GO

CREATE PROCEDURE sp_AddNewOrder
    @ReservationId INT,
    @EmployeeId INT,
    @OrderDate DATETIME,
    @TotalAmount DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    
    IF NOT EXISTS (SELECT 1 FROM Reservations WHERE ReservationID = @ReservationId)
    BEGIN
        RAISERROR('Invalid Reservation ID', 16, 1);
        RETURN;
    END
    
    
    IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeId)
    BEGIN
        RAISERROR('Invalid Employee ID', 16, 1);
        RETURN;
    END
    
    
    IF @TotalAmount < 0
    BEGIN
        RAISERROR('Total amount cannot be negative', 16, 1);
        RETURN;
    END
    
    
    INSERT INTO Orders (ReservationID, EmployeeID, OrderDate, TotalAmount)
    VALUES (@ReservationId, @EmployeeId, @OrderDate, @TotalAmount);
    
    
    DECLARE @NewOrderId INT = SCOPE_IDENTITY();
    SELECT @NewOrderId AS NewOrderID, 'Order added successfully' AS Message;
END;
GO
