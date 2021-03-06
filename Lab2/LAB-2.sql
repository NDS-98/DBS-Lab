--Practice--

--insert
CREATE TABLE CUSTOMER(
CUSTOMER_ID VARCHAR(20) PRIMARY KEY,
CUSTOMER_NAME CHAR(50)
);

INSERT INTO CUSTOMER VALUES('2016A7PS0339P','ALEX');
INSERT INTO CUSTOMER VALUES('2016A7PS0018P','GIRINATH');

CREATE TABLE CUSTOMER_COPY(
CUSTOMER_ID VARCHAR(20) PRIMARY KEY,
CUSTOMER_NAME CHAR(50)
);

INSERT INTO CUSTOMER_COPY(CUSTOMER_ID,CUSTOMER_NAME)
SELECT * FROM CUSTOMER;

SELECT * FROM CUSTOMER_COPY;

--update
CREATE TABLE STUDENTS (
IDNO CHAR(50),
NAME VARCHAR(100),
EMAIL VARCHAR(100),
CGPA NUMERIC(4,2)
);

INSERT INTO STUDENTS(NAME,EMAIL,IDNO,CGPA)
VALUES('ALEX','123@@gmail.com','2000A7PS001',7.34);
INSERT INTO STUDENTS(NAME,EMAIL,IDNO,CGPA)
VALUES('GIRI','123@@gmail.com','2000A7PS001',7.34);

UPDATE STUDENTS
SET NAME='TEST', EMAIL='test@yahoo.com'
WHERE IDNO='2000A7PS001';

UPDATE STUDENTS
SET CGPA=10;

--delete
DELETE FROM STUDENTS
WHERE IDNO='2000A7PS001';

DELETE FROM STUDENTS;  --deletes all records

TRUNCATE TABLE STUDENTS;  --deletes all records

SELECT * FROM STUDENTS;

--restaurant.sql
SELECT NAME FROM ITEMS
WHERE PRICE<=0.99;

SELECT NAME FROM ITEMS
WHERE DATEADDED>'31-DEC-99'; --OR '1999-12-31'

SELECT NAME FROM ITEMS
WHERE NAME<='GARDEN';

SELECT REPFNAME FROM VENDORS
WHERE REPFNAME LIKE 'S%';

SELECT COMPANYNAME FROM VENDORS
WHERE COMPANYNAME LIKE '%#_%' ESCAPE '#';

SELECT COMPANYNAME FROM VENDORS
WHERE COMPANYNAME LIKE '%\_%' ESCAPE '\';

SELECT COMPANYNAME FROM VENDORS
WHERE COMPANYNAME LIKE '%''' ;

--logical operators
SELECT NAME FROM ITEMS
WHERE NOT NAME LIKE '%SALAD';

SELECT INGREDIENTID,NAME FROM INGREDIENTS
WHERE FOODGROUP='FRUIT' AND INVENTORY>100;

SELECT * FROM ITEMS
WHERE (NAME LIKE 'S%' OR NAME LIKE 'F%') AND PRICE<3.5;

--between
SELECT NAME FROM ITEMS
WHERE PRICE BETWEEN 2.50 AND 3.50;

SELECT * FROM INGREDIENTS;

--not in
SELECT INGREDIENTID,NAME,UNIT FROM INGREDIENTS
WHERE UNIT NOT IN ('PIECE','STRIP');

--is null
SELECT * FROM VENDORS
WHERE REFERREDBY IS NULL;

SELECT * FROM VENDORS
WHERE REFERREDBY=NULL;  --gives unknown result, so IS NULL preferred.


--Exercise--
exec sp_MSforeachtable "declare @name nvarchar(max); set @name = parsename('?', 1); exec
sp_MSdropconstraints @name";
exec sp_MSforeachtable "drop table ?";--1SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES;--2SELECT * FROM PROJECTSWHERE REVENUE>40000;--3SELECT DEPTCODE FROM PROJECTSWHERE REVENUE BETWEEN 100000 AND 150000;SELECT * FROM PROJECTS; --test--4SELECT PROJECTID FROM PROJECTSWHERE STARTDATE<='2004-07-01';--5SELECT * FROM DEPARTMENTS; --testSELECT NAME FROM DEPARTMENTSWHERE SUBDEPTOF IS NULL;--6SELECT PROJECTID,DESCRIPTION FROM PROJECTSWHERE DEPTCODE IN ('ACCNT','CNSLT','HDWRE');--7SELECT * FROM EMPLOYEESWHERE LASTNAME LIKE '____WARE';--8SELECT EMPLOYEEID,LASTNAME FROM EMPLOYEESWHERE DEPTCODE='ACTNG' AND SALARY<30000;SELECT * FROM EMPLOYEES; --test--9SELECT * FROM PROJECTSWHERE (STARTDATE>GETDATE() OR STARTDATE IS NULL) AND REVENUE>0;--10SELECT PROJECTID FROM PROJECTSWHERE (DEPTCODE='ACTNG' OR ENDDATE IS NULL) AND (NOT REVENUE<=50000);--Practice----aliasSELECT COMPANYNAME AS "COMPANY",REPFNAME AS "FIRST NAME" FROM VENDORS;SELECT DISTINCT FOODGROUP,VENDORID FROM INGREDIENTS; --their combination is distinctSELECT INGREDIENTID, INVENTORY*2*UNITPRICE AS "INVENTORY VALUE" FROM INGREDIENTSWHERE NAME='PICKLE';SELECT MANAGER,CONVERT(VARCHAR(10),GETDATE(),105) AS "AS ON",ADDRESS+' '+CITY+' '+STATE+' '+ZIP+' USA' AS "MAIL" FROM STORES;SELECT * FROM STORES; --test--order bySELECT NAME,PRICE FROM ITEMSORDER BY PRICE DESC;  --ASC for ascendingSELECT NAME,INVENTORY*UNITPRICE AS "VALUE" FROM INGREDIENTSORDER BY VALUE ASC;--conditional expressions--caseSELECT NAME,CASE FOODGROUPWHEN 'Vegetable' THEN 'Good'
WHEN 'Fruit' THEN 'Good'
WHEN 'Milk' THEN 'Acceptable'
WHEN 'Bread' THEN 'Acceptable'
WHEN 'Meat' THEN 'Bad'
END AS quality
FROM ingredients;

