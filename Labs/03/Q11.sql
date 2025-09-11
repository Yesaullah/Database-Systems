ALTER TABLE employees ADD CONSTRAINT uq_bonus UNIQUE (bonus);

INSERT INTO employees VALUES (2, 'Ali', 30000, 1, 2000, 'Lahore', 25, 'ali@test.com');
INSERT INTO employees VALUES (3, 'Sara', 35000, 2, 2000, 'Karachi', 28, 'sara@test.com');
