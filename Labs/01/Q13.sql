select * 
from employees
where salary < (
    select min(salary)
    from employees
    where salary > 8000
);
