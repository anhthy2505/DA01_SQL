--ex1: Query the NAME field for all American cities in the CITY table with populations larger than 120000. The CountryCode for America is USA.
SELECT NAME FROM CITY WHERE COUNTRYCODE = 'USA' AND POPULATION > 120000;

--ex2: Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.
SELECT * FROM CITY WHERE COUNTRYCODE = 'JPN';

--ex3: Query a list of CITY and STATE from the STATION table.
SELECT CITY, STATE FROM STATION;

--ex4: Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION.
SELECT DISTINCT CITY FROM STATION WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%';

--ex5:Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
SELECT DISTINCT CITY FROM STATION WHERE CITY LIKE '%a' OR CITY LIKE '%e' OR CITY LIKE '%i' OR CITY LIKE '%o' OR CITY LIKE '%u';

--ex6: Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
SELECT DISTINCT CITY FROM STATION WHERE NOT (CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%');

--ex7: Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.
SELECT name FROM Employee ORDER BY name;

--ex8: Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than  per month who have been employees for less than  months. Sort your result by ascending employee_id.
SELECT name FROM Employee WHERE salary > 2000 AND months < 10 ORDER BY employee_id;

--ex9: Write a solution to find the ids of products that are both low fat and recyclable.
SELECT product_id FROM Products WHERE low_fats = 'Y' AND recyclable = 'Y';

--ex10: Find the names of the customer that are not referred by the customer with id = 2
SELECT name FROM Customer WHERE referee_id != 2 OR referee_id IS NULL;

--ex11: 
SELECT name, population,area FROM World WHERE area >= 3000000 OR population >= 25000000;

--ex12: Write a solution to find all the authors that viewed at least one of their own articles. Return the result table sorted by id in ascending order.
SELECT DISTINCT author_id as id FROM Views WHERE author_id = viewer_id ORDER BY author_id;

--ex13: 
SELECT part, assembly_step FROM parts_assembly WHERE finish_date IS NULL; 

--ex14:
select * from lyft_drivers where yearly_salary <= 30000 or yearly_salary >= 70000;

--ex15:
select advertising_channel from uber_advertising where money_spent > 100000 and year = 2019;
