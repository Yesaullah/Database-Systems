select * 
from employees
where salary < (
    select max(salary) 
    from employees 
    where department_id = 100
);
