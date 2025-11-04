-- ========================================
-- Query 1: Reservations with Multiple Orders (CTE)
-- ========================================
-- Description: Identifies reservations that have 2 or more orders
--              using Common Table Expression (CTE)
-- Output: Reservation details with customer, restaurant info and order count
-- ========================================

WITH OrderCount AS (
    SELECT 
        ReservationID,
        COUNT(OrderID) AS OrderCount
    FROM Orders
    GROUP BY ReservationID
)

SELECT 
    r.ReservationID,
    r.ReservationDate AS [Reservation Date],
    c.FirstName + ' ' + c.LastName AS [Customer Name],
    c.Email AS [Customer Email],
    rest.Name AS [Restaurant Name],
    rest.City AS [Restaurant City],
    r.PartySize AS [Party Size],
    oc.OrderCount AS [Number of Orders]
FROM Reservations r
INNER JOIN OrderCount oc ON r.ReservationID = oc.ReservationID
INNER JOIN Customers c ON r.CustomerID = c.CustomerID
INNER JOIN Tables t ON r.TableID = t.TableID
INNER JOIN Restaurants rest ON t.RestaurantID = rest.RestaurantID
WHERE oc.OrderCount >= 2
ORDER BY oc.OrderCount DESC, r.ReservationDate DESC;