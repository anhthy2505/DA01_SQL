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
WITH users_june AS (
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE event_type IN ('sign-in', 'like', 'comment')
    AND EXTRACT(MONTH FROM event_date) = 6
    AND EXTRACT(YEAR FROM event_date) = 2022
), users_july AS (
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE event_type IN ('sign-in', 'like', 'comment')
    AND EXTRACT(MONTH FROM event_date) = 7
    AND EXTRACT(YEAR FROM event_date) = 2022
)
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
