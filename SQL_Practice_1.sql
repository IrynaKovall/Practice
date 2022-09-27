
/*1.	For the current maximum annual wage in the company SHOW the full name of the
employee, department, current position, for how long the current position is held, and
total years of service in the company. */
SELECT concat(ee.first_name,' ', ee.last_name) AS full_name, edep.dept_name, et.title, timestampdiff(year, et.from_date , curdate()) AS years_on_last_position, timestampdiff(year, ee.hire_date, curdate()) AS years_in_company
FROM employees.salaries AS es
INNER JOIN employees.employees AS ee ON (ee.emp_no = es.emp_no)
INNER JOIN employees.dept_emp AS ed ON (es.emp_no = ed.emp_no )
INNER JOIN employees.departments AS edep ON (edep.dept_no = ed.dept_no)
INNER JOIN employees.titles AS et ON (es.emp_no = et.emp_no)
WHERE es.salary = (SELECT MAX(salary) FROM employees.salaries WHERE curdate() between from_date and to_date) and curdate() between et.from_date and et.to_date;


/* 2. For each department, show its name and current manager’s name, last name, and
current salary */
SELECT dept_name, first_name,last_name, salary
FROM employees.departments AS ed
INNER JOIN employees.dept_manager AS edm ON (edm.dept_no= ed.dept_no)
INNER JOIN employees.employees AS ee ON (edm.emp_no = ee.emp_no)
INNER JOIN employees.salaries AS es ON (es.emp_no = edm.emp_no)
WHERE curdate() BETWEEN edm.from_date and edm.to_date and curdate() BETWEEN es.from_date and es.to_date;


/*3. Show for each employee, their current salary and their current manager’s current salary. */
SELECT es.emp_no AS empl, es.salary AS sal_emp,  dept_man.emp_no AS manag, dept_man.salary AS sal_man
FROM employees.salaries AS es
INNER JOIN employees.dept_emp AS de USING(emp_no)
INNER JOIN 
	(SELECT emp_no, salary, dept_no 
	FROM employees.dept_manager AS dm
	INNER JOIN employees.salaries AS es USING(emp_no)
	WHERE curdate() BETWEEN es.from_date and es.to_date 
	and curdate() BETWEEN dm.from_date and dm.to_date) AS dept_man USING(dept_no)
WHERE curdate() BETWEEN es.from_date and es.to_date and curdate() BETWEEN de.from_date and de.to_date;


/* 4. Show all employees that currently earn more than their managers.*/
SELECT es.emp_no 
FROM employees.salaries AS es
INNER JOIN employees.dept_emp AS de USING(emp_no)
INNER JOIN 
	(SELECT emp_no, salary, dept_no 
	FROM employees.dept_manager AS dm
	INNER JOIN employees.salaries AS es USING(emp_no)
	WHERE curdate() BETWEEN es.from_date and es.to_date 
	and curdate() BETWEEN dm.from_date and dm.to_date) AS dept_man USING(dept_no)
WHERE curdate() BETWEEN es.from_date and es.to_date and curdate() BETWEEN de.from_date and de.to_date
and dept_man.salary<es.salary;


/* 5. Show how many employees currently hold each title, sorted in descending order by the
number of employees. */
SELECT et.title, COUNT(ee.emp_no)
FROM employees.employees AS ee
INNER JOIN employees.titles AS et USING(emp_no)
WHERE curdate() BETWEEN et.from_date and et.to_date
GROUP BY et.title
ORDER BY COUNT(ee.emp_no) desc;


/* 6. Show full name of the all employees who were employed in more than one department. */
SELECT  first_name,last_name
FROM employees.employees
INNER JOIN employees.dept_emp USING (emp_no)
GROUP BY emp_no
HAVING  COUNT(dept_no)>1;


/*7. Show the average salary and maximum salary in thousands of dollars for every year. */
SELECT from_date, to_date, round(avg(salary)/1000)AS salaryavgths, ROUND(max(salary)/1000) AS salarymax
FROM salaries 
GROUP BY from_date, to_date;


/*8. Show how many employees were hired on weekends (Saturday + Sunday), split by gender */
SELECT gender, count(emp_no)
FROM employees.employees
WHERE dayname(hire_date)= 'Saturday' OR dayname(hire_date)='Sunday'
GROUP BY gender;
