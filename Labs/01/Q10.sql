select * 
from employees e
where (select count(*) 
       from employees 
       where department_id = e.department_id) = 1;
