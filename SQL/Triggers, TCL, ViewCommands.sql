CREATE DATABASE studentDB;
USE studentDB;

CREATE TABLE students (
    sid INT(3) PRIMARY KEY,
    sname VARCHAR(50) NOT NULL,
    age INT(3),
    addr VARCHAR(100)
);


CREATE TABLE courses (
    cid INT(3) PRIMARY KEY,
    cname VARCHAR(50) NOT NULL,
    credits INT(2) CHECK(credits > 0)
);


CREATE TABLE enrollments (
    eid INT(3) PRIMARY KEY,
    sid INT(3),
    cid INT(3),
    enrollment_date DATE,
    FOREIGN KEY(sid) REFERENCES students(sid),
    FOREIGN KEY(cid) REFERENCES courses(cid)
);


CREATE TABLE grades (
    gid INT(3) PRIMARY KEY,
    eid INT(3),
    grade CHAR(1) CHECK(grade IN ('A', 'B', 'C', 'D', 'F')),
    FOREIGN KEY(eid) REFERENCES enrollments(eid)
);


INSERT INTO students VALUES
(1, 'Alice', 20, '123 Main St'),
(2, 'Bob', 22, '456 Maple Ave'),
(3, 'Charlie', 19, '789 Oak Dr');


INSERT INTO courses VALUES
(101, 'Mathematics', 3),
(102, 'Physics', 4),
(103, 'Chemistry', 4);


INSERT INTO enrollments VALUES
(1, 1, 101, '2024-01-15'),
(2, 2, 102, '2024-01-16'),
(3, 3, 103, '2024-01-17');


INSERT INTO grades VALUES
(1, 1, 'A'),
(2, 2, 'B'),
(3, 3, 'C');

-- TCL Commands
-- Commit the current transaction
COMMIT;

-- Rollback the current transaction
ROLLBACK;

-- Savepoint
SAVEPOINT a;
ROLLBACK TO a;

-- Create Triggers
-- Trigger to log student insertions
DELIMITER //
CREATE TRIGGER students_after_insert
AFTER INSERT ON students
FOR EACH ROW
BEGIN
    INSERT INTO student_log (sid, sname, age, addr, inserted_at)
    VALUES (NEW.sid, NEW.sname, NEW.age, NEW.addr, NOW());
END //
DELIMITER ;

-- Trigger to prevent duplicate enrollments
DELIMITER //
CREATE TRIGGER prevent_duplicate_enrollments
BEFORE INSERT ON enrollments
FOR EACH ROW
BEGIN
    DECLARE enrollment_count INT;
    SELECT COUNT(*) INTO enrollment_count FROM enrollments WHERE sid = NEW.sid AND cid = NEW.cid;
    IF enrollment_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student is already enrolled in this course';
    END IF;
END //
DELIMITER ;

-- Trigger to automatically set grade 'F' if not specified
DELIMITER //
CREATE TRIGGER set_default_grade
BEFORE INSERT ON grades
FOR EACH ROW
BEGIN
    IF NEW.grade IS NULL THEN
        SET NEW.grade = 'F';
    END IF;
END //
DELIMITER ;

-- Additional Triggers for Specific Questions
-- 1) Trigger to update student address change log
DELIMITER //
CREATE TRIGGER students_after_update
AFTER UPDATE ON students
FOR EACH ROW
BEGIN
    IF OLD.addr <> NEW.addr THEN
        INSERT INTO student_log (sid, sname, age, addr, updated_at)
        VALUES (OLD.sid, OLD.sname, OLD.age, OLD.addr, NOW());
    END IF;
END //
DELIMITER ;

-- 2) Trigger to log course deletions
DELIMITER //
CREATE TRIGGER courses_after_delete
AFTER DELETE ON courses
FOR EACH ROW
BEGIN
    INSERT INTO course_log (cid, cname, credits, deleted_at)
    VALUES (OLD.cid, OLD.cname, OLD.credits, NOW());
END //
DELIMITER ;

-- Views
-- 1) Create a view that displays students with their corresponding enrollments and grades
CREATE VIEW StudentEnrollments AS
SELECT s.sid, s.sname, e.eid, c.cname, g.grade
FROM students s
JOIN enrollments e ON s.sid = e.sid
JOIN courses c ON e.cid = c.cid
LEFT JOIN grades g ON e.eid = g.eid;

-- 2) Create or replace view to show course enrollments with student details
CREATE OR REPLACE VIEW CourseEnrollments AS
SELECT c.cid, c.cname, s.sid, s.sname, e.enrollment_date
FROM courses c
JOIN enrollments e ON c.cid = e.cid
JOIN students s ON e.sid = s.sid;

-- 3) Drop view if it exists
DROP VIEW IF EXISTS CourseEnrollments;

-- TCL Commands for Specific Questions
-- 1) Saving the command permanently after running successfully
START TRANSACTION;
INSERT INTO students (sid, sname, age, addr) VALUES (4, 'David', 21, '321 Birch St');
INSERT INTO enrollments (eid, sid, cid, enrollment_date) VALUES (4, 4, 101, '2024-01-20');
INSERT INTO grades (gid, eid, grade) VALUES (4, 4, 'B');
COMMIT;

-- 2) Going to previous command
START TRANSACTION;
INSERT INTO students (sid, sname, age, addr) VALUES (4, 'David', 21, '321 Birch St');
INSERT INTO enrollments (eid, sid, cid, enrollment_date) VALUES (4, 4, 101, '2024-01-20');
INSERT INTO grades (gid, eid, grade) VALUES (4, 4, 'B');
ROLLBACK;

-- 3) Going to a checkpoint
START TRANSACTION;
INSERT INTO students (sid, sname, age, addr) VALUES (4, 'David', 21, '321 Birch St');
INSERT INTO enrollments (eid, sid, cid, enrollment_date) VALUES (4, 4, 101, '2024-01-20');
INSERT INTO grades (gid, eid, grade) VALUES (4, 4, 'B');
SAVEPOINT A;
ROLLBACK TO A;
