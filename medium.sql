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

-- 5. Highest-Grossing Items, Amazon SQL Interview Question
WITH spend_sum AS(
SELECT
  category,
  product,
  SUM(spend) as total_spend
FROM product_spend
WHERE transaction_date BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY category, product
),

rank_product AS(
SELECT  
  category,
  product,
  total_spend,
  ROW_NUMBER() OVER (
    PARTITION BY category
    ORDER BY total_spend desc
  ) AS rnk
FROM spend_sum 
)

SELECT DISTINCT
  category,
  product,
  total_spend
FROM rank_product
WHERE rnk <= 2
ORDER BY category, total_spend DESC;

-- 6. Top Three Salaries, FAANG SQL Interview Question
WITH rank_table AS(
  SELECT 
      *,
      DENSE_RANK() OVER (
        PARTITION BY department_id ORDER BY salary DESC
      ) AS rnk
  FROM employee
)

SELECT
    d.department_name,
    rt.name,
    rt.salary
FROM 
    rank_table rt
LEFT JOIN department d ON
    rt.department_id = d.department_id
WHERE
    rnk IN (1,2,3)
ORDER BY 
department_name ASC, 
salary DESC,
name ASC;

-- 7. Signup Activation Rate, TikTok SQL Interview Question
SELECT 
  ROUND ((COUNT(CASE WHEN texts.signup_action = 'Confirmed' THEN 1 END)/
  COUNT(CASE WHEN texts.signup_action = 'Not Confirmed' OR texts.signup_action IS NULL THEN 1 END)::NUMERIC), 2) AS confirm_rate
FROM emails
LEFT JOIN texts
  ON emails.email_id = texts.email_id;
