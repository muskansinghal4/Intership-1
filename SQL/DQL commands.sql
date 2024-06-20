-- DQL COMMANDS (Data Query Language)  DQL statements are used for performing queries on the data within schema objects. 
# GROUP BY, ORDER BY, HAVING BY, SELECT

-- making dtables and inserting values to solve DQL commands questions
CREATE TABLE customer ( cid INT PRIMARY KEY,cname VARCHAR(255),addr VARCHAR(255),age INT);
INSERT INTO customer (cid, cname, addr, age) VALUES (101, 'A', 'New York', 28),(102, 'B', 'Los Angeles', 34),(103, 'D', 'Chicago', 22),(104, 'C', 'Punjab', 40),(105, 'E', 'Paris', 25);
CREATE TABLE products (pid INT PRIMARY KEY,pname VARCHAR(255),price DECIMAL(10, 2),stock INT,location VARCHAR(255));
INSERT INTO products (pid, pname, price, stock, location) VALUES
(201, 'Laptop', 1000.00, 5, 'Mumbai'), (202, 'Smartphone', 500.00, 15, 'Delhi'), (203, 'Tablet', 300.00, 8, 'Mumbai'), (204, 'Monitor', 150.00, 20, 'Bangalore'), (205, 'Printer', 200.00, 2, 'Mumbai');
CREATE TABLE orders ( oid INT PRIMARY KEY, cid INT, pid INT, amount DECIMAL(10, 2), location VARCHAR(255),
    FOREIGN KEY (cid) REFERENCES customer(cid),
    FOREIGN KEY (pid) REFERENCES products(pid));
INSERT INTO orders (oid, cid, pid, amount, location) VALUES
(1, 101, 201, 1000.00, 'Mumbai'), (2, 102, 202, 500.00, 'Delhi'), (3, 103, 203, 300.00, 'Mumbai'), (4, 104, 204, 150.00, 'Bangalore'), (5, 105, 205, 200.00, 'Mumbai');

-- GROUP BY : the GROUP BY clause is used to group rows that have the same values into summary rows.
-- A) GROUP BY using HAVING
SELECT cname, COUNT(*) AS Number FROM customer GROUP BY cname HAVING Number >= 1;
-- B) GROUP BY using CONCAT Group Concat is used in MySQL to get concatenated values of expressions with more than one result per column.
SELECT location, GROUP_CONCAT(DISTINCT pname) AS product_names FROM products GROUP BY location;
-- C) GROUP BY can also be used order by while using aggregate function like COUNT, MAX, MIN, AVG, SUM, etc

-- ORDERBY
SELECT pid, pname, price FROM products ORDER BY price ASC;
SELECT cid, cname, age FROM customer ORDER BY age DESC;

-- HAVING BY
/* The HAVING clause in SQL is used in conjunction with the GROUP BY clause to filter groups based on a specified condition. It is applied to the summarized or aggregated rows after the 
   grouping has been done. The HAVING clause works similarly to the WHERE clause, but it operates on groups instead of individual rows. */
-- A) Find the products with a stock level less than 10.
SELECT pid, pname, stock FROM products GROUP BY pid, pname, stock HAVING stock < 10;
-- B) Find the locations where the total stock of products is greater than 50.
SELECT location, SUM(stock) AS total_stock FROM products GROUP BY location HAVING SUM(stock) > 50;

-- SELECT Used to retrieve rows selected from one or more tables.
-- A) SELECT With DISTINCT Clause The DISTINCT Clause after SELECT eliminates duplicate rows from the result set.
SELECT DISTINCT cname,addr FROM customer;
-- B) SELECT all columns(*)
SELECT * FROM orders;
-- C) SELECT by column name
SELECT oid FROM orders;
-- D) SELECT with LIKE(%)Basically helps in searching using some syllables of the name
-- a) "am" anywhere
SELECT * FROM customer WHERE cname LIKE "%am%";
-- b) Begins With "Sa"
SELECT * FROM customer WHERE cname LIKE "Sa%";
-- a) Ends With "ed"
SELECT * FROM customer WHERE cname LIKE "%ed";
-- E) SELECT with CASE or IF
-- a) CASE
SELECT cid, cname, CASE WHEN cid > 102 THEN 'Pass' ELSE 'Fail' END AS 'Remark' FROM customer;
-- b) IF
SELECT cid, cname, IF(cid > 102, 'Pass', 'Fail')AS 'Remark' FROM customer;
-- F) SELECT with a LIMIT Clause
SELECT * FROM customer ORDER BY cid LIMIT 2;
-- G) SELECT with WHERE
SELECT * FROM customer WHERE cname = "Ravi";

