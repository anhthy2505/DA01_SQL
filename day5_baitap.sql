--ex1: Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.
SELECT DISTINCT CITY FROM STATION WHERE ID%2 = 0;

--ex2: Đếm số lượng khác biệt 
SELECT COUNT(CITY) - COUNT (DISTINCT CITY) FROM STATION;

--ex4: 
SELECT CAST(SUM(item_count * order_occurrences) / SUM(order_occurrences) AS DECIMAL(10,1)) FROM items_per_order;

--ex5: sử dụng hàm IN (liệt kê)
SELECT candidate_id FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id;

--ex6: ngày xa nhất, gần nhất, công thức lấy năm trong date_time, 
SELECT user_id, max(date(post_date)) - min(date(post_date)) as days_between
FROM posts
WHERE EXTRACT(YEAR FROM post_date) = 2021 
GROUP BY user_id
having count(post_id) >= 2

--ex7: 
SELECT card_name, MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;
