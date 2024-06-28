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

--Notes on Normalization 
-- Normalization Levels (1NF, 2NF, 3NF):
-- 1NF - First Normal Form
-- -> Multivalued attr should not be present
-- -> Primary key is present in the table
-- -> Repeating groups
-- -> Duplicate rows should not be there

-- 2NF - Second Normal Form
-- -> Should be in 1NF
-- -> No partial dependency - 
-- All non key attr should be completely dependent
-- on primary key 

-- 3NF 
-- Table must be in 2NF.
-- -> No transitive dependencies should exist.
-- -> Every non-key attribute must depend on the primary key, and only the primary key.
-- -> If a non-key attribute depends on another non-key attribute, it should be moved to a separate table along with the attribute it depends on.


-- Boyce-Codd Normal Form (BCNF):
-- How does BCNF differ from 3NF? When is it typically used?
-- BCNF (Boyce-Codd Normal Form) is a higher level of normalization compared to 3NF. It addresses a specific type of redundancy that 3NF might not eliminate.

-- Key Differences:

-- Dependency Rule:

-- 3NF: Eliminates transitive dependencies where a non-key attribute relies on another non-key attribute.
-- BCNF: Every determinant (attribute or set of attributes that determines another attribute) in a table must be a candidate key. This ensures there are no hidden dependencies beyond the primary key.
-- Strictness: BCNF is stricter than 3NF, requiring an additional condition for eliminating certain types of redundancies.


-- ANOMLIES
 --> Anomalies are undesirable conditions in a relational database that can lead to data inconsistency, which can lead to data manipulation.
 --> Insertion Anomalies: Occur when you cannot insert valid data due to the structure of the table.
 --> Deletion Anomalies: Occur when deleting a row also deletes unrelated data.
 --> Update Anomalies: Occur when updating a value in one row requires changes in other rows to maintain consistency, potentially leading to errors.
