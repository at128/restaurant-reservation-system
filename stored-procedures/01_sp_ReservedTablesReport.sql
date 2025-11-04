-- ========================================
-- Stored Procedure: sp_ReservedTablesReport
-- ========================================
-- Description: Generates report of reserved tables within date range
-- Parameters: 
--   @StartDate - Start of date range (inclusive)
--   @EndDate - End of date range (exclusive)
-- Returns: Tabulated report with reservation, customer, and restaurant details
-- ========================================
DROP PROCEDURE IF EXISTS sp_ReservedTablesReport;
GO
CREATE PROCEDURE sp_ReservedTablesReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN

    IF @StartDate > @EndDate
    BEGIN
        RAISERROR('Start date must be before or equal to end date', 16, 1);
        RETURN;
    END


    SELECT 
        r.ReservationID,
        r.ReservationDate AS [Reservation Date],
        c.FirstName + ' ' + c.LastName AS [Customer Name],
        c.PhoneNumber AS [Customer Phone],
        rest.Name AS [Restaurant Name],
        rest.City AS [Restaurant City],
        t.TableId AS [Table Number],
        t.Capacity AS [Table Capacity],
        r.PartySize AS [Party Size]
    FROM Reservations r
    INNER JOIN Customers c ON r.CustomerID = c.CustomerID
    INNER JOIN Tables t ON r.TableID = t.TableID
    INNER JOIN Restaurants rest ON t.RestaurantID = rest.RestaurantID
    WHERE r.ReservationDate >= @StartDate
      AND r.ReservationDate < @EndDate
    ORDER BY r.ReservationDate, rest.Name;
END;
GO