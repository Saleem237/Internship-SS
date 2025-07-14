  create database Superstorestyle ; 
use Superstorestyle  ;
-- Customers Table
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  CustomerName VARCHAR(100),
  Gender VARCHAR(10),
  City VARCHAR(50),
  State VARCHAR(50)
);

-- Products Table
CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(100),
  Category VARCHAR(50),
  SubCategory VARCHAR(50),
  UnitPrice DECIMAL(10,2)
);

-- Stores Table
CREATE TABLE Stores (
  StoreID INT PRIMARY KEY,
  StoreName VARCHAR(100),
  StoreCity VARCHAR(50)
);

-- Inventory Table
CREATE TABLE Inventory (
  ProductID INT,
  UnitsInStock INT,
  ReorderLevel INT,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Sales Table
CREATE TABLE Sales (
  OrderID INT PRIMARY KEY,
  OrderDate DATE,
  CustomerID INT,
  ProductID INT,
  Quantity INT,
  TotalAmount DECIMAL(10,2),
  StoreID INT,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
  FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
);

#Insert into customers
INSERT INTO Customers VALUES (1, 'Justin Spencer', 'Male', 'Salazartown', 'Virginia');
INSERT INTO Customers VALUES (2, 'Ms. Judith Love MD', 'Female', 'Diazmouth', 'New Hampshire');
INSERT INTO Customers VALUES (3, 'Keith Chapman', 'Male', 'Allisonbury', 'Indiana');
INSERT INTO Customers VALUES (4, 'Beverly Williams', 'Male', 'Lake Jamesside', 'Indiana');
INSERT INTO Customers VALUES (5, 'Michael Elliott', 'Female', 'Teresaport', 'Maine');

#insert into products
INSERT INTO Products VALUES (1, 'Reason Mobile Phones', 'Electronics', 'Mobile Phones', 447.35);
INSERT INTO Products VALUES (2, 'Operation Mobile Phones', 'Electronics', 'Mobile Phones', 497.34);
INSERT INTO Products VALUES (3, 'Ball Laptops', 'Electronics', 'Laptops', 330.74);
INSERT INTO Products VALUES (4, 'Join Laptops', 'Electronics', 'Laptops', 325.04);
INSERT INTO Products VALUES (5, 'Task Headphones', 'Electronics', 'Headphones', 42.97);


#insert into stores
INSERT INTO Stores VALUES (1, 'James Inc', 'West Krystalmouth');
INSERT INTO Stores VALUES (2, 'Cummings and Sons', 'South Loriport');
INSERT INTO Stores VALUES (3, 'Davenport and Sons', 'New Allisonview');
INSERT INTO Stores VALUES (4, 'Cross Ltd', 'North Lori');
INSERT INTO Stores VALUES (5, 'Mills, Clark and Herring', 'Lake Teresamouth');


#insert into inventory
INSERT INTO Inventory VALUES (1, 57, 28);
INSERT INTO Inventory VALUES (2, 46, 24);
INSERT INTO Inventory VALUES (3, 190, 21);
INSERT INTO Inventory VALUES (4, 134, 28);
INSERT INTO Inventory VALUES (5, 58, 22);


#insert into sales
INSERT INTO Sales VALUES (1, '2024-12-28', 1, 1, 2, 894.70, 1);
INSERT INTO Sales VALUES (2, '2025-04-07', 2, 2, 3, 398.94, 2);
INSERT INTO Sales VALUES (3, '2024-08-24', 3, 3, 3, 617.22, 3);
INSERT INTO Sales VALUES (4, '2025-06-04', 4, 4, 2, 411.48, 4);
INSERT INTO Sales VALUES (5, '2025-05-11', 5, 5, 3, 1456.23, 5);

select *from customers;
select *from inventory;
select *from products;
select *from sales;
select *from stores;


#Repeat Customers
SELECT CustomerID, COUNT(*) AS Orders
FROM Sales
GROUP BY CustomerID
HAVING Orders >=1;

#Top Spending Customers
SELECT c.CustomerName, SUM(s.TotalAmount) AS TotalSpent
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC
LIMIT 5;


#Total Revenue by Category
SELECT Category, SUM(TotalAmount) AS TotalRevenue
FROM Sales
JOIN Products USING (ProductID)
GROUP BY Category;

#Monthly Sales Trend
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month, SUM(TotalAmount) AS Revenue
FROM Sales
GROUP BY Month
ORDER BY Month;

#Top 5 Products by Revenue
SELECT ProductName, SUM(TotalAmount) AS Revenue
FROM Sales
JOIN Products USING (ProductID)
GROUP BY ProductID
ORDER BY Revenue DESC
LIMIT 5;



#Revenue by Store
SELECT StoreName, SUM(TotalAmount) AS StoreRevenue
FROM Sales
JOIN Stores USING (StoreID)
GROUP BY StoreID;

#State-wise Revenue
SELECT c.State, SUM(s.TotalAmount) AS Revenue
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.State
ORDER BY Revenue DESC;