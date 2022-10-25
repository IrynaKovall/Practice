
/* 1. Создать копию таблицы employees с помощью этого SQL скрипта:
create table employees_dub as select * from employees; */
create table employees_dub as select * from employees;

/* 2. Из таблицы employees_dub удалить сотрудников которые были наняты в 1985 году. */
DELETE FROM employees.employees_dup
WHERE year(hire_date) = '1985';

/* 3. В таблице employees_dub сотруднику под номером 10008 изменить дату приема
на работу на ‘1994-09-01’. */
UPDATE employees.employees_dup
SET hire_date = '1994-09-01'
WHERE emp_no = 10008;

/* 4. В таблицу employees_dub добавить двух произвольных сотрудников. */
INSERT INTO employees.employees_dup 
VALUES(10, '1992-08-09', 'Iryna', 'Koval', 'F', '2022-01-01'),
(11, '1998-10-01', 'Inna', 'Korot', 'F', '2015-01-01');

/* 5. Создать таблицу client с полями: 
• clnt_no ( AUTO_INCREMENT первичный ключ)
• cnlt_name (нельзя null значения)
• clnt_tel (нельзя null значения)
• clnt_region_no */
CREATE TABLE IF NOT EXISTS client(
clnt_no TINYINT AUTO_INCREMENT,
cnlt_name VARCHAR(100) NOT NULL,
clnt_tel TINYINT NOT NULL,
clnt_region_no TINYINT,
PRIMARY KEY (clnt_no));

/* 6. Создать таблицу sales с полями:
• clnt_no (внешний ключ на таблицу client поле clnt_no; режим RESTRICT для
update и delete)
• product_no (нельзя null значения)
• date_act (по умолчанию текущая дата)  */
CREATE TABLE IF NOT EXISTS sales( 
clnt_no TINYINT,
product_no TINYINT NOT NULL, 
date_act TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (clnt_no) REFERENCES client(clnt_no) ON UPDATE RESTRICT ON DELETE RESTRICT);

/* 7. Добавить 5 клиентов (тестовые данные на свое усмотрение) в таблицу client. */
INSERT INTO client(cnlt_name, clnt_tel, clnt_region_no)
VALUES
('Iryna', 2 , 1),
('Trip', 2, 2),
('Trisi', 2 , 2),
('Ra', 2 , 1),
('Vova', 2 ,3);

/* 8. Добавить по 2 продажи для каждого сотрудника (тестовые данные на свое
усмотрение ) в таблицу sales. */
INSERT INTO sales (clnt_no, product_no)
VALUES 
(1, 25),(1,56),(2,89),(2,58),
(3,87),(3,45),(4,78),(4,88),
(5,09),(5,02);

/* 9. Удалить из sales клиента по clnt_no=1, после чего повторить удаление из client по clnt_no=1  */
DELETE FROM sales
WHERE clnt_no =1;
DELETE FROM client
WHERE clnt_no =1;

/* 10. Из таблицы client удалить столбец clnt_region_no. */
ALTER TABLE client
DROP COLUMN clnt_region_no;

/* 11. В таблице client переименовать поле clnt_tel в clnt_phone. */
ALTER TABLE client
CHANGE COLUMN
clnt_tel
clnt_phone TINYINT NOT NULL;

/* 12. Удалить данные в таблице departments_dup с помощью DDL оператора truncate. */
TRUNCATE TABLE departments_dup;

/* 13. В схеме tempdb создать таблицу dept_empс делением по партициям по полю from_date. Для этого:
•Избазы данных employees таблицы dept_emp →из Info-Table inspector-DDL взять и скопировать код посозданиютой таблицы.
•Убрать из DDL кода упоминаниепро KEY иCONSTRAINT.
•Идобавить код для секционирования по полю from_dateс 1985 года до 2002.
Партиции по каждому году. HINT: CREATE TABLE... PARTITION BY RANGE (YEAR(from_date)) (PARTITION...) */
USE tempdb;
CREATE TABLE dept_emp (
  emp_no int NOT NULL,
  dept_no char(4) NOT NULL,
  from_datec date NOT NULL,
  to_date date NOT NULL
   )
PARTITION BY RANGE (year(from_datec)) (
    PARTITION p0 VALUES LESS THAN (1985),
    PARTITION p1 VALUES LESS THAN (1986),
    PARTITION p2 VALUES LESS THAN (1987),
    PARTITION p3 VALUES LESS THAN (1988),
    PARTITION p4 VALUES LESS THAN (1989),
	PARTITION p5 VALUES LESS THAN (1990),
	PARTITION p6 VALUES LESS THAN (1991),
	PARTITION p7 VALUES LESS THAN (1992),
	PARTITION p8 VALUES LESS THAN (1993),
	PARTITION p9 VALUES LESS THAN (1994),
	PARTITION p10 VALUES LESS THAN (1995),
	PARTITION p11 VALUES LESS THAN (1996),
	PARTITION p12 VALUES LESS THAN (1997),
	PARTITION p13 VALUES LESS THAN (1998),
	PARTITION p14 VALUES LESS THAN (1999),
	PARTITION p15 VALUES LESS THAN (2000),
 	PARTITION p16 VALUES LESS THAN (2001),   
    PARTITION p17 VALUES LESS THAN MAXVALUE
);
INSERT INTO tempdb.dept_emp
SELECT * FROM employees.dept_emp;

/* 14. Создать индекс на таблицу tempdb.dept_emp по полю dept_no. */
CREATE INDEX ind_dept ON tempdb.dept_emp(dept_no);

/* 15. Изтаблицыtempdb.dept_empвыбрать данные толькоза 1990 год. */
SELECT * FROM tempdb.dept_emp PARTITION(p6);
