SELECT dept_id, num_employees
FROM (
    SELECT dept_id, COUNT(*) AS num_employees
    FROM employees
    GROUP BY dept_id
    ORDER BY num_employees DESC
)
WHERE ROWNUM = 1;