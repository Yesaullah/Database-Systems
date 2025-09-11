CREATE TABLE departments(
    dept_id INTEGER PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE
);

INSERT INTO departments VALUES (1, 'AI');
INSERT INTO departments VALUES (2, 'CS');
INSERT INTO departments VALUES (3, 'SE');