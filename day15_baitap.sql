--ex1: 
WITH SpendingData AS (
SELECT EXTRACT(year FROM transaction_date) AS yr, product_id, spend,
LAG(spend) OVER (PARTITION BY product_id ORDER BY product_id, transaction_date) AS prev_year_spend
FROM user_transactions)

SELECT yr, product_id, spend AS curr_year_spend, prev_year_spend,
ROUND((((spend - prev_year_spend)/prev_year_spend)*100),2) AS yoy_rate
FROM SpendingData;

--ex2:
SELECT distinct card_name,
FIRST_VALUE(issued_amount) OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) AS issued_amount
FROM monthly_cards_issued
ORDER BY issued_amount DESC

--ex3: 
SELECT user_id, 	spend, transaction_date
from(SELECT user_id, 	spend, transaction_date,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS stt
FROM transactions) as a
WHERE stt =3;

--ex4: 
SELECT transaction_date,user_id, COUNT(product_id) AS number_of_products
FROM (SELECT user_id, product_id, transaction_date,
      RANK() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS rank
FROM user_transactions) AS RankedTransactions
WHERE rank = 1
GROUP BY user_id, transaction_date
ORDER BY transaction_date;
