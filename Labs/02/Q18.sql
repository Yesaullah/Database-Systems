SELECT department_id, COUNT(*) AS num_employees FROM HR.employees GROUP BY department_id ORDER BY num_employees DESC FETCH FIRST 1 ROWS ONLY;

