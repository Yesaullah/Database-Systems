CREATE TABLE departments (
    dept_id    NUMBER PRIMARY KEY,
    dept_name  VARCHAR2(50) UNIQUE
);

CREATE TABLE faculty (
    faculty_id   NUMBER PRIMARY KEY,
    name         VARCHAR2(50),
    dept_id      NUMBER REFERENCES departments(dept_id),
    salary       NUMBER,
    joining_date DATE
);

CREATE TABLE courses (
    course_id   NUMBER PRIMARY KEY,
    course_name VARCHAR2(50),
    dept_id     NUMBER REFERENCES departments(dept_id),
    faculty_id  NUMBER REFERENCES faculty(faculty_id)
);

CREATE TABLE students (
    student_id NUMBER PRIMARY KEY,
    name       VARCHAR2(50),
    dept_id    NUMBER REFERENCES departments(dept_id),
    gpa        NUMBER(3,2),
    fee        NUMBER
);

CREATE TABLE enrollments (
    student_id NUMBER REFERENCES students(student_id),
    course_id  NUMBER REFERENCES courses(course_id)
);

-- Insert Data
INSERT INTO departments VALUES (1, 'CS');
INSERT INTO departments VALUES (2, 'Math');
INSERT INTO departments VALUES (3, 'Physics');

INSERT INTO faculty VALUES (101, 'Dr. Khan', 1, 120000, TO_DATE('2010-01-01','YYYY-MM-DD'));
INSERT INTO faculty VALUES (102, 'Dr. Ali', 2, 95000, TO_DATE('2015-03-15','YYYY-MM-DD'));
INSERT INTO faculty VALUES (103, 'Dr. Sara', 3, 150000, TO_DATE('2005-06-10','YYYY-MM-DD'));

INSERT INTO courses VALUES (201, 'DB Systems', 1, 101);
INSERT INTO courses VALUES (202, 'Calculus', 2, 102);
INSERT INTO courses VALUES (203, 'Quantum', 3, 103);
INSERT INTO courses VALUES (204, 'AI', 1, 101);

INSERT INTO students VALUES (301, 'Ali', 1, 3.8, 500000);
INSERT INTO students VALUES (302, 'Sara', 1, 3.2, 300000);
INSERT INTO students VALUES (303, 'Bilal', 2, 2.9, 200000);
INSERT INTO students VALUES (304, 'Hina', 3, 3.6, 450000);
INSERT INTO students VALUES (305, 'Usman', 1, 3.9, 600000);

INSERT INTO enrollments VALUES (301, 201);
INSERT INTO enrollments VALUES (301, 204);
INSERT INTO enrollments VALUES (302, 201);
INSERT INTO enrollments VALUES (303, 202);
INSERT INTO enrollments VALUES (304, 203);
INSERT INTO enrollments VALUES (305, 201);
INSERT INTO enrollments VALUES (305, 204);

-- Q1
SELECT d.dept_name, COUNT(s.student_id) AS total_students
FROM departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

-- Q2
SELECT d.dept_name, AVG(s.gpa) AS avg_gpa
FROM departments d
JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name
HAVING AVG(s.gpa) > 3.0;

-- Q3
SELECT c.course_name, AVG(s.fee) AS avg_fee
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN students s ON e.student_id = s.student_id
GROUP BY c.course_name;

-- Q4
SELECT d.dept_name, COUNT(f.faculty_id) AS faculty_count
FROM departments d
LEFT JOIN faculty f ON d.dept_id = f.dept_id
GROUP BY d.dept_name;

-- Q5
SELECT *
FROM faculty
WHERE salary > (SELECT AVG(salary) FROM faculty);

-- Q6
SELECT *
FROM students
WHERE gpa > (
    SELECT MIN(gpa)
    FROM students
    WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'CS')
);

-- Q7
SELECT student_id, name, gpa
FROM (
    SELECT student_id, name, gpa
    FROM students
    ORDER BY gpa DESC
)
WHERE ROWNUM <= 3;

-- Q8
SELECT s.student_id, s.name
FROM students s
WHERE NOT EXISTS (
    SELECT c.course_id
    FROM enrollments c
    WHERE c.student_id = (SELECT student_id FROM students WHERE name = 'Ali' AND ROWNUM = 1)
    MINUS
    SELECT e.course_id
    FROM enrollments e
    WHERE e.student_id = s.student_id
);

-- Q9
SELECT d.dept_name, SUM(s.fee) AS total_fees
FROM departments d
JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

-- Q10
SELECT DISTINCT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN students s ON e.student_id = s.student_id
WHERE s.gpa > 3.5;

-- Q11
SELECT d.dept_name, SUM(s.fee) AS total_fees
FROM departments d
JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name
HAVING SUM(s.fee) > 1000000;

-- Q12
SELECT d.dept_name, COUNT(f.faculty_id) AS high_salary_count
FROM departments d
JOIN faculty f ON d.dept_id = f.dept_id
WHERE f.salary > 100000
GROUP BY d.dept_name
HAVING COUNT(f.faculty_id) > 5;

-- Q13
DELETE FROM students
WHERE gpa < (SELECT AVG(gpa) FROM students);

-- Q14
DELETE FROM courses c
WHERE NOT EXISTS (
    SELECT 1 FROM enrollments e
    WHERE e.course_id = c.course_id
);

-- Q15
CREATE TABLE HighFee_Students AS
SELECT *
FROM students
WHERE fee > (SELECT AVG(fee) FROM students);

-- Q16
CREATE TABLE Retired_Faculty AS SELECT * FROM faculty WHERE 1=0;
INSERT INTO Retired_Faculty
SELECT *
FROM faculty
WHERE joining_date = (SELECT MIN(joining_date) FROM faculty);

-- Q17
SELECT dept_name, total_fees FROM (
    SELECT d.dept_name, SUM(s.fee) AS total_fees
    FROM departments d
    JOIN students s ON d.dept_id = s.dept_id
    GROUP BY d.dept_name
    ORDER BY total_fees DESC
)
WHERE ROWNUM = 1;

-- Q18
SELECT * FROM (
    SELECT c.course_id, c.course_name, COUNT(e.student_id) AS total_enrolled
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_id, c.course_name
    ORDER BY total_enrolled DESC
)
WHERE ROWNUM <= 3;

-- Q19
SELECT s.student_id, s.name, s.gpa, COUNT(e.course_id) AS total_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name, s.gpa
HAVING COUNT(e.course_id) > 3
   AND s.gpa > (SELECT AVG(gpa) FROM students);

-- Q20
CREATE TABLE Unassigned_Faculty AS SELECT * FROM faculty WHERE 1=0;
INSERT INTO Unassigned_Faculty
SELECT f.*
FROM faculty f
WHERE NOT EXISTS (
    SELECT 1
    FROM courses c
    WHERE c.faculty_id = f.faculty_id
);
