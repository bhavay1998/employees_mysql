# Ideally, it would be better when "IF NOT EXISTS" can be contained in square brackets. In MySQL though, adding brackets throws an error; so code is better without it.
# Best practice in SQL is to always combine IF NOT EXISTS with CREATE.
CREATE DATABASE IF NOT EXISTS sales; 

# A created database doesn't mean that it's currently being used.
USE sales;

# The database is empty so far, so it's good to add a table.
## Generally you define a column by name, dt type, constraint, additional attributes
CREATE TABLE sales
(
	purchase_number INT NOT NULL PRIMARY KEY AUTO_INCREMENT,	# 1st column
    date_of_purchase DATE NOT NULL, 							# 2nd column
    customer_id INT, 											# 3rd column where values are allowed to be 'null' 
    item_code VARCHAR(10) NOT NULL 								# 4th column
);

# Creating another table for customer-specific information
CREATE TABLE customers
(
	customer_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,	# 1st column
    first_name VARCHAR(255) NOT NULL, 						# 2nd column
    last_name VARCHAR(255) NOT NULL, 						# 3rd column where values are allowed to be 'null' 
    email_address VARCHAR(255) NOT NULL, 					# 4th column
	number_of_complaints INT
);

# If a table is no longer needed:
DROP TABLE sales;

# An alternate way to declare primary key in a table:
CREATE TABLE sales
(
	purchase_number INT NOT NULL AUTO_INCREMENT,
    date_of_purchase DATE NOT NULL, 							
    customer_id INT, 											
    item_code VARCHAR(10) NOT NULL,
PRIMARY KEY (purchase_number)
);

# Creating 'items' table in sales database
USE sales;
CREATE TABLE items
(
	item_code VARCHAR(255) NOT NULL PRIMARY KEY,  
	item VARCHAR(255),  
	unit_price NUMERIC(10, 2),  
	company_id VARCHAR(255)
);

# Creating 'companies' table
CREATE TABLE companies  
(
	company_id VARCHAR(255) PRIMARY KEY,  
	company_name VARCHAR (255),  
	headquarters_phone_number INT(12)
);

# NOTE: You cannot use auto_increment when primary key is of type 'varchar'. It can only increment when PK is 'index' or 'int'.

# It is possible to define a foreign key similar to how you define a primary key (towards the end of code).
# However it is possible that you missed defining FK and want to define it later:
ALTER TABLE sales
ADD FOREIGN KEY(customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE;

# Similar to FK, a unique key can also be addded:
ALTER TABLE customers
ADD UNIQUE KEY (email_address);

# Unique Key have the same role as 'index'. In fact, you need to specify INDEX while dropping a 'unique key':
ALTER TABLE customers
DROP INDEX email_address;

# Adding a new column to 'customers' table:
ALTER TABLE customers
ADD COLUMN gender ENUM('M', 'F') AFTER last_name;

# Adding actual data into the table
INSERT INTO customers (first_name, last_name, gender, email_address, number_of_complaints)
VALUES ('John', 'Mackinley', 'M', 'john.mckinley@365careers.com', 0);

# What if we want to alter an already exsiting column?:
ALTER TABLE customers
CHANGE COLUMN number_of_complaints number_of_complaints INT DEFAULT 0
;

# Adding another record in 'customers'
INSERT INTO customers(first_name, last_name, gender, email_address)
VALUES ('Peter', 'Figaro', 'M', 'figaro.peter@gmail.com');

# View 'customers' table
SELECT * FROM customers; # 'id' was incremented automatically; 'number of complaints' was set to default.

# Of course, the defaults can also be dropped from a column:
ALTER TABLE customers
ALTER COLUMN number_of_complaints DROP DEFAULT;
## NOTE: 'alter' column and 'change' column are two different things, the latter completely re-defines the column but may also create an index copy instead of replacing!
## NOTE: Avoid using CHANGE COLUMN (unless you want to rename a col). Better to use MODIFY and ALTER. ALTER -> change metadata; MODIFY -> redifing the column (such as data type, NULL | NOT NULL, etc.)

# altering 'companies' table
ALTER TABLE companies
CHANGE COLUMN headquarters_phone_number headquarters_phone_number VARCHAR(255) DEFAULT 'X' UNIQUE KEY NOT NULL;

# We know that in companies table `headquarters_phone_number` has a default value, hence it can't be NULL. To allow NULL, the following code can be executed.
ALTER TABLE companies
MODIFY COLUMN headquarters_phone_number VARCHAR(255) NULL;

# Reverting `headquarters_phone_number` back to original state:
ALTER TABLE companies
MODIFY COLUMN headquarters_phone_number VARCHAR(255) NOT NULL;