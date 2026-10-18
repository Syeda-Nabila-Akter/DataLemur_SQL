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
