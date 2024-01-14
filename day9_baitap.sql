--ex1:
SELECT 
  SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views, 
  SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views 
FROM viewership;

--ex2: 
SELECT x,y,z, 
CASE
  WHEN x + y > z AND y + z > x AND x + z > y THEN 'Yes'
  ELSE 'No'
END as triangle
FROM Triangle;

--ex3: bài này em chạy ra null, mà chưa nhìn ra mình sai ở đâu ạ
SELECT 
  ROUND((SUM
  (CASE WHEN call_category = 'n/a' OR call_category IS NULL THEN 1 ELSE 0 END) 
  / COUNT(case_id)) * 100, 1) AS call_percentage
FROM callers;

--ex4:
SELECT name
FROM Customer
WHERE referee_id  != 2 OR referee_id  IS NULL;

--ex5: 
SELECT survived,
SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY survived
