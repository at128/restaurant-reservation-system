-- ========================================
-- Query 3: List of Orders and Menu Items for a Reservation
-- ========================================
-- Description: Retrieves all orders placed for a specific reservation
--              along with the menu items in each order
-- Input: @ReservationID - The ID of the reservation
-- Output: Order details with menu items, quantities, and prices
-- ========================================

DECLARE @ReservationId INT = 2;

SELECT 
    ord.OrderID,
    ord.OrderDate AS [Order Date],
    e.FirstName + ' ' + e.LastName AS [Server Name],
    meit.Name AS [Item Name],
    orit.Quantity,
    orit.UnitPrice AS [Unit Price],
    (orit.Quantity * orit.UnitPrice) AS [Item Total],
    ord.TotalAmount AS [Order Total]
FROM Reservations res
INNER JOIN Orders ord ON res.ReservationID = ord.ReservationID
INNER JOIN OrderItems orit ON orit.OrderID = ord.OrderID
INNER JOIN MenuItems meit ON meit.ItemId = orit.MenuItemID
INNER JOIN Employees e ON ord.EmployeeID = e.EmployeeID
WHERE res.ReservationID = @ReservationId
ORDER BY ord.OrderID, orit.OrderItemID;