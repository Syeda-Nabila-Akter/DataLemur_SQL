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

-- Second Highest Salary, FAANG SQL Interview Question
SELECT
  salary AS second_highest_salary
FROM
  (
  WITH uniqueSalaries AS (
    SELECT DISTINCT salary
    from employee
  )
  
  SELECT
    salary,
    ROW_NUMBER () OVER (
    order by salary desc 
    ) as counter
  FROM uniqueSalaries
  ) as counter_table
WHERE counter = 2;
