-- ========================================
-- Query 2: Restaurant Popularity Ranking
-- ========================================
-- Description: Ranks restaurants by reservation frequency
--              Shows total reservations per restaurant
-- Output: Restaurant name, city, reservation count, and rank
-- ========================================

WITH RestaurantReservations AS (
    SELECT 
        rest.RestaurantID,
        rest.Name AS RestaurantName,
        rest.City,
        COUNT(rese.ReservationID) AS TotalReservations
    FROM Restaurants rest
    LEFT JOIN Tables t ON t.RestaurantID = rest.RestaurantID
    LEFT JOIN Reservations rese ON rese.TableID = t.TableID
    GROUP BY rest.RestaurantID, rest.Name, rest.City
)
SELECT 
    RANK() OVER (ORDER BY TotalReservations DESC) AS [Rank],
    RestaurantName AS [Restaurant Name],
    City,
    TotalReservations AS [Total Reservations]
FROM RestaurantReservations
ORDER BY [Rank];