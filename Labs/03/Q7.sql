ALTER TABLE employees ADD city VARCHAR2(50) DEFAULT 'Karachi';

ALTER TABLE employees ADD age NUMBER CHECK (age > 18);
