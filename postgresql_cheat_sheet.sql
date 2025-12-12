
-- ============================================
-- PostgreSQL SQL Cheat Sheet
-- ============================================

-- ============================================
-- TABLE DEFINITIONS
-- ============================================

-- Create Table with Constraints
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE NOT NULL,
    department_id INT,
    salary NUMERIC(10, 2) CHECK (salary > 0),
    hire_date DATE DEFAULT CURRENT_DATE
    CONSTRAINT fk_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- Alter Table
ALTER TABLE employees ADD COLUMN job_title VARCHAR(100);

-- Drop Table
DROP TABLE IF EXISTS employees;

-- ============================================
-- DATA MANIPULATION
-- ============================================

-- Insert Data
INSERT INTO employees (first_name, last_name, email, department_id, salary)
VALUES ('John', 'Doe', 'john.doe@example.com', 1, 60000.00);

-- Update Data
UPDATE employees
SET salary = salary * 1.05
WHERE department_id = 1;

-- Delete Data
DELETE FROM employees
WHERE employee_id = 10;

-- ============================================
-- SELECT STATEMENTS
-- ============================================

-- Basic Select
SELECT first_name, last_name FROM employees;

-- Filtering
SELECT * FROM employees WHERE salary > 50000;

-- Sorting
SELECT * FROM employees ORDER BY salary DESC;

-- Limiting Results
SELECT * FROM employees LIMIT 5 OFFSET 10;

-- Join Example
SELECT e.first_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- ============================================
-- COMMON FUNCTIONS
-- ============================================

-- String Functions
SELECT
UPPER(first_name),
LOWER(last_name),
LENGTH(email)
FROM employees;

-- Numeric Functions
SELECT
ROUND(salary),
CEIL(salary),
FLOOR(salary)
FROM employees;

-- Date/Time Functions
SELECT
CURRENT_DATE,
CURRENT_TIME,
AGE(hire_date)
FROM employees;

-- Aggregate Functions
SELECT
COUNT(*),
AVG(salary),
MAX(salary),
MIN(salary),
SUM(salary)
FROM employees;

-- CASE Expression
SELECT
first_name,
CASE
   WHEN salary > 80000 THEN 'High'
   WHEN salary BETWEEN 50000 AND 80000 THEN 'Medium'
   ELSE 'Low'
END AS salary_level
FROM employees;

-- ============================================
-- WINDOW FUNCTIONS
-- ============================================

-- ROW_NUMBER
SELECT
employee_id,
salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
FROM employees;

-- RANK and DENSE_RANK
SELECT
employee_id,
salary,
RANK() OVER (ORDER BY salary DESC) AS rank,
DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
FROM employees;

-- PARTITION BY example
SELECT
department_id,
employee_id,
salary,
RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dept_rank
FROM employees;

-- Running Total
SELECT
employee_id,
salary,
SUM(salary) OVER (ORDER BY employee_id) AS running_total
FROM employees;
