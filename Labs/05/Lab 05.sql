CREATE TABLE department (
    dept_id     NUMBER PRIMARY KEY,
    dept_title  VARCHAR2(60) UNIQUE
);

CREATE TABLE faculty_info (
    faculty_id   NUMBER PRIMARY KEY,
    faculty_name VARCHAR2(60),
    dept_id      NUMBER REFERENCES department(dept_id),
    salary       NUMBER,
    join_date    DATE
);

CREATE TABLE course (
    course_id    NUMBER PRIMARY KEY,
    course_title VARCHAR2(60),
    dept_id      NUMBER REFERENCES department(dept_id),
    faculty_id   NUMBER REFERENCES faculty_info(faculty_id)
);

CREATE TABLE student (
    student_id NUMBER PRIMARY KEY,
    student_name VARCHAR2(60),
    dept_id NUMBER REFERENCES department(dept_id),
    gpa NUMBER(3,2),
    fees NUMBER
);

CREATE TABLE enrollment (
    student_id NUMBER REFERENCES student(student_id),
    course_id  NUMBER REFERENCES course(course_id)
);

-- Data Insertion
INSERT INTO department VALUES (1, 'Computer Science');
INSERT INTO department VALUES (2, 'Mathematics');
INSERT INTO department VALUES (3, 'Physics');

INSERT INTO faculty_info VALUES (101, 'Dr. Khan', 1, 120000, TO_DATE('2010-01-01','YYYY-MM-DD'));
INSERT INTO faculty_info VALUES (102, 'Dr. Ali', 2, 95000, TO_DATE('2015-03-15','YYYY-MM-DD'));
INSERT INTO faculty_info VALUES (103, 'Dr. Sara', 3, 150000, TO_DATE('2005-06-10','YYYY-MM-DD'));

INSERT INTO course VALUES (201, 'Database Systems', 1, 101);
INSERT INTO course VALUES (202, 'Calculus', 2, 102);
INSERT INTO course VALUES (203, 'Quantum Mechanics', 3, 103);
INSERT INTO course VALUES (204, 'Artificial Intelligence', 1, 101);

INSERT INTO student VALUES (301, 'Ali', 1, 3.8, 500000);
INSERT INTO student VALUES (302, 'Sara', 1, 3.2, 300000);
INSERT INTO student VALUES (303, 'Bilal', 2, 2.9, 200000);
INSERT INTO student VALUES (304, 'Hina', 3, 3.6, 450000);
INSERT INTO student VALUES (305, 'Usman', 1, 3.9, 600000);

INSERT INTO enrollment VALUES (301, 201);
INSERT INTO enrollment VALUES (301, 204);
INSERT INTO enrollment VALUES (302, 201);
INSERT INTO enrollment VALUES (303, 202);
INSERT INTO enrollment VALUES (304, 203);
INSERT INTO enrollment VALUES (305, 201);
INSERT INTO enrollment VALUES (305, 204);

-- Q1
SELECT d.dept_title, COUNT(s.student_id) total_students
FROM department d
LEFT JOIN student s ON s.dept_id = d.dept_id
GROUP BY d.dept_title;

-- Q2
SELECT d.dept_title, ROUND(AVG(s.gpa), 2) avg_gpa
FROM department d
JOIN student s ON s.dept_id = d.dept_id
GROUP BY d.dept_title
HAVING AVG(s.gpa) > 3.0;

-- Q3
SELECT c.course_title, AVG(st.fees) avg_fee
FROM course c
JOIN enrollment e ON e.course_id = c.course_id
JOIN student st ON e.student_id = st.student_id
GROUP BY c.course_title;

-- Q4
SELECT d.dept_title, COUNT(f.faculty_id) faculty_count
FROM department d
LEFT JOIN faculty_info f ON f.dept_id = d.dept_id
GROUP BY d.dept_title;

