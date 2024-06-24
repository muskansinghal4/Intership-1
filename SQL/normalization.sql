-- Normalization
--First Normal Form (1NF)
--A table should have atomic values and no repeating groups.
CREATE TABLE Products (
    pid INT(3) PRIMARY KEY,
    pname VARCHAR(50) NOT NULL,
    price INT(10) NOT NULL,
    stock INT(5),
    location VARCHAR(30) CHECK(location IN ('Mumbai', 'Delhi'))
);
-- Second Normal Form (2NF)
-- Eliminate partial dependencies.
-- Splitting Orders table to remove partial dependency
CREATE TABLE Orders (
    oid INT(3) PRIMARY KEY,
    cid INT(3),
    amt INT(10) NOT NULL,
    FOREIGN KEY (cid) REFERENCES Customer(cid)
);

CREATE TABLE Order_Items (
    order_item_id INT(3) PRIMARY KEY,
    oid INT(3),
    pid INT(3),
    product_color VARCHAR(20),
    FOREIGN KEY (oid) REFERENCES Orders(oid),
    FOREIGN KEY (pid) REFERENCES Products(pid)
);
-- Third Normal Form (3NF)
-- Eliminate transitive dependencies.
-- Removing transitive dependency by leveraging existing relationships
CREATE TABLE Orders (
    oid INT(3) PRIMARY KEY,
    cid INT(3),
    pid INT(3),
    amt INT(10) NOT NULL,
    FOREIGN KEY (cid) REFERENCES Customer(cid),
    FOREIGN KEY (pid) REFERENCES Products(pid)
);
-- Boyce-Codd Normal Form (BCNF)
-- Decomposing Orders table to remove BCNF violation
CREATE TABLE Order_Info (
    oid INT(3) PRIMARY KEY,
    amt INT(10) NOT NULL,
    FOREIGN KEY (oid) REFERENCES Orders(oid)
);

-- ANOMALIES

-- Update Anomaly
-- Updating the price of HP Laptop in the Products table
UPDATE Products
SET price = 52000
WHERE pid = 1;

-- The Orders table still contains old prices for HP Laptop orders
SELECT * FROM Orders WHERE pid = 1;

-- Delete Anomaly
-- Deleting the Charger from the Products table
DELETE FROM Products
WHERE pid = 5;

-- The Orders table now references a non-existent product
SELECT * FROM Orders WHERE pid = 5;

-- Insertion Anomaly
-- Attempting to insert an order for a non-existent customer
INSERT INTO Orders (oid, cid, pid, qty, amt)
VALUES (10005, 106, 2, 1, 18000);

-- This will fail because CustomerID 106 does not exist in the Customers table

