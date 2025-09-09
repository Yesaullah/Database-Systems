SELECT * FROM HR.employees WHERE salary = (SELECT MIN(salary) FROM HR.employees);
