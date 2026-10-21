-- Active User Retention, Facebook SQL Interview Question
WITH date_extract AS(
  SELECT 
    user_id,
    EXTRACT (MONTH FROM event_date) AS extracted_month
  FROM user_actions
  WHERE event_date BETWEEN '2022-06-01' AND '2022-07-31'
),

active_user AS(
  SELECT 
    user_id
  FROM date_extract
  GROUP BY user_id
  HAVING COUNT(DISTINCT extracted_month) = 2
)

SELECT
  '7' AS month,
  COUNT(*) as monthly_active_users
FROM active_user;
  
