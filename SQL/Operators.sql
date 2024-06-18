CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gpa DECIMAL(3, 2),
    major VARCHAR(50),
    class VARCHAR(20)
);
INSERT INTO students (student_id, name, age, gpa, major, class) VALUES
(1, 'Abhay', 20, 3.5, 'Computer Science', 'junior'),
(2, 'Aman', 22, 3.8, 'Mathematics', 'senior'),
(3, 'Richa', 18, 2.9, 'Engineering', 'freshman'),
(4, 'Riya', 19, 3.2, 'Physics', 'sophomore'),
(5, 'Rohan', 21, 3.0, 'Chemistry', 'junior'),
(6, 'Ritu', 17, 2.5, 'Biology', 'freshman'),
(7, 'Khushi', 23, 4.0, 'Computer Science', 'senior'),
(8, 'Sunny', 20, 3.1, 'Mechanical Engineering', 'junior');

-- OPERATORS
-- 4 types of Operators:-
-- a) Arithmetic Operators(+,-,*,/,%)
-- b) Comparison Operators(=,>,<,>=,<=,<>/ or !=)
-- c) Bitwise Operators(&,|,^)
-- d) Logical Operators(AND, ALL, ANY, BETWEEN, EXISTS, IN, LIKE, NOT, OR, SOME)

-- A) ARITHMETIC OPERATORS
SELECT 5+3;
SELECT 5-3;
SELECT 5*3;
SELECT 5/3;
SELECT 5%3; -- gives remainder

-- B) COMPARISON OPERATORS (TRUE OR FALSE)
SELECT 5=5;
SELECT 5>3;
SELECT 3<5;
SELECT 5>=5;
SELECT 5<=6;
SELECT 5<>6;
-- Questions
-- = (Equal): Select students whose GPA is exactly 4.0
SELECT * FROM students WHERE gpa = 4.0;
-- > (Greater Than): Select students who are older than 21
SELECT * FROM students WHERE age > 21;
-- < (Less Than): Select students who have a GPA less than 2.5
SELECT * FROM students WHERE gpa < 2.5;
-- >= (Greater Than or Equal To): Select students who are at least 18 years old
SELECT * FROM students WHERE age >= 18;
-- <= (Less Than or Equal To): Select students who have a GPA of 3.0 or lower
SELECT * FROM students WHERE gpa <= 3.0;
-- <> (Not Equal): Select students who are not in the 'freshman' class
SELECT * FROM students WHERE class <> 'freshman';
-- != (Not Equal): Select students who are not in the 'freshman' class
SELECT * FROM students WHERE class != 'freshman';
-- = (Equal): Select students whose GPA is exactly 4.0
SELECT * FROM students WHERE gpa = 4.0;
-- > (Greater Than): Select students who are older than 21
SELECT * FROM students WHERE age > 21;
-- < (Less Than): Select students who have a GPA less than 2.5
SELECT * FROM students WHERE gpa < 2.5;
-- >= (Greater Than or Equal To): Select students who are at least 18 years old
SELECT * FROM students WHERE age >= 18;
-- <= (Less Than or Equal To): Select students who have a GPA of 3.0 or lower
SELECT * FROM students WHERE gpa <= 3.0;
-- <> or != (Not Equal): Select students who are not in the 'freshman' class
SELECT * FROM students WHERE class <> 'freshman';
SELECT * FROM students WHERE class != 'freshman';

-- C) BITWISE OPERATORS
-- & (Bitwise AND): Select students where the bitwise AND of their id and a given value (e.g., 2) is not zero
SELECT * FROM students WHERE id & 2 != 0;
-- | (Bitwise OR): Select students where the bitwise OR of their id and a given value (e.g., 1) equals a specific value (e.g., 3)
SELECT * FROM students WHERE (id | 1) = 3;
-- ^ (Bitwise XOR): Select students where the bitwise XOR of their id and a given value (e.g., 1) equals a specific value (e.g., 2)
SELECT * FROM students WHERE (id ^ 1) = 2;

-- D) LOGICAL OPERATORS (TRUE OR FALSE)
-- AND: Select students who are older than 18 and have a GPA greater than 3.0
SELECT * FROM students WHERE age > 18 AND gpa > 3.0;
-- ALL: Select students whose GPA is higher than all students in the 'roll' table
SELECT * FROM students WHERE gpa > ALL (SELECT gpa FROM roll);
-- ANY: Select students whose GPA is higher than any student in the 'roll' table
SELECT * FROM students WHERE gpa > ANY (SELECT gpa FROM roll);
-- BETWEEN: Select students who are between the ages of 18 and 22
SELECT * FROM students WHERE age BETWEEN 18 AND 22;
-- EXISTS: Select students who have registered for at least one course
SELECT * FROM students WHERE EXISTS (SELECT 1 FROM course_registrations WHERE students.student_id = course_registrations.student_id);
-- IN: Select students who are in specific majors
SELECT * FROM students WHERE major IN ('Computer Science', 'Mathematics', 'English');
-- LIKE: Select students whose names start with 'A'
SELECT * FROM students WHERE name LIKE 'A%';
-- NOT: Select students who are not in the 10th class
SELECT * FROM students WHERE NOT class = '10';
-- OR: Select students who are either under 18 or have a GPA lower than 2.5
SELECT * FROM students WHERE age < 18 OR gpa < 2.5;
-- SOME: Select students whose GPA is higher than some of the students in the 'roll' table
SELECT * FROM students WHERE gpa > SOME (SELECT gpa FROM roll);
