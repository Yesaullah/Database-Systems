select * 
from employees
where salary < (
    select min(salary)
    from employees
    where department_id = 50
);
