# 🍽️ Restaurant Management System Database

A comprehensive SQL Server database system for managing restaurant operations including reservations, orders, employees, and menu items.

> Developed as part of ASP.NET Core internship training with focus on clean architecture, SOLID principles, and performance optimization.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Database Schema](#database-schema)
- [Features](#features)
- [Setup Instructions](#setup-instructions)
- [Usage Examples](#usage-examples)
- [Performance Optimization](#performance-optimization)
- [Project Structure](#project-structure)
- [Technologies Used](#technologies-used)
- [Author](#author)
- [License](#license)

---

## 🎯 Overview

This database system provides a complete solution for restaurant management with support for:
- ✅ Multi-restaurant operations
- ✅ Table reservations and management
- ✅ Order processing and tracking
- ✅ Employee management with position-based roles
- ✅ Menu management with pricing
- ✅ Audit logging for reservations
- ✅ Performance-optimized queries (50-80% improvement)
- ✅ Scalable architecture for production use

**Project Type:** Training Project  
**Focus Areas:** Database Design, Query Optimization, Clean Architecture  
**Development Approach:** SOLID Principles, Best Practices

---

## 🗄️ Database Schema

### Core Tables

#### **Restaurants**
Stores restaurant information and locations.
- `RestaurantID` (PK) - Unique identifier
- `Name` - Restaurant name
- `City` - Location city
- `Address` - Full address
- `PhoneNumber` - Contact number
- `OpeningHours` - Operating hours

#### **Tables**
Manages restaurant tables and seating capacity.
- `TableID` (PK) - Unique table identifier
- `RestaurantID` (FK) - Restaurant reference
- `Capacity` - Number of seats

#### **Customers**
Stores customer contact information.
- `CustomerID` (PK) - Unique customer identifier
- `FirstName`, `LastName` - Customer name
- `Email` - Email address (Unique)
- `PhoneNumber` - Contact number

#### **Reservations**
Tracks table reservations.
- `ReservationID` (PK) - Unique reservation identifier
- `CustomerID` (FK) - Customer reference
- `TableID` (FK) - Table reference
- `ReservationDate` - Date and time of reservation
- `PartySize` - Number of guests

#### **Employees**
Manages restaurant staff.
- `EmployeeID` (PK) - Unique employee identifier
- `RestaurantID` (FK) - Restaurant reference
- `FirstName`, `LastName` - Employee name
- `Position` - Job role (VIPOrdersWaiter, StandardWaiter, AssistantWaiter, Manager)
- `Email` - Email address (Unique)

#### **MenuItems**
Stores menu items for each restaurant.
- `ItemId` (PK) - Unique menu item identifier
- `RestaurantID` (FK) - Restaurant reference
- `Name` - Item name
- `Description` - Item description
- `Price` - Item price

#### **Orders**
Tracks customer orders.
- `OrderID` (PK) - Unique order identifier
- `ReservationID` (FK) - Reservation reference
- `EmployeeID` (FK) - Server/waiter reference
- `OrderDate` - Order date and time
- `TotalAmount` - Total order value

#### **OrderItems**
Details of items in each order.
- `OrderItemID` (PK) - Unique order item identifier
- `OrderID` (FK) - Order reference
- `MenuItemID` (FK) - Menu item reference
- `Quantity` - Number of items ordered
- `UnitPrice` - Price per item at time of order

#### **AuditLog**
Audit trail for reservation changes.
- `AuditLogID` (PK) - Unique audit log identifier
- `RestaurantID` (FK) - Restaurant reference
- `TableID` (FK) - Table reference
- `ReservationDate` - Reservation date
- `ChangeDate` - Timestamp of change

### Entity Relationship Diagram

![ERD Diagram](erd/restaurant_erd.png)

**Key Relationships:**
- One Restaurant → Many Tables
- One Table → Many Reservations
- One Customer → Many Reservations
- One Reservation → Many Orders
- One Employee → Many Orders
- One Restaurant → Many MenuItems
- One Order → Many OrderItems

---

## ✨ Features

### 📊 Database Views

#### 1. vw_ReservationReport
Comprehensive view of all reservations with customer and restaurant details.

**Columns:**
- ReservationID, ReservationDate, PartySize
- Customer Name, Email, Phone
- Restaurant Name, City
- Table Number, Capacity

**Use Case:** Generate reservation reports for management

#### 2. vw_HighValueOrders
Filters orders with total amount greater than $100.

**Columns:**
- OrderID, OrderDate, TotalAmount
- Customer Name
- Restaurant Name
- Server Name

**Use Case:** Track high-value transactions for VIP service

---

### 🔧 Scalar Functions

#### 1. fn_CalculateRevenue(@RestaurantId INT)
Calculates total revenue for a specific restaurant.

**Parameters:**
- `@RestaurantId` - Restaurant ID

**Returns:** DECIMAL(18,2) - Total revenue

**Logic:** Sums all order amounts from employees working at the restaurant

**Example:**
```sql
SELECT dbo.fn_CalculateRevenue(1) AS Revenue;
```

#### 2. fn_CalculateEmployeeSalary(@EmployeeId INT)
Calculates employee salary based on orders handled and position rank.

**Parameters:**
- `@EmployeeId` - Employee ID

**Returns:** INT - Calculated salary

**Formula:** `Salary = Number of Orders × Position Rank`

**Position Ranks:**
- VIPOrdersWaiter: 5
- StandardWaiter: 4
- AssistantWaiter: 3
- Manager: 0 (salary not based on orders)

**Example:**
```sql
SELECT dbo.fn_CalculateEmployeeSalary(3) AS Salary;
```

---

### 🔄 Stored Procedures

#### 1. sp_ReservedTablesReport
Generates a report of tables reserved within a specified date range.

**Parameters:**
- `@StartDate` DATE - Start of date range (inclusive)
- `@EndDate` DATE - End of date range (exclusive)

**Features:**
- Date range validation
- Comprehensive reservation details
- Sorted by date and restaurant

**Example:**
```sql
EXEC sp_ReservedTablesReport 
    @StartDate = '2025-12-01',
    @EndDate = '2026-01-01';
```

#### 2. sp_AddNewOrder
Adds a new order with comprehensive validation.

**Parameters:**
- `@ReservationId` INT - Reservation ID
- `@EmployeeId` INT - Employee ID
- `@OrderDate` DATETIME - Order date/time
- `@TotalAmount` DECIMAL(10,2) - Order total

**Features:**
- Validates reservation exists
- Validates employee exists
- Validates amount is positive
- Returns new OrderID on success
- Error messages on failure

**Example:**
```sql
EXEC sp_AddNewOrder 
    @ReservationId = 5,
    @EmployeeId = 3,
    @OrderDate = '2025-12-25 19:00:00',
    @TotalAmount = 125.50;
```

#### 3. sp_FutureReservationsReport
Lists tables with future reservations using temporary table.

**Features:**
- Uses temporary table for intermediate results
- Shows tables with upcoming reservations
- Includes reservation count per table
- Demonstrates temp table usage

**Example:**
```sql
EXEC sp_FutureReservationsReport;
```

---

### ⚡ Database Triggers

#### trg_AuditReservation
Automatically logs reservation information to AuditLog table.

**Trigger Type:** AFTER INSERT on Reservations

**Functionality:**
- Captures RestaurantID, TableID, ReservationDate
- Records timestamp of reservation creation
- Supports bulk inserts (multiple rows)

**Use Case:** Audit trail for compliance and tracking

---

### 🚀 Query Collection

#### Basic Queries (5 queries)
1. **Customers with Reservations** - Lists all customers and their reservations
2. **Restaurant Details with Tables** - Restaurant info with table capacity
3. **Orders with Menu Items** - Order details with items ordered
4. **Employees by Restaurant** - Employee roster per restaurant
5. **Available Tables** - Tables without current reservations

#### Advanced Queries (3 queries)
1. **Reservations with Multiple Orders** - Uses CTE to find reservations with 2+ orders
2. **Restaurant Popularity Ranking** - Uses RANK() window function to rank restaurants by reservation count
3. **Popular Menu Items per Restaurant** - Uses nested CTEs and PARTITION BY to find top menu item per restaurant per month

---

## 🛠️ Setup Instructions

### Prerequisites
- **SQL Server 2019 or later**
- **SQL Server Management Studio (SSMS)**
- **Git** (for cloning repository)

### Installation Steps

#### 1. Clone the Repository
```bash
git clone https://github.com/at128/restaurant-management-db.git
cd restaurant-management-db
```

#### 2. Create Database
Open SSMS and execute:
```sql
CREATE DATABASE RestaurantDB;
GO
USE RestaurantDB;
GO
```

#### 3. Execute Schema
```sql
-- Run schema creation script
-- File: schema/create_tables.sql
-- Creates all 9 tables with relationships
```

#### 4. Seed Sample Data
```sql
-- Run seed data script
-- File: seed-data/insert_data.sql
-- Inserts sample data for testing
```

#### 5. Create Database Objects

**Execute in order:**
```sql
-- Views
:r views/01_reservation_report.sql
:r views/02_high_value_orders.sql

-- Functions
:r functions/01_calculate_revenue.sql
:r functions/02_calculate_employee_salary.sql

-- Stored Procedures
:r stored-procedures/01_reserved_tables_report.sql
:r stored-procedures/02_add_new_order.sql
:r stored-procedures/03_future_reservations_report.sql

-- Triggers
:r triggers/01_audit_reservation_trigger.sql

-- Performance Indexes
:r performance/01_indexes.sql
```

#### 6. Verify Installation
```sql
-- Check tables
SELECT name FROM sys.tables ORDER BY name;

-- Check views
SELECT name FROM sys.views ORDER BY name;

-- Check functions
SELECT name FROM sys.objects WHERE type = 'FN' ORDER BY name;

-- Check stored procedures
SELECT name FROM sys.procedures ORDER BY name;

-- Check triggers
SELECT name FROM sys.triggers ORDER BY name;

-- Check indexes
SELECT 
    t.name AS TableName,
    i.name AS IndexName
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name LIKE 'IX_%'
ORDER BY t.name;
```

---

## 📖 Usage Examples

### Viewing Reservations
```sql
-- All reservations with full details
SELECT * FROM vw_ReservationReport
ORDER BY [Reservation Date] DESC;

-- Reservations for specific date range
SELECT * FROM vw_ReservationReport
WHERE [Reservation Date] >= '2025-01-01'
  AND [Reservation Date] < '2025-02-01';
```

### High-Value Orders
```sql
-- View all orders over $100
SELECT * FROM vw_HighValueOrders
ORDER BY [Total Amount] DESC;
```

### Calculate Restaurant Revenue
```sql
-- Revenue for specific restaurant
SELECT dbo.fn_CalculateRevenue(1) AS [Restaurant Revenue];

-- Revenue for all restaurants
SELECT 
    r.RestaurantID,
    r.Name AS [Restaurant Name],
    r.City,
    dbo.fn_CalculateRevenue(r.RestaurantID) AS Revenue
FROM Restaurants r
ORDER BY Revenue DESC;
```

### Calculate Employee Salaries
```sql
-- Salary for specific employee
SELECT dbo.fn_CalculateEmployeeSalary(3) AS [Employee Salary];

-- Salaries for all employees
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS [Employee Name],
    e.Position,
    COUNT(o.OrderID) AS [Orders Handled],
    dbo.fn_CalculateEmployeeSalary(e.EmployeeID) AS [Calculated Salary]
FROM Employees e
LEFT JOIN Orders o ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Position
ORDER BY [Calculated Salary] DESC;
```

### Generate Reports
```sql
-- Reserved tables for next month
EXEC sp_ReservedTablesReport 
    @StartDate = '2025-12-01',
    @EndDate = '2026-01-01';

-- Tables reserved today
EXEC sp_ReservedTablesReport 
    @StartDate = CAST(GETDATE() AS DATE),
    @EndDate = DATEADD(day, 1, CAST(GETDATE() AS DATE));
```

### Add New Order
```sql
-- Create order with validation
EXEC sp_AddNewOrder 
    @ReservationId = 1,
    @EmployeeId = 5,
    @OrderDate = '2025-12-25 19:00:00',
    @TotalAmount = 125.50;

-- Result: Returns new OrderID or error message
```

### View Future Reservations
```sql
-- Tables with upcoming reservations
EXEC sp_FutureReservationsReport;
```

### Complex Queries
```sql
-- Most popular menu item per restaurant (October 2025)
-- File: advanced-queries/03_popular_menu_items.sql
DECLARE @year  INT = 2025;
DECLARE @month INT = 10;
-- ... (see file for full query)
```

---

## 🚀 Performance Optimization

### Overview
Comprehensive performance analysis conducted on 3 complex queries, resulting in **50-80% performance improvements** through strategic indexing.

### Indexes Created

| Index Name | Table | Purpose | Impact |
|------------|-------|---------|--------|
| IX_Orders_OrderDate | Orders | Date filtering | 90% improvement (39%→4%) |
| IX_OrderItems_OrderID | OrderItems | JOIN optimization | 48% improvement |
| IX_OrderItems_MenuItemID | OrderItems | JOIN optimization | Significant improvement |
| IX_MenuItems_RestaurantID | MenuItems | JOIN optimization | 67% improvement |
| IX_Tables_RestaurantID | Tables | JOIN optimization | 70% improvement |
| IX_Reservations_TableID | Reservations | JOIN optimization | 40% improvement |

### Key Achievements

#### Query 1: Orders with Menu Items
- **Status:** Already optimized (PK-based joins)
- **Result:** No additional indexes needed

#### Query 2: Restaurant Popularity Ranking
- **Before:** 2 full table scans (30% each)
- **After:** 2 index seeks (9%, 18%)
- **Improvement:** 50-70% faster

#### Query 3: Popular Menu Items (CRITICAL)
- **Before:** 3 full scans totaling 75% cost
- **After:** 3 scans totaling 20% cost
- **Major Win:** Orders bottleneck eliminated (39% → 4%)
- **Improvement:** 70-80% faster

### Why Scans Still Appear?
The Query Optimizer correctly chose scans over seeks for the current small dataset (~500 orders). As data grows beyond 10,000+ orders, the indexes will automatically switch to seeks for even better performance.

### Performance Testing
- **Tool:** SQL Server Execution Plans
- **Methodology:** Actual execution plans with statistics
- **Metrics:** Operator costs, logical reads, execution time
- **Documentation:** Full analysis in `performance/query_plans_analysis.md`

### Scalability
All indexes positioned to automatically provide optimal performance as data volume increases. Query plans will adapt dynamically based on data size.

[View detailed performance analysis](performance/query_plans_analysis.md)

---

## 📁 Project Structure
```
restaurant-management-db/
│
├── erd/
│   └── restaurant_erd.png                    # Entity Relationship Diagram
│
├── schema/
│   └── create_tables.sql                     # Database schema definition
│
├── seed-data/
│   └── insert_data.sql                       # Sample data for testing
│
├── queries/
│   ├── 01_customers_with_reservations.sql
│   ├── 02_restaurant_details_with_tables.sql
│   ├── 03_orders_with_menu_items.sql
│   ├── 04_employees_by_restaurant.sql
│   └── 05_available_tables.sql
│
├── views/
│   ├── 01_reservation_report.sql             # vw_ReservationReport
│   └── 02_high_value_orders.sql              # vw_HighValueOrders
│
├── advanced-queries/
│   ├── 01_reservations_multiple_orders.sql   # CTE example
│   ├── 02_restaurant_popularity.sql          # Window functions
│   └── 03_popular_menu_items.sql             # Nested CTEs + PARTITION BY
│
├── functions/
│   ├── 01_calculate_revenue.sql              # fn_CalculateRevenue
│   └── 02_calculate_employee_salary.sql      # fn_CalculateEmployeeSalary
│
├── stored-procedures/
│   ├── 01_reserved_tables_report.sql         # sp_ReservedTablesReport
│   ├── 02_add_new_order.sql                  # sp_AddNewOrder
│   └── 03_future_reservations_report.sql     # sp_FutureReservationsReport
│
├── triggers/
│   └── 01_audit_reservation_trigger.sql      # trg_AuditReservation
│
├── performance/
│   ├── 01_indexes.sql                        # Performance indexes
│   └── query_plans_analysis.md               # Detailed performance analysis
│
└── README.md                                  # This file
```

---

## 💻 Technologies Used

### Core Technologies
- **Database:** Microsoft SQL Server 2019+
- **Development Tool:** SQL Server Management Studio (SSMS)
- **Version Control:** Git & GitHub

### SQL Features Demonstrated

#### Database Design
- ✅ Normalized schema (3NF)
- ✅ Complex table relationships
- ✅ Foreign key constraints
- ✅ Primary key constraints
- ✅ Unique constraints
- ✅ Check constraints

#### Query Techniques
- ✅ Multi-table JOINs (INNER, LEFT, CROSS)
- ✅ Subqueries (correlated and non-correlated)
- ✅ Common Table Expressions (CTEs) - single and nested
- ✅ Window Functions (RANK, PARTITION BY, OVER)
- ✅ Aggregate Functions (COUNT, SUM, AVG)
- ✅ Date Functions (DATEFROMPARTS, DATEADD, GETDATE)
- ✅ String Functions (concatenation, formatting)

#### Database Objects
- ✅ Views for data abstraction
- ✅ Scalar functions for calculations
- ✅ Stored procedures with parameters and validation
- ✅ AFTER triggers for audit logging
- ✅ Temporary tables (#temp)

#### Performance Optimization
- ✅ Non-clustered indexes
- ✅ Covering indexes (INCLUDE clause)
- ✅ Composite indexes
- ✅ Index usage analysis
- ✅ Execution plan analysis
- ✅ Statistics management
- ✅ Query optimization techniques

#### Best Practices
- ✅ SET NOCOUNT ON in procedures
- ✅ Error handling (RAISERROR, TRY-CATCH)
- ✅ Parameter validation
- ✅ Transaction handling
- ✅ No SELECT * (explicit column selection)
- ✅ Meaningful aliases
- ✅ Comprehensive comments
- ✅ Consistent naming conventions

---

## 👨‍💻 Author

**Atta Mazen Atta Alarayshi**

- 🎓 ASP.NET Core Intern
- 💼 Focus: Clean Architecture, SOLID Principles, Database Design
- 📧 Email: mr.attamazen@gmail.com 
- 💻 GitHub: [@at128](https://github.com/at128)

### About This Project

This database was developed as part of my ASP.NET Core internship training program. The project demonstrates:
- Professional database design principles
- Advanced SQL programming techniques
- Performance optimization strategies
- Clean architecture implementation
- SOLID principles in database design
- Real-world problem-solving approaches

**Training Goals Achieved:**
- ✅ Learned requirement gathering and analysis
- ✅ Designed normalized database schemas
- ✅ Implemented complex business logic
- ✅ Optimized query performance
- ✅ Followed industry best practices
- ✅ Created comprehensive documentation

---

## 📄 License

This project is licensed under the MIT License - see below for details.
```
MIT License

Copyright (c) 2025 Atta Mazen Atta Alarayshi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Acknowledgments

- Developed as part of ASP.NET Core internship training program
- Focus on learning clean architecture and SOLID principles
- Performance optimization based on real-world scenarios
- Special thanks to my training supervisors and mentors

---



<div align="center">

**⭐ Star this repository if you find it helpful!**

Made with ❤️ for learning and professional growth

</div> 