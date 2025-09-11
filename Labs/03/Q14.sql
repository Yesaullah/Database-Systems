ALTER TABLE employees DROP CONSTRAINT fk_emp_dept;

INSERT INTO employees (emp_id, full_name, salary, dept_id, age, email)
VALUES (5, 'Invalid Dept', 25000, 99, 25, 'invalid@test.com');

ALTER TABLE employees
ADD CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id)
REFERENCES departments(dept_id);
