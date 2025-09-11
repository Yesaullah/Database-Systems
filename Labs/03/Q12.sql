ALTER TABLE employees ADD dob DATE;

CREATE OR REPLACE TRIGGER trg_check_age
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
   IF :NEW.dob > ADD_MONTHS(SYSDATE, -12*18) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Employee must be at least 18 years old.');
   END IF;
END;
