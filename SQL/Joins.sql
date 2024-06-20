#JOINS
#Joins are used to combine two or more tables to get specific data/information. Join is mainly of 6 types:
#1. Inner Join -> Matching values from both tables should be present
#2. Left Outer Join -> All the rows from the left table should be present and matching rows from the right table are present
#3. Right Outer Join -> All the rows from the right table should be present and only matching rows from the left table are present 
#4. Full Outer Join
#5. Self Join
#6. Cross Join

CREATE DATABASE students_marks;
USE students_marks;

CREATE TABLE students (
    sid INT PRIMARY KEY,
    sname VARCHAR(50) NOT NULL,
    age INT
);

CREATE TABLE marks (
    mid INT PRIMARY KEY,
    sid INT,
    subject VARCHAR(50),
    marks INT,
    FOREIGN KEY (sid) REFERENCES students(sid)
);

INSERT INTO students VALUES
    (1, 'Akshay', 18),
    (2, 'Akhil', 19),
    (3, 'Bunny', 20),
    (4, 'Clara', 21),
    (5, 'Riya', 22);
INSERT INTO marks VALUES
    (1, 1, 'Math', 80),
    (2, 1, 'Science', 90),
    (3, 2, 'Math', 85),
    (4, 2, 'Science', 95),
    (5, 3, 'Math', 78),
    (6, 3, 'Science', 92),
    (7, 4, 'Math', 88),
    (8, 4, 'Science', 98),
    (9, 5, 'Math', 92),
    (10, 5, 'Science', 96);

#1.Inner Join 
SELECT students.sid, sname, marks.marks FROM students
INNER JOIN marks ON students.sid = marks.sid;

#2. Left Outer Join
SELECT students.sid, sname, marks.marks FROM students
LEFT JOIN marks ON students.sid = marks.sid;

#3. Right Join
SELECT students.sid, sname, marks.marks FROM students
RIGHT JOIN marks ON students.sid = marks.sid;
 
#4.Full Join-> All the rows from both the table should be present 
#Note:- MySQL does not support full join we need to perform "UNION" operation between the results obtained from left and right join
SELECT students.sid, sname, marks.marks FROM students
LEFT JOIN marks ON students.sid = marks.sid
UNION
SELECT students.sid, sname, marks.marks FROM students
RIGHT JOIN marks ON students.sid = marks.sid;
 
#5.Self Join-> It is a regular join, but the table is joined by itself
SELECT s1.sname AS Student1, s2.sname AS Student2 FROM students s1
INNER JOIN students s2 ON s1.sid = s2.sid + 1;

#6.Cross Join-> It is used to view all the possible combinations of the rows of one table and with all the rows from second table
SELECT students.sid, sname, marks.marks FROM students
CROSS JOIN marks;

# ***************************************************** Practice Questions *******************************************
#For practice ques, created a database with tables and records in it.
CREATE DATABASE order_management;
USE order_management;
CREATE TABLE products ( pid INT PRIMARY KEY, pname VARCHAR(255));
INSERT INTO products (pid, pname) VALUES (201, 'Laptop'), (202, 'Smartphone'), (203, 'Tablet'), (204, 'Monitor'), (205, 'Printer');
CREATE TABLE customer ( cid INT PRIMARY KEY, cname VARCHAR(255), age INT );
INSERT INTO customer (cid, cname, age) VALUES(101, 'John', 28), (102, 'Alice', 34), (103, 'Bob', 22), (104, 'Charlie', 40), (105, 'Eve', 25);
CREATE TABLE orders ( oid INT PRIMARY KEY, cid INT, pid INT, amount DECIMAL(10, 2), location VARCHAR(255), FOREIGN KEY (cid) REFERENCES customer(cid), FOREIGN KEY (pid) REFERENCES products(pid) );
INSERT INTO orders (oid, cid, pid, amount, location) VALUES (1, 101, 201, 1000, 'Mumbai'), (2, 102, 202, 1500, 'Delhi'), (3, 103, 203, 2000, 'Mumbai'), (4, 104, 204, 2500, 'Bangalore'), (5, 105, 205, 3000, 'Mumbai');
CREATE TABLE payment (oid INT PRIMARY KEY, mode VARCHAR(255), status VARCHAR(255), amt DECIMAL(10, 2), FOREIGN KEY (oid) REFERENCES orders(oid) );
INSERT INTO payment (oid, mode, status, amt) VALUES (1, 'UPI', 'completed', 1000), (2, 'Credit', 'completed', 1500), (3, 'UPI', 'in process', 2000), (4, 'Debit', 'completed', 2500), (5, 'Credit', 'pending', 3000);

#q1. Display details of all orders which were delivered from "Mumbai"
SELECT * FROM orders  LEFT JOIN products ON orders.pid = products.pid WHERE location = "Mumbai";

#q2. Display details of all orders whose payment was made through "UPI"
SELECT * FROM orders RIGHT JOIN payment ON orders.oid = payment.oid WHERE mode = "UPI";

#q3. Dispaly oid, amt, cname, payment mode of orders which were made by people below 30 years
SELECT orders.oid, cname, amt, mode FROM orders 
INNER JOIN payment ON orders.oid = payment.oid
INNER JOIN customer ON orders.cid = customer.cid WHERE age < 30;

#q4. Dispaly oid, amt, cname, paymentmode of orders which were made by people below 30 years and payment was made through "Credit"
SELECT orders.oid, cname, amt, mode FROM orders
INNER JOIN payment ON orders.oid = payment.oid
INNER JOIN customer ON orders.cid = customer.cid WHERE age < 30 AND mode = "Credit";

#q5. Display oid, amount, cname, pname, location of the orders whose payment is still pending or in process
SELECT orders.oid, cname, pname, amount, status, location FROM orders
CROSS JOIN products ON orders.pid = products.pid
CROSS JOIN customer ON orders.cid = customer.cid
CROSS JOIN payment ON orders.oid = payment.oid WHERE status IN ("in process", "pending");

#q6. We have order table, want to also display details of product ordered and details of customer who placed the order
SELECT orders.cid, cname, pname FROM orders
INNER JOIN customer ON orders.cid = customer.cid
INNER JOIN products ON orders.pid = products.pid;