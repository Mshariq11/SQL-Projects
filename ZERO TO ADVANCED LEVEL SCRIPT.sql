-- ZERO TO ADVANCED LEVEL SQL SCRIPT

-- SELECT STATEMENT! 
SELECT *
FROM parks_and_recreation.employee_demographics;
-- PEMDAS RULE 
SELECT first_name,
last_name,
age,
birth_date,
age,
(age+10) * 10 + 10
FROM parks_and_recreation.employee_demographics;
-- DISTINCT FUNCTION FOR UNIQUE VALUE 
SELECT DISTINCT first_name, 
gender
FROM parks_and_recreation.employee_demographics;

-- WHERE (WHERE CLAUSE USED FOR FILTER THE DATA) OR COMPARISION OPERATOR = > < != 
SELECT * 
FROM parks_and_recreation.employee_salary
WHERE first_name = 'Leslie' 
;
SELECT * 
FROM parks_and_recreation.employee_salary
WHERE salary > 50000 
;
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE gender != 'Female'
;

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE birth_date > '1989-01-01'
;
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE birth_date > '1989-01-01'
OR NOT gender = 'male'
;
-- AND / OR 
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE (first_name = 'Leslie' AND age = 44 ) OR age > 55
;
-- LIKE (% IS KIND OF SUFFIX / PREFIX)
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE 'jer%'
;
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE '%er%'
;
-- __ (JITNE _ _ ADD KARENGAY UTNAY CHARACTERS ADD HOJANGAY AFTER ALPHABET)
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE 'a___'
;

-- GROUP BY FUNCTION (DISCRIMINATE BASED ON THIS GROUP BY FUNCTION)
SELECT gender 
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;
-- AVERAGE AVG (MEAN OF NUMERIC VALUE) 
SELECT gender, AVG(age) 
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;
SELECT occupation, salary  
FROM parks_and_recreation.employee_salary
GROUP BY occupation, salary
;
-- AVG MAX MIN COUNT FUNCTION
SELECT gender, AVG(age), Max(age), Min(age), Count(age) 
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;

-- ORDER BY  (FOLLOW THE SEQUENCE)
SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY first_name
;
-- ASCENDING / DESCENDING FUNCTION
SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY first_name DESC
;
SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY age, gender ASC
;
-- HAVING FUNCTION (SETS CONDITIONS)
SELECT gender, AVG(age) 
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;
SELECT occupation, AVG(salary)
FROM parks_and_recreation.employee_salary
WHERE occupation LIKE '%manager%' 
GROUP BY occupation 
HAVING AVG(salary) > 75000
;
-- LIMIT (LIMITED VALUE THAT YOU WANT)
SELECT *
FROM parks_and_recreation.employee_demographics
ORDER BY age DESC 
LIMIT 3
;
-- ALIASING (AS FUNCTION FOR CHANGE THE COLUMN NAME)
SELECT gender, AVG(age) AS avg_age 
FROM parks_and_recreation.employee_demographics
GROUP BY gender 
HAVING avg_age > 40
;

-- JOINS (JOIN TWO TABLES ON BEHALF OF SIMILAR COLUMN)
SELECT *
FROM parks_and_recreation.employee_demographics
INNER JOIN parks_and_recreation.employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id
;

SELECT *
FROM parks_and_recreation.employee_demographics AS dem
INNER JOIN parks_and_recreation.employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

SELECT dem.employee_id, age, occupation
FROM parks_and_recreation.employee_demographics AS dem
INNER JOIN parks_and_recreation.employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;
-- LEFT JOIN 
SELECT *
FROM parks_and_recreation.employee_demographics AS dem
LEFT JOIN parks_and_recreation.employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;
-- RIGHT JOIN 
SELECT *
FROM parks_and_recreation.employee_demographics AS dem
RIGHT JOIN parks_and_recreation.employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

SELECT *
FROM parks_and_recreation.employee_salary emp1
JOIN parks_and_recreation.employee_salary emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;

-- SELF JOIN
SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_name,
emp2.first_name AS first_name_emp,
emp2.last_name AS last_name_emp
FROM parks_and_recreation.employee_salary emp1
JOIN parks_and_recreation.employee_salary emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;

-- JOINING MULTIPLE
SELECT *
FROM parks_and_recreation.employee_demographics AS dem
INNER JOIN parks_and_recreation.employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_and_recreation.parks_departments pd 
	ON sal.dept_id = pd.department_id
;

-- UNION  (LIST ALL TABLE COLUMNS NAMES)
SELECT first_name, last_name 
FROM parks_and_recreation.employee_demographics
UNION ALL 
SELECT first_name, last_name 
FROM parks_and_recreation.employee_salary
;

