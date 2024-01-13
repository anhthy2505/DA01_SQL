--ex1:
SELECT Name FROM STUDENTS WHERE Marks > 75 ORDER BY RIGHT(Name,3), ID;

--ex2:
SELECT user_id, CONCAT(UPPER(LEFT(name, 1)), LOWER(RIGHT(name, LENGTH(name)-1))) as name  FROM Users;

--ex3: 
SELECT manufacturer, CONCAT('$',ROUND(SUM(total_sales)/1000000,0), ' ', 'million' ) as sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer

--ex4: 
SELECT EXTRACT(month from submit_date) as mth, product_id, ROUND(AVG(stars),2) as avg_stars
FROM reviews 
GROUP BY EXTRACT(month from submit_date), product_id
ORDER BY EXTRACT(month from submit_date), product_id;

--ex5: 
SELECT sender_id, COUNT(message_id) as message_count
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = '8' AND EXTRACT(YEAR FROM sent_date) = '2022'
GROUP BY sender_id
ORDER BY COUNT(message_id) desc
LIMIT 2;

--ex6: 
SELECT tweet_id FROM Tweets WHERE LENGTH(content)>15

--ex7: 
SELECT activity_date as day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date
ORDER BY activity_date;


--ex8:
select count(id) 
from employees 
where joining_date BETWEEN '2022-01-01' AND '2022-07-31';

--ex9: 
select position('a' IN first_name) from worker where first_name = 'Amitah';

--ex10: 
select id, substring(title from length(winery)+2 for 4) as vintage_years from winemag_p2
where country = 'Macedonia'
