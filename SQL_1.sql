
/*1. For the current maximum annual wage in the company SHOW the full name of the
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

/*9. For the current maximum annual wage in the company SHOW the full name of an employee, department, current position, for how long the current position is held, and total years of service in the company.USE common table 
expression this time */
WITH  test_empl_CTE(id, full_name, department, position, year_position, year_company)
AS
(
SELECT ee.emp_no, concat(ee.first_name, ' ', ee.last_name), edp.dept_name, et.title , timestampdiff(year, et.from_date, curdate()) ,timestampdiff(year,ee.hire_date , curdate()) 
FROM employees.employees AS ee
LEFT JOIN employees.titles AS et ON (ee.emp_no =et.emp_no and curdate() BETWEEN et.from_date and et.to_date)
LEFT JOIN employees.dept_emp AS ed ON (ee.emp_no =ed.emp_no and curdate() BETWEEN ed.from_date and ed.to_date)
LEFT JOIN employees.departments AS edp ON (edp.dept_no=ed.dept_no)
)
,
test_sal_CTE(id, from_date, to_date, salary)
AS
(SELECT emp_no, salary, from_date, to_date 
FROM employees.salaries 
order BY 
salary limit 1)
SELECT emp.id, sal.salary, emp.full_name, emp.department, emp.position, emp.year_position, emp.year_company
 FROM test_sal_CTE AS sal,
test_empl_CTE AS emp
WHERE  emp.id=sal.id;

 /*10 Show all information about the employee, salary year, and the difference 
between salary and average salary in the company overall. For the employee, 
whose salary was assigned latest from salaries that are closest to mean salary overall (doesn’t matter high
er or lower). Here you need to find the average salary overall and then find the smallest 
difference of someone’s salary with an average salary */
SELECT emp_no, from_date, to_date,salary, ABS(diff), DENSE_RANK() OVER (ORDER BY ABS(diff) DESC) AS dffrank
FROM 
(SELECT emp_no, from_date, to_date,salary, avg(salary) OVER () AS avg_sal, salary - avg(salary) OVER () AS diff
FROM employees.salaries
WHERE to_date in (SELECT MAX(to_date) FROM employees.salaries
GROUP BY emp_no)) AS a
ORDER BY dffrank
LIMIT 1;

/* 11.Show Full Name, salary, and year of the salary for top 5 employees that have the highest one-time raise in salary (in absolute numbers). Also, attach the top 5 employees that have the highest one-time raise in salary (in 
percent).  One-time rise here means the biggest difference between the two consecutive years */
SELECT emp_no, ee.first_name, ee.last_name, salary, from_date,to_date, diffsal,slr_rank
FROM
(SELECT  emp_no,salary,  from_date,to_date,diffsal,DENSE_RANK() OVER (ORDER BY  diffsal DESC) slr_rank
FROM
(SELECT emp_no, salary,from_date,to_date, nextSalary, nextSalary - salary AS diffsal, (nextSalary/salary-1) AS diffsalpr
FROM
(SELECT emp_no, salary,from_date,to_date,  LEAD(salary,1) OVER ( PARTITION BY emp_no ORDER BY from_date) AS nextSalary
FROM employees.salaries) AS sal) AS saldif) AS slr_rank
LEFT JOIN employees.employees AS ee USING(emp_no)
WHERE slr_rank in (1,2,3,4,5)
UNION ALL
SELECT emp_no, ee.first_name, ee.last_name, salary, from_date,to_date, diffsalpr,slr_rankpr
FROM
(SELECT  emp_no,salary,  from_date,to_date,diffsalpr,DENSE_RANK() OVER (ORDER BY  diffsalpr DESC) slr_rankpr
FROM
(SELECT emp_no, salary,from_date,to_date, nextSalary, nextSalary - salary AS diffsal, (nextSalary/salary-1) AS diffsalpr
FROM
(SELECT emp_no, salary,from_date,to_date,  LEAD(salary,1) OVER ( PARTITION BY emp_no ORDER BY from_date) AS nextSalary
FROM employees.salaries) AS sal) AS saldif) AS slr_rank
LEFT JOIN employees.employees AS ee USING(emp_no)
WHERE slr_rankpr in (1,2,3,4,5);

/* 12.Отобразить сотрудников и напротив каждого, показатьинформацию о разнице текущейи первойзарплате. */
SELECT *
FROM
(SELECT emp_no, from_date, to_date,salary, 
FIRST_VALUE(salary) OVER (PARTITION BY emp_no ORDER BY from_date ) AS firstsal, salary  - 
FIRST_VALUE(salary) OVER (PARTITION BY emp_no ORDER BY from_date ) AS diff_salary
FROM employees.salaries) AS SAl
WHERE curdate() BETWEEN from_date and to_date;

/* 13.Отобразить департаменты и сотрудников, которыеполучают наивысшуюзарплату всвоем департаменте. */
SELECT dept_name, ID, salary, max_sal
FROM
(
SELECT dept_name, es.emp_no AS ID, salary, max(salary) OVER (PARTITION BY dept_name) AS max_sal
FROM employees.salaries AS es
LEFT JOIN employees.dept_emp AS de ON (es.emp_no=de.emp_no and curdate() between de.from_date and de.to_date)
LEFT JOIN employees.departments AS dep ON (dep.dept_no=de.dept_no)
WHERE curdate() between es.from_date and es.to_date
) AS sal
WHERE salary=max_sal;

/* 14.Из таблицы должностей, отобразить сотрудникас его текущей должностью ипредыдущей.HINT OVER(PARTITION BY ... ORDER BY ... ROWS 1 preceding) */
SELECT emp_no,from_date, to_date, title AS last_title, ifnull(prevtitl,'не міняв посади') AS prevtitl
FROM
(SELECT emp_no, title, from_date, to_date, 
LAG(title) OVER (PARTITION BY emp_no ORDER BY from_date ) AS prevtitl
FROM employees.titles) AS tit
WHERE curdate() BETWEEN from_date and to_date;

/* 15. Из таблицы должностей, посчитать интервал в днях-сколько прошло времени отпервой должности до текущей. */
SELECT * 
FROM
(SELECT emp_no, title, from_date, to_date, 
timestampdiff(day, 
FIRST_VALUE(from_date) OVER(PARTITION BY emp_no ORDER BY from_date),
LAST_VALUE(from_date) OVER(PARTITION BY emp_no ORDER BY from_date RANGE BETWEEN                   UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING )
            ) as diffday
FROM employees.titles) AS AB
WHERE curdate() BETWEEN from_date and to_date;

/* 16. Выбрать сотрудников и отобразить их рейтингпо году принятия на работу.Попробуйте разные типы рейтингов. */
SELECT emp_no, year(hire_date),
RANK() OVER (ORDER BY year(hire_date)),
DENSE_RANK () OVER (ORDER BY year(hire_date)),
 NTILE (15) OVER (ORDER BY year(hire_date))
FROM employees.employees;
