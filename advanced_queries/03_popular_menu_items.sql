-- ========================================
-- Query 3: Popular Menu Items per Restaurant
-- ========================================
-- Description: Identifies the most popular menu item for each restaurant
--              for a specific month using window functions
-- Input: @year, @month
-- Output: Most popular item per restaurant with order count
-- ========================================

DECLARE @year  INT = 2025;
DECLARE @month INT = 10;

;WITH month_bounds AS (
    SELECT 
        start_date = DATEFROMPARTS(@year, @month, 1),
        end_date   = DATEADD(month, 1, DATEFROMPARTS(@year, @month, 1))
),
ItemRanking AS (
    SELECT 
        rest.RestaurantID,
        rest.Name AS RestaurantName,
        rest.City,
        mi.Name AS MenuItemName,
        COUNT(*) AS ItemCount,
        SUM(oi.Quantity) AS TotalQuantity,
        RANK() OVER (
            PARTITION BY rest.RestaurantID
            ORDER BY COUNT(*) DESC
        ) AS ItemRank
    FROM Restaurants AS rest
    JOIN MenuItems AS mi ON mi.RestaurantID = rest.RestaurantID
    JOIN OrderItems AS oi ON oi.MenuItemID = mi.ItemId
    JOIN Orders AS o ON o.OrderId = oi.OrderID
    CROSS JOIN month_bounds AS mb
    WHERE o.OrderDate >= mb.start_date
      AND o.OrderDate < mb.end_date
    GROUP BY
        rest.RestaurantID,
        rest.Name,
        rest.City,
        mi.Name
)
SELECT 
    RestaurantID,
    RestaurantName,
    City,
    MenuItemName AS [Most Popular Item],
    ItemCount AS [Times Ordered],
    TotalQuantity AS [Total Quantity Sold]
FROM ItemRanking
WHERE ItemRank = 1
ORDER BY ItemCount DESC;