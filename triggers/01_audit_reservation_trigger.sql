-- ========================================
-- Trigger: trg_AuditReservation
-- ========================================
-- Description: Logs reservation into AuditLog table
--              Triggered on INSERT into Reservations
-- ========================================

CREATE TABLE AuditLog (
    AuditLogID INT IDENTITY(1,1) PRIMARY KEY,
    RestaurantID INT NOT NULL,
    TableID INT NOT NULL,
    ReservationDate DATETIME NOT NULL,
    ChangeDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    FOREIGN KEY (TableID) REFERENCES Tables(TableID)
);
GO


DROP TRIGGER IF EXISTS trg_AuditReservation;
GO

CREATE TRIGGER trg_AuditReservation
ON Reservations
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Insert into AuditLog
    INSERT INTO AuditLog (RestaurantID, TableID, ReservationDate, ChangeDate)
    SELECT 
        t.RestaurantID,        -- Get RestaurantID from Tables
        i.TableID,             -- From INSERTED table
        i.ReservationDate,     -- From INSERTED table
        GETDATE()              -- Current timestamp
    FROM INSERTED i
    INNER JOIN Tables t ON i.TableID = t.TableID;
END;
GO