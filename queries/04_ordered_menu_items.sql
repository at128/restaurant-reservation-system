-- ========================================
-- Query 4: Menu Items Summary for Reservation
-- ========================================
-- Description: Aggregates all menu items ordered across all orders
--              for a specific reservation, sorted by quantity
-- Input: @ReservationID - The ID of the reservation
-- Output: Item name, total quantity ordered, total cost
--         Sorted by quantity (most ordered first)
-- ========================================

DECLARE @ReservationId INT = 2;

SELECT 
    meit.Name AS [Item Name],
    SUM(orit.Quantity) AS [Total Quantity],
    SUM(orit.Quantity * orit.UnitPrice) AS [Total Cost]
FROM Reservations res
INNER JOIN Orders ord ON res.ReservationID = ord.ReservationID
INNER JOIN OrderItems orit ON orit.OrderID = ord.OrderID
INNER JOIN MenuItems meit ON meit.ItemId = orit.MenuItemID
WHERE res.ReservationID = @ReservationId
GROUP BY meit.Name
ORDER BY SUM(orit.Quantity) DESC;