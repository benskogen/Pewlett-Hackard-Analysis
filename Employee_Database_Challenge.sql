-- Employee_Database_Challenge.sql

--department table
CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);

-- create employee table
CREATE TABLE employees (
	emp_no int NOT NULL,
	birth_date date NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date date NOT NULL,
	PRIMARY KEY (emp_no)
);

-- CREATE DEPT MGMR TABLE
CREATE TABLE dept_manager (
	dept_no VARCHAR NOT NULL,
	emp_no int NOT NULL,
	from_date date NOT NULL,
	to_date date NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

-- CREATE SALARIES TABLE
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

-- CREATE TITLES TABLE
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

drop table titles;
-- QUERYING THE TILES DATABASE
SELECT * FROM titles;

-- MORE QUERYING
SELECT 
	first_name, last_name
FROM
	employees
WHERE
	(birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND 
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31')
;

-- Number of employees retiring
SELECT COUNT(first_name)
FROM 
	employees
WHERE
	(birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND 
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31')
;

-- new table SELECT INTO *retirement_info*

SELECT 
	first_name, last_name
INTO 
	retirement_info
FROM
	employees
WHERE
	(birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND 
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31')
;

-- view new table 
SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT
	emp_no, first_name, last_name
INTO
	retirement_info
FROM 
	employees
WHERE
	(birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND 
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31')
;

-- Joining departments and dept_manager tables
SELECT 
	departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM
	departments
INNER JOIN
	dept_manager ON departments.dept_no = dept_manager.dept_no
;
-- Joining departments and dept_manager tables WITH ALIASES

SELECT
	d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM
	departments AS d
INNER JOIN
	dept_manager AS dm
ON
	d.dept_no = dm.dept_no;

-- JOING EMPLOYEES AND SALARIES TABLES
SELECT 
	employees.emp_no,
	salaries.salary,
	salaries.from_date
FROM
	employees
INNER JOIN
	salaries ON employees.emp_no = salaries.emp_no
;

-- Joining retirement_info and dept_emp tables
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no varchar NOT NULL,
	from_date date NOT NULL,
	to_date date NOT NULL
)
SELECT 
	retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM
	retirement_info
LEFT JOIN
	dept_emp
ON
	retirement_info.emp_no = dept_emp.emp_no;

-- joins with aliases
	
SELECT 
	ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM
	retirement_info AS ri
LEFT JOIN
	dept_emp AS de
ON
	ri.emp_no = de.emp_no;
	
-- let join ri and de - create new table "current_emp" 
-- input condtional WHERE
SELECT
	ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO
	current_emp
FROM
	retirement_info AS ri
LEFT JOIN
	dept_emp AS de
ON
	ri.emp_no = de.emp_no
WHERE
	de.to_date = ('9999-01-01')
;
-- DROP TABLE current_emp; - adding WHERE conditional --
SELECT * FROM current_emp;

-- GROUP BY --
-- Employee count by department number

SELECT COUNT(ce.emp_no),
	de.dept_no
INTO
	employee_count
FROM
	current_emp AS ce
LEFT JOIN
	dept_emp AS de
ON
	ce.emp_no = de.emp_no
GROUP BY 
	de.dept_no
ORDER BY
	de.dept_no
;

-- Employee Information: A list of employees containing 
-- their unique employee number,
-- their last name, first name, gender, and salary

SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	e.gender,
	s.to_date,
	s.salary
FROM
	employees AS e
LEFT JOIN
	salaries AS s
ON
	e.emp_no = s.emp_no
;

SELECT * FROM salaries
ORDER BY to_date DESC
;

SELECT 
	e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	s.to_date
	
-- INTO NEW TABLE - "emp_info"

INTO 
	emp_info
FROM 
	employees AS e
INNER JOIN
	salaries AS s
ON
	(e.emp_no = s.emp_no)
INNER JOIN
	dept_emp as de
ON
	(e.emp_no = de.emp_no)
WHERE
	(e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND 
	(e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND 
	(de.to_date = '9999-01-01')
;

-- DROP TABLE emp_info;

-- List of managers per department 7.3.5 (USE CURRENT_EMP)

SELECT 
	dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
    dm.from_date,
    dm.to_date	
INTO
	manager_info
FROM
	dept_manager AS dm
	JOIN
		departments AS D
	ON
		dm.dept_no = d.dept_no
	JOIN
		current_emp AS ce
	ON
		ce.emp_no = dm.emp_no
;
SELECT * FROM manager_info;
	
SELECT 
	ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM
	current_emp AS ce
JOIN
	dept_emp AS de
ON
	ce.emp_no = de.emp_no
JOIN
	departments as d
ON
	de.dept_no = d.dept_no
;
-- retirement table group by SALES TEAM
SELECT
	ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
FROM
	retirement_info AS ri
JOIN
	dept_emp AS de
ON
	ri.emp_no = de.emp_no
JOIN
	departments AS d
ON
	de.dept_no = d.dept_no
WHERE
	d.dept_name IN ('Sales');

SELECT * FROM departments ;

-- retirement table group by sales and development

SELECT
	ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
FROM
	retirement_info AS ri
JOIN
	dept_emp AS de
ON
	ri.emp_no = de.emp_no
JOIN
	departments AS d
ON
	de.dept_no = d.dept_no
WHERE
	d.dept_name IN ('Sales', 'Development')
;

-- DELIVERABLE #1 --
-- 1. Retrieve the emp_no, first_name, and last_name columns from the Employees table.
-- 2. Retrieve the title, from_date, and to_date columns from the Titles table.
SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO
	retirement_titles
FROM
	employees AS e
JOIN
	titles AS t
ON
	e.emp_no = t.emp_no
WHERE
	(birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY
	emp_no
;

-- SELECT DISTINCT
-- Create a Unique Titles table using the INTO clause.
SELECT DISTINCT ON (emp_no)
	emp_no,
	first_name,
	last_name,
	title
INTO
	unique_titles
FROM
	retirement_titles
WHERE 
	to_date = ('9999-01-01')
ORDER BY
	emp_no ASC,
	title DESC
;

-- Display unique_titles Table
SELECT * FROM unique_titles;

-- retrieve the number of employees by 
-- their most recent job title who are about to retire.

SELECT 
	title,
COUNT(*) title_count
-- INTO
-- 	retiring_titles
FROM
	unique_titles
-- WHERE 
-- 	to_date = ('9999-01-01')
GROUP BY
	title
ORDER BY
	title_count DESC
;

select * from retirement_titles;
	
			-- Deliverable # 2 --
SELECT DISTINCT ON (emp_no)
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO 
	mentorship_eligibilty
FROM
	employees AS e	
JOIN
	dept_emp AS de
ON
	e.emp_no = de.emp_no
JOIN
	titles AS t
ON
	e.emp_no = t.emp_no
WHERE
	(de.to_date = '9999-01-01')
AND 
	(e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY
	emp_no
;

SELECT * FROM mentorship_eligibilty;