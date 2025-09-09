SELECT department_id, SUM(salary) AS total_salary
FROM HR.employees
GROUP BY department_id
ORDER BY total_salary DESC
FETCH FIRST 3 ROWS ONLY;
