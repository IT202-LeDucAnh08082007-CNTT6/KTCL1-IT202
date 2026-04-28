CREATE DATABASE SalesManagement;

USE SalesManagement;

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(255)
);

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Manufacturer VARCHAR(100),
    Price DECIMAL(15, 2) NOT NULL CHECK (Price >= 0)
);

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    OrderCode VARCHAR(50) UNIQUE NOT NULL,
    CustomerID INT,
    OrderDate DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_order_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Order_Detail (
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(15, 2),
    PRIMARY KEY (OrderID, ProductID),
    CONSTRAINT fk_detail_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT fk_detail_product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

ALTER TABLE Orders ADD Note TEXT;

ALTER TABLE Products CHANGE Manufacturer NhaSanXuat VARCHAR(100);

INSERT INTO Customers (CustomerName, Email, Phone, Address) VALUES 
('Lê Đức Anh', 'ducanh@gmail.com', '098765432', 'Thủ Đức'),
('Nguyễn Văn A', 'vana@gmail.com', NULL, 'Hà Nội'),
('Trần Thị B', 'thib@gmail.com', '0912345678', 'TPHCM'),
('Phạm Minh C', 'minhc@gmail.com', NULL, 'Đà Nẵng'),
('Hoàng Lan', 'lan@gmail.com', '0988777666', 'Vũng Tàu');

INSERT INTO Products (ProductName, NhaSanXuat, Price) VALUES 
('iPhone 15 Pro', 'Apple', 28000000),
('MacBook Air M2', 'Apple', 24000000),
('Galaxy S23', 'Samsung', 18000000),
('Oppo Reno 10', 'Oppo', 12000000),
('iPad Pro M2', 'Apple', 21000000);

INSERT INTO Orders (OrderCode, CustomerID, OrderDate) VALUES 
('DH001', 1, '2026-04-01'),
('DH002', 3, '2026-04-02'),
('DH003', 1, '2026-04-03'),
('DH004', 5, '2026-04-04'),
('DH005', 2, '2026-04-05');

INSERT INTO Order_Detail (OrderID, ProductID, Quantity, UnitPrice) VALUES 
(1, 3, 1, 18000000),
(1, 4, 2, 12000000),
(2, 2, 1, 24000000),
(3, 1, 1, 28000000),
(4, 5, 1, 21000000);

UPDATE Products 
SET Price = Price * 1.1 
WHERE NhaSanXuat = 'Apple';

DELETE FROM Order_Detail
WHERE OrderID IN (SELECT OrderID FROM Orders WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE Phone IS NULL));

DELETE FROM Orders
WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE Phone IS NULL);

DELETE FROM Customers 
WHERE Phone IS NULL;

SELECT * FROM Products 
WHERE Price BETWEEN 10000000 AND 20000000;

SELECT o.OrderCode, p.ProductName, od.Quantity, od.UnitPrice, (od.Quantity * od.UnitPrice) AS Total
FROM Order_Detail od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderCode = 'DH001';

SELECT o.OrderCode, o.OrderDate 
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Address = 'TPHCM';

DROP TABLE Order_Detail;

DROP TABLE Orders;