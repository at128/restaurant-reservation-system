-- ========================================
-- View: vw_ReservationReport
-- ========================================
-- Description: Comprehensive view of all reservations
--              with customer, restaurant, and table details
-- ========================================

CREATE OR ALTER VIEW vw_ReservationReport AS
SELECT 
    r.ReservationID,
    r.ReservationDate AS [Reservation Date],
    rest.Name AS [Restaurant Name],
    rest.City AS [Restaurant City],
    t.Capacity AS [Table Capacity],
    r.PartySize AS [Number of Guests],
    cu.FirstName + ' ' + cu.LastName AS [Customer Name]
FROM Reservations r
INNER JOIN Tables t ON t.TableId = r.TableID
INNER JOIN Restaurants rest ON t.RestaurantId = rest.RestaurantId
INNER JOIN Customers cu ON cu.CustomerID = r.CustomerID;
GO