SELECT NAME,
FLOOR (CASE
WHEN inventory < 20 THEN 20 - inventory
WHEN foodgroup = 'Milk' THEN inventory * 0.05
WHEN foodgroup IN ('Meat', 'Bread') THEN inventory * 0.10
WHEN foodgroup = 'Vegetable' AND unitprice <= 0.03 THEN inventory * 0.10
WHEN foodgroup = 'Vegetable' THEN inventory * 0.03
WHEN foodgroup = 'Fruit' THEN inventory * 0.04
WHEN foodgroup IS NULL THEN inventory * 0.07 ELSE 0 END)
AS size, vendorid
FROM ingredients
WHERE inventory < 1000 AND vendorid IS NOT NULL
ORDER BY vendorid, size;

--nullif
SELECT ingredientid, name, unit, unitprice,
NULLIF(foodgroup, 'Meat') AS foodgroup, inventory, vendorid FROM
ingredients;

--coalesce
SELECT name, price, COALESCE(price, 0.00) AS "no nulls" FROM items;


--Exercise--
exec sp_MSforeachtable "declare @name nvarchar(max); set @name = parsename('?', 1); exec
sp_MSdropconstraints @name";
exec sp_MSforeachtable "drop table ?";

--1
SELECT FIRSTNAME+' '+LASTNAME AS "NAME" FROM EMPLOYEES;

--2
SELECT DISTINCT DEPTCODE FROM PROJECTS;

--3
SELECT PROJECTID,DATEDIFF(DAY,STARTDATE,ENDDATE) AS "DURATION(IN DAYS)" FROM PROJECTS;

--4
SELECT PROJECTID,CASE 
WHEN ENDDATE IS NULL THEN DATEDIFF(DAY,STARTDATE,GETDATE())
ELSE DATEDIFF(DAY,STARTDATE,ENDDATE) END AS "DURATION"
FROM PROJECTS;

--5
SELECT PROJECTID,REVENUE/DATEDIFF(DAY,STARTDATE,ENDDATE) AS "AVG REVENUE PER DAY" FROM PROJECTS
WHERE ENDDATE IS NOT NULL;

--6
SELECT DISTINCT YEAR(STARTDATE) FROM PROJECTS;

--7 imp
SELECT * FROM WORKSON; --test

SELECT DISTINCT EMPLOYEEID
FROM WORKSON W1
WHERE PROJECTID IN (SELECT PROJECTID
FROM WORKSON W2
GROUP BY PROJECTID
HAVING SUM(ASSIGNEDTIME)*40 > 20) ;

SELECT DISTINCT EMPLOYEEID
FROM WORKSON W1
WHERE PROJECTID IN (SELECT PROJECTID
FROM WORKSON W2
GROUP BY PROJECTID
HAVING SUM(ASSIGNEDTIME)*40 > 40) ;

SELECT DISTINCT EMPLOYEEID
FROM WORKSON W1
WHERE PROJECTID IN (SELECT PROJECTID
FROM WORKSON W2
GROUP BY PROJECTID
HAVING SUM(ASSIGNEDTIME)*40 > 60) ;

--8
SELECT EMPLOYEEID,CASE
WHEN ASSIGNEDTIME<0.33 THEN 'PART TIME'
WHEN ASSIGNEDTIME>=0.33 AND ASSIGNEDTIME<0.67 THEN 'SPLIT TIME'
WHEN ASSIGNEDTIME>=0.67 THEN 'FULL TIME' END AS "TYPE"
FROM WORKSON;

--9
SELECT UPPER(SUBSTRING(DESCRIPTION,1,3))+'-'+DEPTCODE AS "ABB PR NAME" FROM PROJECTS;

--10
SELECT PROJECTID,YEAR(STARTDATE) AS "STARTYEAR" FROM PROJECTS
ORDER BY STARTYEAR ASC;

--11
SELECT LASTNAME,SALARY*1.05 AS "NEW SALARY" FROM EMPLOYEES
WHERE SALARY*1.05>50000;

--12
SELECT EMPLOYEEID,FIRSTNAME,LASTNAME,SALARY*1.10 AS "NEXT YEAR" FROM EMPLOYEES
WHERE DEPTCODE='HDWRE';

--13
SELECT DEPTCODE,FIRSTNAME+' '+LASTNAME AS "NAME" FROM EMPLOYEES
ORDER BY DEPTCODE ASC,LASTNAME ASC,FIRSTNAME ASC; 