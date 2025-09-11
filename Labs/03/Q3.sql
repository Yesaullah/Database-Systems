SELECT constraint_name
FROM user_constraints
WHERE table_name = 'EMPLOYEES';

ALTER TABLE employees DROP CONSTRAINT SYS_C007037;

INSERT INTO employees (emp_id, full_name, salary, dept_id)
VALUES (1, 'Yesaullah', 5000, 1);

SELECT * FROM employees;
