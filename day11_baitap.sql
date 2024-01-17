-- ex1: 
SELECT COUNTRY.Continent, FLOOR(AVG(CITY.Population)) AS AvgCityPopulation
FROM CITY
JOIN COUNTRY ON CITY.CountryCode = COUNTRY.Code
GROUP BY COUNTRY.Continent;

--ex2: 
SELECT 
  ROUND(CAST(COUNT(texts.email_id) AS DECIMAL) 
    / CAST(COUNT(DISTINCT emails.email_id) AS DECIMAL), 2) AS activation_rate
FROM emails
LEFT JOIN texts
  ON emails.email_id = texts.email_id
  AND texts.signup_action = 'Confirmed';

--ex3:


--ex4: 
WITH supercloud AS 
(SELECT a.customer_id, 
COUNT(DISTINCT b.product_category) AS unique_count
FROM customer_contracts AS a
left join products as b
on a.product_id =b.product_id
GROUP BY a.customer_id)

SELECT customer_id
FROM supercloud
WHERE unique_count = (
  SELECT COUNT(DISTINCT product_category) 
  FROM products)
ORDER BY customer_id;

--ex5:
SELECT 
    m.employee_id, 
    m.name, 
    COUNT(e.employee_id) AS reports_count, 
    ROUND(AVG(e.age)) AS average_age
FROM Employees AS m
LEFT JOIN Employees AS e ON m.employee_id = e.reports_to
WHERE m.employee_id IN (SELECT reports_to FROM Employees WHERE reports_to IS NOT NULL)
GROUP BY m.employee_id, m.name
ORDER BY m.employee_id;

--ex6: 
SELECT p.product_name, SUM(o.unit) AS unit
FROM Products AS p
JOIN Orders AS o 
ON p.product_id = o.product_id
WHERE o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

--ex7: 
SELECT p.page_id
from pages as p
left join page_likes as k
on p.page_id = k.page_id
where k.page_id is null


-- BÀI GIỮA KÌ 
-- câu hỏi 1
select distinct replacement_cost from film
order by replacement_cost
limit 1

-- câu hỏi 2
select 
case 
when replacement_cost between 9.99 and 19.99 then 'low'
when replacement_cost between 20.00 and 24.99 then 'medium'
when replacement_cost between 25.00 and 29.99 then 'high'
end as category
from film
group by category
having category = 'low'
count(film_id) as low_count