SELECT first_name, last_name, 'OLD MAN' AS Label 
FROM parks_and_recreation.employee_demographics
WHERE age > 40 AND gender = 'Male' 
UNION 
SELECT first_name, last_name, 'OLD LADY' AS Label 
FROM parks_and_recreation.employee_demographics
WHERE age > 40 AND gender = 'Female' 
UNION 
SELECT first_name, last_name, 'HIGHLY PAID SALARY' AS Label 
FROM parks_and_recreation.employee_salary
WHERE salary > 70000 
ORDER BY first_name, last_name
;

--- STRING FUNCTION
SELECT first_name, LENGTH(first_name) 
FROM parks_and_recreation.employee_demographics
ORDER BY 2
;
-- UPPER (ALL NAME IN UPPERCASE)
SELECT first_name, UPPER(first_name) 
FROM parks_and_recreation.employee_demographics
ORDER BY 2
;
-- LOWER (ALL NAMES IN LOWER CASE)
SELECT first_name, LOWER(first_name) 
FROM parks_and_recreation.employee_demographics
ORDER BY 2
;
-- TRIM
SELECT first_name, TRIM(first_name) 
FROM parks_and_recreation.employee_demographics
;
-- LEFT TRIM
SELECT first_name, LTRIM(first_name) 
FROM parks_and_recreation.employee_demographics
;
-- RIGHT TRIM
SELECT first_name, RTRIM(first_name) 
FROM parks_and_recreation.employee_demographics
;
-- SUBSTRING FUNCTION (SELECT THE SPECIFIC PART FROM THE NAME OR NUMBERS)
SELECT first_name, 
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(first_name, 3,2),
birth_date,
SUBSTRING(birth_date, 6,2) AS birth_month
FROM parks_and_recreation.employee_demographics
;
-- REPLACE (RE-CHANGE)
SELECT first_name, REPLACE(first_name, 'a','z') 
FROM parks_and_recreation.employee_demographics
;
-- LOCATE (MENTION THE LOCATION)
SELECT LOCATE('x', 'Alexander') 
FROM parks_and_recreation.employee_demographics
;
-- CONCATENATION  
SELECT first_name, last_name, 
CONCAT(first_name, ' ', last_name) AS Full_name 
FROM parks_and_recreation.employee_demographics
;

-- CASE STATEMENT 
SELECT first_name, last_name, age, 
CASE 
	WHEN age < 30 THEN 'young'
END 
FROM parks_and_recreation.employee_demographics
;

SELECT first_name, last_name, age, 
CASE 
	WHEN age BETWEEN 31 and 50 THEN 'OLD'
    WHEN age >= 50 THEN "On Death Door"
END AS Age_Bracket
FROM parks_and_recreation.employee_demographics
;

SELECT first_name, last_name, salary, 
CASE 
	WHEN salary < 50000 THEN salary * 1.05
    WHEN salary > 50000 THEN salary * 1.07    
END AS New_Salary,
CASE 
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM parks_and_recreation.employee_salary
;		

SELECT * 
FROM parks_and_recreation.employee_salary
;
SELECT * 
FROM parks_and_recreation.employee_demographics
;

-- SUBQUERIES 
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE employee_id IN 
					(SELECT employee_id
						FROM parks_and_recreation.employee_salary
							WHERE dept_id = 1)
;

SELECT AVG(min_age)
FROM 
	(SELECT gender,
	AVG(age) AS avg_age,
    MAX(age) AS max_age,
    MIN(age) AS min_age,
    COUNT(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender) AS agg_table
;

-- WINDOW FUNCTION
SELECT gender, AVG(salary) AS avg_salary 
FROM parks_and_recreation.employee_demographics dem 
JOIN parks_and_recreation.employee_salary sal 
ON dem.employee_id 
GROUP BY gender
;

-- OVER / PARTITION BY 
SELECT dem.first_name, dem.last_name, gender, salary, AVG(salary) 
OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM parks_and_recreation.employee_demographics dem
JOIN parks_and_recreation.employee_salary sal 
ON dem.employee_id 
;
-- SUM
SELECT dem.first_name, dem.last_name, gender, salary, SUM(salary) 
OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM parks_and_recreation.employee_demographics dem
JOIN parks_and_recreation.employee_salary sal 
ON dem.employee_id 
;
-- ROW NUMBER / RANK / DENSE RANK
SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER () OVER(PARTITION BY gender ORDER BY salary DESC) AS ROW_NUM,
RANK () OVER(PARTITION BY gender ORDER BY salary DESC) AS Rank_NUM,
DENSE_RANK () OVER(PARTITION BY gender ORDER BY salary DESC) AS DENSE_RANK_NUM
FROM parks_and_recreation.employee_demographics dem
JOIN parks_and_recreation.employee_salary sal 
ON dem.employee_id 
;

  -- CTEs

WITH CTE_Example AS 
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(Salary) count_sal 
FROM parks_and_recreation.employee_demographics dem
JOIN parks_and_recreation.employee_salary sal
   ON dem.employee_id = sal.employee_id
GROUP BY gender 
)
SELECT *
FROM CTE_Example
;