-- Q5
SELECT * 
FROM faculty_info
WHERE salary > (SELECT AVG(salary) FROM faculty_info);

-- Q6
SELECT *
FROM student
WHERE gpa > (
    SELECT MIN(gpa)
    FROM student
    WHERE dept_id = (SELECT dept_id FROM department WHERE dept_title = 'Computer Science')
);

-- Q7
SELECT student_id, student_name, gpa
FROM (
    SELECT student_id, student_name, gpa
    FROM student
    ORDER BY gpa DESC
)
WHERE ROWNUM <= 3;

-- Q8
SELECT s.student_id, s.student_name
FROM student s
WHERE NOT EXISTS (
    SELECT en.course_id 
    FROM enrollment en
    WHERE en.student_id = (SELECT student_id FROM student WHERE student_name = 'Ali' AND ROWNUM = 1)
    MINUS
    SELECT e.course_id
    FROM enrollment e
    WHERE e.student_id = s.student_id
);

-- Q9
SELECT d.dept_title, SUM(s.fees) total_fees
FROM department d
JOIN student s ON s.dept_id = d.dept_id
GROUP BY d.dept_title;

-- Q10
SELECT DISTINCT c.course_title
FROM course c
JOIN enrollment e ON e.course_id = c.course_id
JOIN student s ON s.student_id = e.student_id
WHERE s.gpa > 3.5;

-- Q11
SELECT d.dept_title, SUM(s.fees) total_fees
FROM department d
JOIN student s ON s.dept_id = d.dept_id
GROUP BY d.dept_title
HAVING SUM(s.fees) > 1000000;

-- Q12
SELECT d.dept_title, COUNT(f.faculty_id) AS rich_faculty
FROM department d
JOIN faculty_info f ON f.dept_id = d.dept_id
WHERE f.salary > 100000
GROUP BY d.dept_title
HAVING COUNT(f.faculty_id) > 5;

-- Q13
DELETE FROM student
WHERE gpa < (SELECT AVG(gpa) FROM student);

-- Q14
DELETE FROM course c
WHERE NOT EXISTS (
    SELECT 1 
    FROM enrollment e
    WHERE e.course_id = c.course_id
);

-- Q15
CREATE TABLE HighFeeStudents AS
SELECT *
FROM student
WHERE fees > (SELECT AVG(fees) FROM student);

-- Q16
CREATE TABLE RetiredFaculty AS SELECT * FROM faculty_info WHERE 1=0;

INSERT INTO RetiredFaculty
SELECT *
FROM faculty_info
WHERE join_date = (SELECT MIN(join_date) FROM faculty_info);

-- Q17
SELECT dept_title, total_fees
FROM (
    SELECT d.dept_title, SUM(s.fees) total_fees
    FROM department d
    JOIN student s ON s.dept_id = d.dept_id
    GROUP BY d.dept_title
    ORDER BY total_fees DESC
)
WHERE ROWNUM = 1;

-- Q18
SELECT * FROM (
    SELECT c.course_id, c.course_title, COUNT(e.student_id) AS total_enrolled
    FROM course c
    LEFT JOIN enrollment e ON c.course_id = e.course_id
    GROUP BY c.course_id, c.course_title
    ORDER BY total_enrolled DESC
)
WHERE ROWNUM <= 3;

-- Q19
SELECT s.student_id, s.student_name, s.gpa, COUNT(e.course_id) AS course_count
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
GROUP BY s.student_id, s.student_name, s.gpa
HAVING COUNT(e.course_id) > 3
AND s.gpa > (SELECT AVG(gpa) FROM student);

-- Q20
CREATE TABLE UnassignedFaculty AS SELECT * FROM faculty_info WHERE 1=0;

INSERT INTO UnassignedFaculty
SELECT f.*
FROM faculty_info f
WHERE NOT EXISTS (
    SELECT 1
    FROM course c
    WHERE c.faculty_id = f.faculty_id
);
