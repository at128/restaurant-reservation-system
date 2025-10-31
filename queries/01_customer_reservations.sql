-- ========================================
-- Query 1: List of Reservations for a Specific Customer
-- ========================================
-- Description: Retrieves all reservations for a given customer
--              including restaurant name, table capacity, and reservation details
-- Input: @CustomerID - The ID of the customer
-- Output: Reservation details with restaurant and table information
-- ========================================

DECLARE @CustomerId INT = 1;

SELECT 
    r.ReservationID,
    r.ReservationDate AS [Reservation Date],
    rest.Name AS [Restaurant Name],
    rest.City AS [Restaurant City],
    t.Capacity AS [Table Capacity],
    r.PartySize AS [Number of Guests]
FROM Reservations r
INNER JOIN Tables t ON t.TableId = r.TableID
INNER JOIN Restaurants rest ON t.RestaurantId = rest.RestaurantId
WHERE r.CustomerID = @CustomerId
ORDER BY r.ReservationDate DESC;