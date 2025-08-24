select * 
from employees
where hire_date between 
to_date('2005-01-01','YYYY-MM-DD') 
and to_date('2006-12-31','YYYY-MM-DD');
