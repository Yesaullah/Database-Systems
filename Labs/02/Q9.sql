SELECT employee_id, last_name,
       FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date)) AS months_worked FROM HR.employees;
