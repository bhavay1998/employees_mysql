USE employees;

# Using 'DISTINCT' operator to see how many unique genders are stored:
SELECT DISTINCT gender from employees;

# The general 'AND' & 'OR' operators can be used (in combination with 'paranthesis') along with the 'WHERE' clause to filter the data:
SELECT * FROM employees
WHERE (first_name = 'Denis'
		OR first_name = 'Cathie')
        AND gender = 'F';

# However in case of multiple 'OR' conditions, using the 'IN' and 'NOT IN' operator is more useful:
SELECT * FROM employees
WHERE first_name IN ('Cathie','Mark','Nathan');

# The above query is more efficient form of the query:
SELECT * FROM employees
WHERE first_name = 'Cathie'
        OR first_name = 'Mark'
        OR first_name = 'Nathan';
        
# It is possible that field information isn't always fully known. In this case, using 'LIKE' and 'NOT LIKE' along with '%' and '_' signs can be very useful for pattern matching.
# For example, if an employee of interest has 'art' somewhere in their first name (such as 'Arto', 'Eckart', 'Barton', etc.):
SELECT * FROM employees
WHERE first_name LIKE ('%art%'); # two '%' sign means that pattern-matching is attemped in both directions.

# Another example, if there is an employee of interest with 4 letter first name but the last letter is unclear:
SELECT * FROM employees
WHERE first_name LIKE ('Mar_');

# For a fixed range of values, 'BETWEEN' / 'NOT BETWEEN' operator in combination with 'AND' is useful. For example, filtering employees hired between '1st jan 1990' and '31st dec 1992':
SELECT * FROM employees
WHERE hire_date BETWEEN ('1990-01-01') AND ('1992-12-31');

# The above operators used were 'MySQL-native' operators, however, mathematical operators are also supported and can be used.
-------------------------------------------------------------------------------------------------------------------------------------
# A different set of operators called aggregation 'functions' can be used for performing 'aggregation' tasks.

# For example: How many registered annual contracts have a salary obligations higher than or equal to $100,000 in the salaries table?
			## The contract must be uniquely identified by its salary obligation to avoid double-counting a contract with same value!
SELECT COUNT(DISTINCT salary) -- will filter-out duplicate contracts in terms of salary amount
FROM salaries
WHERE salary >= 100000 -- there are 16,754 uniquely registered salary contracts (by payment obligations) with an obligation to pay above $99,999
; 

# To actually see the unique contract value in descending order of value:
SELECT DISTINCT salary -- will filter-out duplicate contracts in terms of salary amount
FROM salaries
WHERE salary >= 100000 -- there are 16,754 unique salary contracts above a pay grade of $99,999
ORDER BY salary DESC
; 

-- The aggregate functions might need to be applied to individual groups instead of all the records. Here, 'GROUP BY' comes-in handy.
SELECT salary, COUNT(emp_no) AS registered_emp_contracts 
FROM salaries
WHERE salary >= 100000 -- Filtering for contracts >= $100,000 (a general condition. not meant for a column containing aggregated values)
GROUP BY salary -- It precedes the 'ORDER BY' clause, automatically filters count by a UNIQUE 'salary' amount.
HAVING registered_emp_contracts = 3 -- 'HAVING' clause is used when conditional statements are applied on columns with aggregated values ['WHERE' doesn't function].
ORDER BY salary  DESC
LIMIT 10 -- top 10 salaries
; -- Now, the number of registered contracts for every salary obligation is visible. For example, salary of $128,294 is mentioned as payment obligation for 3 different employees.
