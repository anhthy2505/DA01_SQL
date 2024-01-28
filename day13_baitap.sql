--ex1:
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM (
    SELECT company_id, title, description
    FROM job_listings
    GROUP BY company_id, title, description
    HAVING COUNT(job_id) > 1
) AS duplicates;

--ex2:

--ex3: WITH abc AS (
    SELECT policy_holder_id
    FROM callers
    GROUP BY policy_holder_id
    HAVING COUNT(case_id) >= 3
)
SELECT COUNT(*) as member_count
FROM abc;

--ex4:
SELECT p.page_id
from pages as p
left join page_likes as k
on p.page_id = k.page_id
where k.page_id is null

--ex5: 
WITH users_june AS (SELECT DISTINCT user_id FROM user_actions
WHERE event_type IN ('sign-in', 'like', 'comment')
AND EXTRACT(MONTH FROM event_date) = 6
AND EXTRACT(YEAR FROM event_date) = 2022), 
users_july AS (SELECT DISTINCT user_id FROM user_actions
WHERE event_type IN ('sign-in', 'like', 'comment')
AND EXTRACT(MONTH FROM event_date) = 7
AND EXTRACT(YEAR FROM event_date) = 2022)

SELECT 7 AS month, COUNT(DISTINCT uj.user_id) AS mau_count
FROM users_june uj
JOIN users_july ujl ON uj.user_id = ujl.user_id;

--ex6:
SELECT DATE_FORMAT(trans_date, '%Y-%m') as month, country,
COUNT(*) AS trans_count,
SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount 
FROM Transactions 
GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country

--ex7: 
SELECT s.product_id, s.year as first_year, s.quantity, s.price
FROM Sales as s
INNER JOIN (SELECT product_id, MIN(year) as min_year FROM Sales GROUP BY product_id) as first_year 
ON s.product_id = first_year.product_id 
AND s.year = first_year.min_year;

--ex8:
SELECT c.customer_id
FROM Customer c
JOIN Product p ON c.product_key = p.product_key
GROUP BY c.customer_id
HAVING COUNT(DISTINCT c.product_key) = (SELECT COUNT(*) FROM Product);

--ex9:
SELECT e.employee_id FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.employee_id
WHERE e.salary < 30000 AND m.employee_id IS NULL
ORDER BY e.employee_id;

--ex10:
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM (SELECT company_id, title, description FROM job_listings
GROUP BY company_id, title, description
HAVING COUNT(job_id) > 1) AS duplicates;

--ex11:
SELECT u.name AS results
FROM Users u
JOIN (SELECT user_id FROM MovieRating
GROUP BY user_id
ORDER BY COUNT(*) DESC, user_id
LIMIT 1) AS top_user 
ON u.user_id = top_user.user_id

UNION ALL
SELECT m.title AS results
FROM Movies m
JOIN (SELECT movie_id FROM MovieRating
WHERE MONTH(created_at) = 2 AND YEAR(created_at) = 2020
GROUP BY movie_id
ORDER BY AVG(rating) DESC, movie_id
LIMIT 1) AS top_movie 
ON m.movie_id = top_movie.movie_id;

--ex12: 
WITH AllFriendships as (SELECT requester_id as id FROM RequestAccepted
UNION ALL
SELECT accepter_id as id FROM RequestAccepted),
FriendCounts as (SELECT id, COUNT(*) as num FROM AllFriendships
GROUP BY id)
SELECT fc.id, fc.num
FROM FriendCounts as fc
ORDER BY fc.num DESC, fc.id
LIMIT 1;

