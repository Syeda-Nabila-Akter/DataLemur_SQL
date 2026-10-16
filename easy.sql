-- 1. Histogram of Tweets, Twitter SQL Interview Question 
SELECT 
  ct AS tweet_bucket, 
  COUNT (user_id) AS users_num
  FROM (
    SELECT user_id,
    COUNT(tweet_id) AS ct
    FROM tweets  
    WHERE tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
    GROUP BY user_id
    ) AS user_tweet
GROUP BY ct;

-- 2. Data Science Skills, LinkedIn SQL Interview Question 
SELECT candidate_id FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT (skill) = 3;

-- 3. Page With No Likes, Facebook SQL Interview Question
SELECT p.page_id
FROM pages p 
FULL JOIN page_likes pl ON pl.page_id = p.page_id
WHERE pl.page_id IS NULL
ORDER BY p.page_id ASC;

-- 4. Unfinished Parts, Tesla SQL Interview Question
SELECT part, assembly_step 
FROM parts_assembly
WHERE finish_date IS NULL;

-- 5. Laptop vs. Mobile Viewership, NY Times SQL Interview Question
SELECT
SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;

-- 6. Average Post Hiatus (Part 1), Facebook SQL Interview Question
SELECT 
  user_id,
  date(max(post_date)) - date(min(post_date)) AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY user_id
HAVING COUNT(*) > 1;

-- 7. Teams Power Users, Microsoft SQL Interview Question
SELECT 
  sender_id, 
  COUNT(*) AS message_count
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-08-31' 
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

-- 8. Duplicate Job Listings, LinkedIn SQL Interview Question
SELECT COUNT(*)
FROM (
  SELECT COUNT(*) AS c
  FROM job_listings
  GROUP BY company_id, title, description
  HAVING COUNT(*)>1
) AS job_list
GROUP BY c 
HAVING c >= 1;

-- 9. Cities With Completed Trades, Robinhood SQL Interview Question
SELECT 
  city, 
  COUNT(sm_tb.quantity) AS total_orders
  FROM (
    SELECT * 
    FROM trades
    LEFT JOIN users ON users.user_id = trades.user_id
    WHERE trades.status = 'Completed'
    ) AS sm_tb
GROUP BY sm_tb.city
ORDER BY COUNT(sm_tb.quantity) DESC LIMIT 3;

-- 10. Average Review Ratings, Amazon SQL Interview Question
SELECT 
  extract (MONTH FROM submit_date) AS mth, 
  product_id AS product,
  round(avg(stars), 2) AS avg_stars
FROM reviews
GROUP BY mth, product_id;

-- 11. Well Paid Employees, FAANG SQL Interview Question
SELECT 
  employee_id,
  employee_name
  FROM
  (
    SELECT 
      e.employee_id,
      e.name AS employee_name,
      e.salary AS employee_salary,
      m.employee_id AS manager_id,
      m.salary AS manager_salary
    FROM employee AS e
    LEFT JOIN employee AS m
      ON  e.manager_id = m.employee_id
  ) AS new_table
WHERE employee_salary > manager_salary;

-- 12. Final Account Balance, PayPal SQL Interview Question
SELECT 
  account_id,
  Deposit - Withdrawal AS final_balance
FROM 
(
  SELECT 
  account_id,
  sum (CASE WHEN transaction_type = 'Deposit' THEN amount ELSE 0 END) AS Deposit,
  sum (CASE WHEN transaction_type = 'Withdrawal' THEN amount ELSE 0 END) AS Withdrawal
  FROM transactions
  GROUP BY account_id
) AS new_table;

-- 13. App Click-through Rate (CTR), Facebook SQL Interview Question
SELECT 
  app_id, 
  round(100.0 * number_of_clicks/numbers_of_impressions, 2) AS ctr
FROM
(
  SELECT 
  app_id,
  sum(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS number_of_clicks,
  sum(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) AS numbers_of_impressions
  FROM events
  WHERE timestamp BETWEEN '2022-01-01' AND '2022-12-31'
  GROUP BY app_id
) AS new_table;

-- 14. Second Day Confirmation, TikTok SQL Interview Question
SELECT 
  emails.user_id
FROM emails
LEFT JOIN texts ON emails.email_id = texts.email_id
WHERE datediff(texts.action_date, emails.signup_date) = 1;

-- 15. IBM db2 Product Analytics, IBM SQL Interview Question
SELECT
  query_count AS unique_queries,
  COUNT(employee_id) AS employee_count
FROM
(
  SELECT e.employee_id, COUNT(q.query_id) AS query_count
  FROM employees e
  LEFT JOIN queries q ON e.employee_id = q.employee_id
  AND q.query_starttime BETWEEN '2023-07-01' AND '2023-10-01'
  GROUP BY e.employee_id
) AS new_table
GROUP BY query_count
ORDER BY query_count;

-- 16. Cards Issued Difference, JPMorgan SQL Interview Question
SELECT 
  card_name,
  max(issued_amount) - min(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

-- 17. Compressed Mean, Alibaba SQL Interview Question
SELECT 
round(sum(CAST(item_count AS decimal) * CAST(order_occurrences AS decimal))/sum(CAST(order_occurrences AS decimal)), 1) AS mean
FROM items_per_order;

-- 18. Pharmacy Analytics (Part 1), CVS Health SQL Interview Question
SELECT 
  drug,
  total_sales - cogs AS total_profit
FROM pharmacy_sales
ORDER BY total_profit DESC LIMIT 3;

-- 19. Pharmacy Analytics (Part 2), CVS Health SQL Interview Question
SELECT 
  manufacturer, 
  COUNT(drug) AS 	drug_count,
  sum(cogs - total_sales) AS total_loss
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC;

-- 20. Pharmacy Analytics (Part 3), CVS Health SQL Interview Question
SELECT 
  manufacturer,
  concat('$',round(sum(total_sales)/1000000), ' million') AS sales_mil
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY sum(total_sales) DESC;

-- 21. Patient Support Analysis (Part 1), UnitedHealth SQL Interview Question
SELECT 
  COUNT(*) AS policy_holder_count
FROM (
  SELECT policy_holder_id
  FROM callers
  GROUP BY policy_holder_id
  HAVING COUNT(case_id) >=3
) AS sub_q_table;
