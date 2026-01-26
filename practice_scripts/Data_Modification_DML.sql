USE employees;

# Adding employee record in the 'employees' table
INSERT INTO employees VALUES
(
    999903, -- a high emp_no can distinguish this record and can help in testing whether the 'insert' statement worked.
    '1977-09-14',
    'Johnathan',
    'Creek',
    'M',
    '1999-01-01'
);

# Adding employee record in the 'titles' table.
-- NOTE: It is essential to run the above code to preserve references; 'titles' is a child table and 'employees' is parent table connected via 'emp_no'.
INSERT INTO titles
VALUES (
	999903,
	'Senior Engineer',
	'1997-10-01',
	NULL
);

# After record is added in parent table, subsequent child tables can be inserted/upadted accordingly.
INSERT INTO dept_emp
VALUES (
	999903,
    'd005',
    '1997-10-01',
    '9999-01-01'
);

INSERT INTO departments VALUES(
'd010', 'Business Analysis');

# Instead of manually adding each record, entire (or portions of) different tables can be copied straightaway.
-- Defining the table first
CREATE TABLE salaries_dup (
	emp_no INT NOT NULL,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE
);

-- Creating a conditional duplicate
INSERT INTO salaries_dup 
SELECT * FROM salaries
WHERE salary >= 100000;

SELECT * FROM salaries_dup 
WHERE salary < 100000
LIMIT 10; 		# VERIFY

-------------------------------------------------------------------------------------------------------------------------------
# Transaction Control Language (TCL): Contains COMMIT and ROLLBACK clauses
	-- COMMIT is useful to store current state of data
	-- ROLLBACK can only restore the state of data in previous 'commit', once!; Running multiple ROLLBACK clauses won't transition to previous state more than once.
-------------------------------------------------------------------------------------------------------------------------------
# If inserted records are to be updated, UPDATE statement is helpful.

# Let us say we have employee no '999903' to be added in salaries_dup
INSERT INTO salaries_dup
VALUES (
	999903,
    124568,
    '1990-01-01',
    NULL
);

SELECT * FROM salaries_dup; -- state of the duplicates table
COMMIT; -- Saving current state of the data, after successful insert ['autocommit' is turned-off].

# Updating the salaries info in salaries_dup, for employee no 999903:
UPDATE salaries_dup
SET
	salary = 224568
-- WHERE emp_no = 999903 ## Omitted, by mistake
;

# Effect of wrong query on the database:
SELECT * FROM salaries_dup ORDER BY emp_no DESC; -- Entire salary column got affected!

# Reverting to previous 'commit' state:
ROLLBACK;

# Is the previous state restored?:
SELECT * FROM salaries_dup ORDER BY emp_no DESC; -- Yes!
COMMIT; -- Saving the correct state.,

# Performing a correct UPDATE:
UPDATE departments
SET
	dept_name = 'Data Analysis'
WHERE dept_no = 'd010';

SELECT * FROM departments WHERE dept_no = 'd010'; -- Verified.
COMMIT; -- Saving the state.

-------------------------------------------------------------------------------------------------------------------------------
# Using DELETE to show how ON DELETE CASCADE works
-------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM employees WHERE emp_no= 999903; -- employee identified as 'Jonathan Creek'
SELECT * FROM titles WHERE emp_no= 999903; -- 'Jonathan Creek' functions as a 'Senior Engineer'

# Remove 'Jonathan Creek' record from the parent table ('employees')
DELETE FROM employees
WHERE emp_no = 999903; -- Omitting the WHERE condition in DELETE statement can wipe-away the entire table.

SELECT * FROM titles WHERE emp_no= 999903; -- 'Jonathan Creek' got erased from child table as well via ON DELETE CASCADE.
ROLLBACK; -- Restore last commit state.
COMMIT;

-------------------------------------------------------------------------------------------------------------------------------
# DELETE without a WHERE condition -> TRUNCATE (structure of the object 'table' is preserved)
	-- DROP completely removes the entire object, including the contained data. 
    -- TRUNCATE is more efficient at removing complete data, because DELETE removes data row-by-row (w.r.t WHERE condition)
    -- Auto-increment are not reset with DELETE (TRUNCATE does it automatically)
# -------------------------------------------------------------END----------------------------------------------------------- #
