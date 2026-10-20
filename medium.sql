-- 1. User's Third Transaction, Uber SQL Interview Question
SELECT
  user_id,
  spend,
  transaction_date
FROM
(
  SELECT 
    ROW_NUMBER () OVER (
    PARTITION BY user_id 
    ORDER BY transaction_date
    ) AS group_counter,
    user_id,
    spend,
    transaction_date
    FROM transactions
) AS counter_table
WHERE group_counter = 3;

-- 2. Second Highest Salary, FAANG SQL Interview Question
SELECT
  salary AS second_highest_salary
FROM
  (
  WITH uniqueSalaries AS (
    SELECT DISTINCT salary
    FROM employee
  )
  
  SELECT
    salary,
    ROW_NUMBER () OVER (
    ORDER BY salary DESC 
    ) AS counter
  FROM uniqueSalaries
  ) AS counter_table
WHERE counter = 2;

-- 3. Tweets' Rolling Averages, Twitter SQL Interview Question
SELECT 
  user_id,
  tweet_date,
  ROUND(AVG(tweet_count) OVER (
  PARTITION BY user_id
  ORDER BY tweet_date
  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ), 2) AS rolling_avg_3d
FROM tweets;

-- 4. Sending vs. Opening Snaps, Snapchat SQL Interview Question
WITH open_send_cte AS(
  SELECT
  ab.age_bucket,
  SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END) send_sum,
  SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END) open_sum
  FROM activities a
  LEFT JOIN age_breakdown ab on a.user_id = ab.user_id
  GROUP BY ab.age_bucket
)
SELECT 
  age_bucket,
  ROUND ((send_sum/(send_sum + open_sum))*100, 2) AS send_perc,
  ROUND ((open_sum/(send_sum + open_sum))*100, 2) AS open_perc
FROM open_send_cte;