-- -----------------------------------------------QUESTIONS-----------------------------------------------------------
/*
	Question to practice given in content.
GROUP BY:
1) Write a query to find the total stock of products for each location.
SELECT location, SUM(stock) AS total_stock FROM products GROUP BY location;
2) Write a query to find the number of products in each price range (e.g., 0-10000, 10000-20000, 20000-50000, 50000+).
SELECT CASE 
 WHEN price BETWEEN 0 AND 10000 THEN '0-10000' 
 WHEN price BETWEEN 10001 AND 20000 THEN '10000-20000'
 WHEN price BETWEEN 20001 AND 50000 THEN '20000-50000' 
 ELSE '50000+' 
 END AS price_range, COUNT(*) AS product_count
 FROM products 
 GROUP BY price_range;
3) Write a query to find the average age of customers grouped by their location (based on the address).
SELECT SUBSTRING(addr, 1, 3) AS location, AVG(age) AS avg_age  FROM customer GROUP BY location;

ORDER BY:
1) Write a query to retrieve all products ordered by their price in descending order.
SELECT * FROM products ORDER BY price DESC;
2) Write a query to retrieve all customers ordered by their age in ascending order.
SELECT * FROM customer ORDER BY age ASC;
3) Write a query to retrieve all orders ordered by the order amount in descending order
   and then by the customer name in ascending order.
SELECT o.oid, c.cname, o.amt FROM orders o 
JOIN customer c ON o.cid = c.cid ORDER BY o.amt DESC, c.cname ASC;

HAVING:
1) Write a query to find the locations where the total stock of products is greater than 20.
SELECT location, SUM(stock) AS total_stock FROM products GROUP BY location HAVING SUM(stock) > 20;
2) Write a query to find the customers who have placed orders with a total amount greater than 10000.
SELECT c.cid, c.cname, SUM(o.amt) AS total_amount FROM customer c JOIN orders o ON c.cid = o.cid GROUP BY c.cid, c.cname HAVING SUM(o.amt) > 10000;
3) Write a query to find the products that have a stock level between 10 and 20 and are located in Mumbai.
SELECT p.pid, p.pname, p.stock FROM products p WHERE p.location = 'Mumbai' GROUP BY p.pid, p.pname, p.stock HAVING p.stock BETWEEN 10 AND 20;

SELECT:
1) Write a query to retrieve the distinct locations of products from the products table.
SELECT DISTINCT location FROM products;
2) Write a query to retrieve the customer ID, customer name, and the length of their address as address_length from the customer table.
SELECT cid, cname, LENGTH(addr) AS address_length FROM customer;
3) Write a query to retrieve the order ID, customer name, product name, and the concatenated string 'Order for [product name] by [customer name]' as order_description from the orders, customer,
   and products tables.
SELECT o.oid, c.cname, p.pname, CONCAT('Order for ', p.pname, ' by ', c.cname) AS order_description FROM orders o
JOIN customer c ON o.cid = c.cid
JOIN products p ON o.pid = p.pid;
4) Write a query to retrieve the product ID, product name, price, and a new column price_category that categorizes the products based on their price range (e.g., 'Low' for prices less than 10000, 'Medium' for prices between 10000
   and 50000, and 'High' for prices greater than 50000).
   SELECT pid, pname, price,
       CASE
           WHEN price < 10000 THEN 'Low'
           WHEN price BETWEEN 10000 AND 50000 THEN 'Medium'
           ELSE 'High'
       END AS price_category
FROM products;
5) Write a query to retrieve the customer ID, customer name, and the total order amount for each customer. The total order amount should be retrieved from a subquery that calculates the sum of order amounts for each customer.
SELECT c.cid, c.cname, (
    SELECT SUM(amt)
    FROM orders o
    WHERE o.cid = c.cid
) AS total_order_amount
FROM customer c;
*/
