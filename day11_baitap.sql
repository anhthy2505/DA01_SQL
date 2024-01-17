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

--ex3: dạ em chưa làm ra TT, có đọc giải mà chưa hiểu lắm ạ


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
SELECT 
CASE 
WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 'high'
END AS category,
COUNT(film_id) AS count
FROM film
GROUP BY category
ORDER BY count DESC
LIMIT 1

-- câu hỏi 3
SELECT a.title, a.length DESC, c.name
FROM public.film as a
join public.film_category as b
on a.film_id = b.film_id
join public.category as c
on b.category_id = c.category_id
where c.name in ('Drama', 'Sports')
limit 1

-- câu hỏi 4:
SELECT  c.name, count(a.film_id) AS film_count
FROM public.film as a
join public.film_category as b
on a.film_id = b.film_id
join public.category as c
on b.category_id = c.category_id
group by c.name
order by film_count DESC
LIMIT 1

-- câu hỏi 5:
select  a.first_name || ' ' || a.last_name as full_name,
count(film_id) as film_count
from actor as a
join film_actor as b
on a.actor_id = b.actor_id
GROUP BY full_name
order by film_count desc

-- câu hỏi 6:
select count(a.address_id)
from address as a
left join customer as c
on a.address_id = c.address_id
where c.customer_id is null

-- câu hỏi 7:
select ct.city, sum(p.amount) as amount_sum
from payment as p
join customer as c
on p.customer_id = c.customer_id
join address as a
on c.address_id = a.address_id
join city as ct
on a.city_id =ct.city_id
group by ct.city
order by amount_sum desc
limit 1

-- câu hỏi 8: (đề phải là doanh thu thấp nhất đúng ko ạ)
select ct.city || ',' || co.country as city_country, sum(p.amount) as amount_sum
from payment as p
join customer as c
on p.customer_id = c.customer_id
join address as a
on c.address_id = a.address_id
join city as ct
on a.city_id =ct.city_id
join country as co
on ct.country_id = co.country_id
group by city_country
order by amount_sum 
limit 1
