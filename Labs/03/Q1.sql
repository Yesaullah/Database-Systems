CREATE TABLE employees (
    emp_id INTEGER,
    emp_name VARCHAR(30),
    salary NUMBER CHECK(salary > 20000),
    dept_id INTEGER,
    CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