WITH CTE_Example (Gender, AVG_Sal, MAX_Sal, MIN_Sal, COUNT_Sal) AS 
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(Salary) count_sal 
FROM parks_and_recreation.employee_demographics dem
JOIN parks_and_recreation.employee_salary sal
   ON dem.employee_id = sal.employee_id
GROUP BY gender 
)
SELECT *
FROM CTE_Example
;

WITH CTE_Example AS 
(
SELECT employee_id, gender, birth_date 
FROM parks_and_recreation.employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary  
FROM parks_and_recreation.employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
;

-- TEMPORARY TABLES
USE parks_and_recreation;
CREATE TEMPORARY TABLE temp_table
(
  first_name varchar(50),
  last_name varchar(50),
  favorite_movie varchar(100)
);
SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES('Alex', 'Freber', 'lord of the Rings: The Two Towers')
;
SELECT *
FROM temp_table
;
CREATE TEMPORARY TABLE salary_over_50k
SELECT * 
FROM parks_and_recreation.employee_salary
WHERE salary >= 50000
;
SELECT * 
FROM salary_over_50k
;

-- Stored Procedures
SELECT * 
FROM employee_salary
WHERE salary >= 50000;

CREATE PROCEDURE large_salaries()
SELECT * 
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();

DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT * 
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT * 
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;

CALL large_salaries2();

DELIMITER $$
CREATE PROCEDURE large_salaries3(p_employee_id INT)
BEGIN
	SELECT salary
	FROM employee_salary
	WHERE employee_id = p_employee_id;
END $$
DELIMITER ;

CALL large_salaries3(1);

-- TRIGGERS AND EVENTS
SELECT * 
FROM employee_demographics;

SELECT *
FROM employee_salary;

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
	FOR EACH ROW 
BEGIN 
	INSERT INTO emloyee_demographics (employee_id, first_name, last_name)
	VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER employee_insert3
	AFTER INSERT ON employee_salary
	FOR EACH ROW 
BEGIN
	INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
	VALUES(13, 'Jean-Ralphio' , 'Saperstein' , 'Entertainment 720 CEO', 1000000, NULL);
END $$
DELIMITER ;

-- EVENTS 
SELECT * 
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO 
BEGIN 
  SELECT * 
  FROM employee_demographics
  WHERE age >= 60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%'; 

DROP DATABASE IF EXISTS `Parks_and_Recreation`;
CREATE DATABASE `Parks_and_Recreation`;
USE `Parks_and_Recreation`;






CREATE TABLE employee_demographics (
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  birth_date DATE,
  PRIMARY KEY (employee_id)
);

CREATE TABLE employee_salary (
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT
);


INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(1,'Leslie', 'Knope', 44, 'Female','1979-09-25'),
(3,'Tom', 'Haverford', 36, 'Male', '1987-03-04'),
(4, 'April', 'Ludgate', 29, 'Female', '1994-03-27'),
(5, 'Jerry', 'Gergich', 61, 'Male', '1962-08-28'),
(6, 'Donna', 'Meagle', 46, 'Female', '1977-07-30'),
(7, 'Ann', 'Perkins', 35, 'Female', '1988-12-01'),
(8, 'Chris', 'Traeger', 43, 'Male', '1980-11-11'),
(9, 'Ben', 'Wyatt', 38, 'Male', '1985-07-26'),
(10, 'Andy', 'Dwyer', 34, 'Male', '1989-03-25'),
(11, 'Mark', 'Brendanawicz', 40, 'Male', '1983-06-14'),
(12, 'Craig', 'Middlebrooks', 37, 'Male', '1986-07-27');


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(1, 'Leslie', 'Knope', 'Deputy Director of Parks and Recreation', 75000,1),
(2, 'Ron', 'Swanson', 'Director of Parks and Recreation', 70000,1),
(3, 'Tom', 'Haverford', 'Entrepreneur', 50000,1),
(4, 'April', 'Ludgate', 'Assistant to the Director of Parks and Recreation', 25000,1),
(5, 'Jerry', 'Gergich', 'Office Manager', 50000,1),
(6, 'Donna', 'Meagle', 'Office Manager', 60000,1),
(7, 'Ann', 'Perkins', 'Nurse', 55000,4),
(8, 'Chris', 'Traeger', 'City Manager', 90000,3),
(9, 'Ben', 'Wyatt', 'State Auditor', 70000,6),
(10, 'Andy', 'Dwyer', 'Shoe Shiner and Musician', 20000, NULL),
(11, 'Mark', 'Brendanawicz', 'City Planner', 57000, 3),
(12, 'Craig', 'Middlebrooks', 'Parks Director', 65000,1);



CREATE TABLE parks_departments (
  department_id INT NOT NULL AUTO_INCREMENT,
  department_name varchar(50) NOT NULL,
  PRIMARY KEY (department_id)
);

INSERT INTO parks_departments (department_name)
VALUES
('Parks and Recreation'),
('Animal Control'),
('Public Works'),
('Healthcare'),
('Library'),
('Finance');




















