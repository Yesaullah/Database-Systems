select department_name
from departments
where department_id not in (
    select department_id 
    from employees
);
