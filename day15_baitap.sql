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

--ex5: 
SELECT  user_id, tweet_date,   
  ROUND(AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date 
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets;

--ex6: 
SELECT COUNT(*)
FROM (SELECT *,
LAG(transaction_timestamp) OVER (PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp) AS previous_timestamp
FROM transactions) AS subquery
WHERE transaction_timestamp - previous_timestamp <= INTERVAL '10 minutes';

--ex7: 
SELECT category, product, total_spend
FROM(SELECT category, product, 
      SUM(spend) AS total_spend,
      RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) as rank
    FROM product_spend
    WHERE extract(year from transaction_date) = 2022
    GROUP BY category, product) AS ranked_products
WHERE rank <= 2;

--ex8: 
with top_5 as (
SELECT a.artist_name, DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) as artist_rank
FROM artists a
JOIN songs s ON a.artist_id = s.artist_id
JOIN global_song_rank gsr ON s.song_id = gsr.song_id
WHERE gsr.rank <= 10
GROUP BY a.artist_name)
SELECT artist_name, artist_rank
FROM top_5
WHERE artist_rank <= 5;

