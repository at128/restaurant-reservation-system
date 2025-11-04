DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Reservations;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS MenuItems;
DROP TABLE IF EXISTS Tables;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Restaurants;


CREATE TABLE Restaurants(
    RestaurantID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    PostalCode VARCHAR(20) NOT NULL,
    StreetAddress VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20),
    OpeningHours VARCHAR(100) NOT NULL
);

CREATE TABLE Employees(
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL DEFAULT GETDATE(),
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20),
    RestaurantID INT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
        ON DELETE NO ACTION  
        ON UPDATE CASCADE,
    CONSTRAINT CK_Employee_Position CHECK (
        Position IN ('Manager', 'VIPOrdersWaiter', 'StandardWaiter', 'AssistantWaiter')
    ),
    CONSTRAINT CK_Employee_Email CHECK (Email LIKE '%_@_%._%')
);

CREATE TABLE Tables(
    TableId INT PRIMARY KEY IDENTITY(1,1),
    RestaurantID INT NOT NULL,
    Capacity INT NOT NULL,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
        ON DELETE NO ACTION  
        ON UPDATE CASCADE,
    CONSTRAINT CK_Table_Capacity CHECK (Capacity > 0)
);

CREATE TABLE MenuItems(
    ItemId INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    RestaurantID INT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
        ON DELETE NO ACTION  
        ON UPDATE CASCADE,
    CONSTRAINT CK_MenuItem_Price CHECK (Price >= 0)
);

CREATE TABLE Customers(
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100) UNIQUE NOT NULL,
    CONSTRAINT CK_Customer_Email CHECK (Email LIKE '%_@_%._%')
);

CREATE TABLE Reservations(
    ReservationID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    TableID INT NOT NULL,
    ReservationDate DATETIME NOT NULL DEFAULT GETDATE(),
    PartySize INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        ON DELETE NO ACTION  
        ON UPDATE CASCADE,
    FOREIGN KEY (TableID) REFERENCES Tables(TableID)
        ON DELETE NO ACTION  
        ON UPDATE CASCADE,
    CONSTRAINT CK_Reservation_PartySize CHECK (PartySize > 0)
);

CREATE TABLE Orders(
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    ReservationID INT NOT NULL,
    EmployeeID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
        ON DELETE NO ACTION  
        ON UPDATE NO ACTION,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
        ON DELETE NO ACTION  
        ON UPDATE NO ACTION,
    CONSTRAINT CK_Order_TotalAmount CHECK (TotalAmount >= 0)
);

CREATE TABLE OrderItems(
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    MenuItemID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE NO ACTION  
        ON UPDATE CASCADE,
    FOREIGN KEY (MenuItemID) REFERENCES MenuItems(ItemId)
        ON DELETE NO ACTION  
        ON UPDATE CASCADE,
    CONSTRAINT CK_OrderItem_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_OrderItem_Price CHECK (UnitPrice >= 0)
);
