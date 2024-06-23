-- few changes required
CREATE DATABASE student_management;
USE student_management;
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL
);
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    fee DECIMAL(10,2) NOT NULL
);
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status ENUM('Pending', 'Enrolled', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    status ENUM('Pending', 'Paid') DEFAULT 'Pending',
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);
INSERT INTO students (student_id, name, email, phone)
VALUES
    (1, 'Aman', 'aman001@gamil.com', '1234567890'),
    (2, 'Arjun', 'arjun1@gmail.com', '0987654321'),
    (3, 'Abhay', 'abhayyy@gmail.com', '5555555555');
INSERT INTO courses (course_id, name, description, fee)
VALUES
    (1, 'Mathematics', 'Basic Math Course', 200.00),
    (2, 'Science', 'Basic Science Course', 300.00),
    (3, 'History', 'World History Course', 150.00);
INSERT INTO enrollments (student_id, course_id, enrollment_date, status)
VALUES
    (1, 1, '2024-06-01', 'Enrolled'),
    (2, 2, '2024-06-02', 'Completed'),
    (3, 3, '2024-06-03', 'Cancelled');
INSERT INTO payments (enrollment_id, amount, payment_date, status)
VALUES
    (1, 200.00, '2024-06-01', 'Paid'),
    (2, 300.00, '2024-06-02', 'Paid'),
    (3, 150.00, '2024-06-03', 'Paid');

-- Procedure to create a new enrollment
DELIMITER //

CREATE PROCEDURE create_enrollment(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_enrollment_date DATE,
    IN p_status ENUM('Pending', 'Enrolled', 'Completed', 'Cancelled')
)
BEGIN
    INSERT INTO enrollments (student_id, course_id, enrollment_date, status)
    VALUES (p_student_id, p_course_id, p_enrollment_date, p_status);
END //

DELIMITER ;

-- Function to calculate the total revenue
DELIMITER //

CREATE FUNCTION get_total_revenue()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_revenue DECIMAL(10,2);
    SELECT SUM(amount) INTO total_revenue
    FROM payments
    WHERE status = 'Paid';
    RETURN total_revenue;
END //

DELIMITER ;

-- Procedure to display all enrollments
DELIMITER //

CREATE PROCEDURE display_enrollments()
BEGIN
    DECLARE v_enrollment_id INT;
    DECLARE v_student_id INT;
    DECLARE v_course_id INT;
    DECLARE v_enrollment_date DATE;
    DECLARE v_status ENUM('Pending', 'Enrolled', 'Completed', 'Cancelled');
    DECLARE done INT DEFAULT FALSE;
    DECLARE enrollment_cursor CURSOR FOR
        SELECT enrollment_id, student_id, course_id, enrollment_date, status
        FROM enrollments;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN enrollment_cursor;

    get_enrollments: LOOP
        FETCH enrollment_cursor INTO v_enrollment_id, v_student_id, v_course_id, v_enrollment_date, v_status;
        IF done THEN
            LEAVE get_enrollments;
        END IF;
        SELECT
            v_enrollment_id AS 'Enrollment ID',
            (SELECT name FROM students WHERE student_id = v_student_id) AS 'Student Name',
            (SELECT name FROM courses WHERE course_id = v_course_id) AS 'Course Name',
            v_enrollment_date AS 'Enrollment Date',
            v_status AS 'Status';
    END LOOP get_enrollments;

    CLOSE enrollment_cursor;
END //

DELIMITER ;

-- Call the procedures and function
CALL create_enrollment(1, 2, '2024-06-04', 'Enrolled');
SELECT get_total_revenue() AS TotalRevenue;
CALL display_enrollments();
