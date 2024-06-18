-- DDL (Data Definition Language) is a type of SQL command used to define data structures and modify data. 
-- It creates, alters, and deletes database objects such as tables, views, indexes, and users. 
-- Examples of DDL statements include CREATE, ALTER, DROP and TRUNCATE.

-- DML (Data Manipulation Language) is a type of SQL command used to manipulate data in a database. 
-- It inserts, updates, and deletes data from a database table. Examples of DML statements include INSERT, UPDATE, and DELETE. 
-- It focus on adding, updating, and deleting data within database tables.

create database flipkart;

use flipkart;

create table products
(
	product_id int(5) primary key,
    product_name varchar(30) not null,
    price int(6) not null,
    stock int(5),
    location varchar(30) check(location in ('Mumbai','Delhi'))
);

create table customer
(
	customer_id int(3) primary key,
    customer_name varchar(30) not null,
    age int(3),
    address varchar(50),
    phone int(10)
);

create table orders
(
	order_id int(3) primary key,
    customer_id int(3),
    product_id int(3),
    amt int(10) not null,
    foreign key(customer_id) references customer(customer_id),
    foreign key(product_id) references products(product_id)
);

create table payment
(
	payment_id int(3) primary key,
    order_id int(3),
    amount int(10) not null,
    mode varchar(30) check(mode in('upi','credit','debit')),
    status varchar(30),
    foreign key(order_id) references orders(order_id)
);

alter table customer
add phone int(10);

alter table customer
drop column phone;

alter table orders
rename column amt to amount ;

alter table products
modify column price varchar(10) ;

alter table products
modify column location varchar(30) check(location in ('Mumbai','Delhi' , 'chennai')) ;

-- TURNCATE
-- The TRUNCATE TABLE command deletes the data inside a table, but not the table itself.
-- truncate table products ;

alter table customer
modify column age int(2) not null;

alter table customer
modify column phone varchar(10) unique ;

alter table payment
modify column status varchar(30) check( status in ('pending' , 'cancelled' , 'completed'));

alter table products
modify column location varchar(30) default 'Mumbai' check(location in ('Mumbai','Delhi' , 'chennai')) ;


-- DML (Data Manipulation Language)

insert into products values(1,'HP Laptop',50000,15,'Mumbai');
insert into products values(2,'Realme Mobile',20000,30,'Delhi');
insert into products values(3,'Boat earpods',3000,50,'Delhi');
insert into products values(4,'Levono Laptop',40000,15,'Mumbai');

insert into customer (customer_id, customer_name, age, address) values
(101,'Ravi',30,'ravi001@gmail.com'),
(102,'Rahul',25,'rahul002@gmail.com'),
(103,'Simran',32,'simran002@gmail.com');

update product
set locaiton = 'chennai'
where product_name = 'Mac Book' ;

delete from customer
where customer_name = 'Ravi';

/* 
QUESTION
-- 0)Make a new table employee with specified column id, name, position and salary.
-- 1)insert query adds a new row to the employees table with specific values for id, name, position, and salary.
-- 2)update query updates the salary of the employee with id = 1.
-- 3)delete query deletes the row from employees where id = 1.
-- 4)create a query that creates a table called students.
-- 5)create another table courses and set up a foreign key constraint in the students table.
	The foreign key constraint ensures that the course_id in students must refer to a valid course_id in the courses table.
-- 6)Alter the students table to add the foreign key constraint.
-- 7)insert some data into the students table while respecting the constraints.
-- 8)create a SELECT query that retrieves products based on numeric and date conditions.
-- 9)update a record and set the last_updated column to the current datetime.
-- 10)delete products with stock below a certain threshold.
*/

create table employees
(
	id int(3) primary key,
    name varchar(30) not null,
    position varchar(30),
    salary int(8)
);

insert into employees (id, name, position, salary)
VALUES (1, 'Ravi', 'Software Engineer', 85000);

update employees set salary = 80000 where id = 1;

delete from employees where id = 1;

CREATE TABLE students (
  student_id INT PRIMARY KEY,       
  name VARCHAR(100) NOT NULL,        
  email VARCHAR(100) UNIQUE,       
  age INT CHECK (age >= 18),        
  course_id INT,                    
  grade CHAR(1) DEFAULT 'F'          
);

CREATE TABLE courses (
  course_id INT PRIMARY KEY,          
  course_name VARCHAR(100) NOT NULL,
  -- foreign key(course_id) references students(course_id)
);

-- Alter the students table to add the foreign key constraint
ALTER TABLE students
ADD CONSTRAINT fk_course
FOREIGN KEY (course_id)
REFERENCES courses (course_id)
ON DELETE CASCADE;  -- If a course is deleted, all related students are also deleted

INSERT INTO students (student_id, name, email, age, course_id, grade)
VALUES (1, 'Alice Johnson', 'alice@example.com', 21, 101, 'A');  
INSERT INTO students (student_id, name, email, age, course_id, grade)
VALUES (2, 'Bob Smith', 'bob@example.com', 22, 102, 'B');  

SELECT * FROM products WHERE price > 100 AND release_date > '2022-01-01';

UPDATE products SET price = 1100.00, last_updated = NOW()  WHERE product_id = 1;

DELETE FROM products WHERE stock < 100;
