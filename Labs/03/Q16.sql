SELECT d.dept_id, d.dept_name, e.emp_id, e.full_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id;
