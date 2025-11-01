-- ========================================
-- Stored Procedure: sp_FutureReservationsReport
-- ========================================
-- Description: Retrieves tables with future reservations
--              Uses temporary table to store intermediate results
-- Returns: Restaurant details with tables that have future reservations
-- ========================================

DROP PROCEDURE IF EXISTS sp_FutureReservationsReport;
GO

CREATE PROCEDURE sp_FutureReservationsReport
AS
BEGIN
    SET NOCOUNT ON;
    
    
    CREATE TABLE #FutureTables (
        TableID INT,
        RestaurantID INT,
        ReservationCount INT
    );
    
    
    INSERT INTO #FutureTables (TableID, RestaurantID, ReservationCount)
    SELECT 
        t.TableID,
        t.RestaurantID,
        COUNT(r.ReservationID) AS ReservationCount
    FROM Tables t
    INNER JOIN Reservations r ON t.TableID = r.TableID
    WHERE r.ReservationDate > GETDATE()
    GROUP BY t.TableID, t.RestaurantID;
    
    
    SELECT 
        rest.RestaurantID,
        rest.Name AS [Restaurant Name],
        rest.City AS [Restaurant City],
        ft.TableID AS [Table Number],
        t.Capacity AS [Table Capacity],
        ft.ReservationCount AS [Future Reservations]
    FROM #FutureTables ft
    INNER JOIN Restaurants rest ON ft.RestaurantID = rest.RestaurantID
    INNER JOIN Tables t ON ft.TableID = t.TableID
    ORDER BY rest.Name, ft.TableID;
    
    
    DROP TABLE #FutureTables;
END;
GO

