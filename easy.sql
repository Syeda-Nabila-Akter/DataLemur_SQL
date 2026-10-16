-- 1. Histogram of Tweets, Twitter SQL Interview Question 
select ct as tweet_bucket, 
count (user_id) as users_num
from (
  select user_id,
  count(tweet_id) as ct
  from tweets  
  where tweet_date between '2022-01-01' and '2022-12-31'
  group by user_id
  ) as user_tweet
group by ct;

-- 2. Data Science Skills, LinkedIn SQL Interview Question 
select candidate_id from candidates
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id
having count (skill) = 3;

-- 3. Page With No Likes, Facebook SQL Interview Question
select p.page_id
from pages p 
full join page_likes pl on pl.page_id = p.page_id
where pl.page_id is null
order by p.page_id asc;

-- 4. Unfinished Parts, Tesla SQL Interview Question
SELECT part, assembly_step 
FROM parts_assembly
WHERE finish_date IS NULL;

-- 5. Laptop vs. Mobile Viewership, NY Times SQL Interview Question
select 
sum(case when device_type = 'laptop' then 1 else 0 end) as laptop_views,
sum(case when device_type IN ('tablet', 'phone') then 1 else 0 end) as mobile_views
from viewership;

-- 6. Average Post Hiatus (Part 1), Facebook SQL Interview Question
select 
user_id,
date(max(post_date)) - date(min(post_date)) as days_between
from posts
where post_date between '2021-01-01' and '2021-12-31'
group by user_id
having count(*) > 1;

-- 7. Teams Power Users, Microsoft SQL Interview Question
SELECT sender_id, count(*) as message_count
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-08-31' 
GROUP BY sender_id
ORDER BY message_count desc
limit 2;

-- 8. Duplicate Job Listings, LinkedIn SQL Interview Question
select count(*)
from (
  select count(*) as c
  from job_listings
  group by company_id, title, description
  having count(*)>1
) as job_list
group by c 
having c >= 1;

-- 9. Cities With Completed Trades, Robinhood SQL Interview Question
select city, count(sm_tb.quantity) as total_orders
  from 
  (
  select * 
  from trades
  left join users on users.user_id = trades.user_id
  where trades.status = 'Completed'
  ) as sm_tb
group by sm_tb.city
order by count(sm_tb.quantity) desc limit 3;

-- 10. Average Review Ratings, Amazon SQL Interview Question
select 
extract (month from submit_date) as mth, 
product_id as product,
round(avg(stars), 2) as avg_stars
from reviews
group by mth, product_id;

-- 11. Well Paid Employees, FAANG SQL Interview Question
select 
employee_id,
employee_name
from
(
  select 
    e.employee_id,
    e.name as employee_name,
    e.salary as employee_salary,
    m.employee_id as manager_id,
    m.salary as manager_salary
  from employee as e
  left join employee as m
    on  e.manager_id = m.employee_id
) as new_table
where employee_salary > manager_salary;

-- 12. Final Account Balance, PayPal SQL Interview Question
select 
account_id,
Deposit - Withdrawal as final_balance
from 
(
  select 
  account_id,
  sum (case when transaction_type = 'Deposit' then amount else 0 end) as Deposit,
  sum (case when transaction_type = 'Withdrawal' then amount else 0 end) as Withdrawal
  from transactions
  group by account_id
) as new_table;

-- 13. App Click-through Rate (CTR), Facebook SQL Interview Question
select 
app_id, 
round(100.0 * number_of_clicks/numbers_of_impressions, 2) as ctr
from
(
  select 
  app_id,
  sum(case when event_type = 'click' then 1 else 0 end) as number_of_clicks,
  sum(case when event_type = 'impression' then 1 else 0 end) as numbers_of_impressions
  from events
  where timestamp between '2022-01-01' and '2022-12-31'
  group by app_id
) as new_table;

-- 14. Second Day Confirmation, TikTok SQL Interview Question
select 
emails.user_id
from emails
left join texts on emails.email_id = texts.email_id
where datediff(texts.action_date, emails.signup_date) = 1;

-- 15. IBM db2 Product Analytics, IBM SQL Interview Question
select
query_count as unique_queries,
count(employee_id) as employee_count
from
(
  select e.employee_id, count(q.query_id) as query_count
  from employees e
  left join queries q on e.employee_id = q.employee_id
  and q.query_starttime between '2023-07-01' and '2023-10-01'
  group by e.employee_id
) as new_table
group by query_count
order by query_count;

-- 16. Cards Issued Difference, JPMorgan SQL Interview Question
select 
card_name,
max(issued_amount) - min(issued_amount) as difference
from monthly_cards_issued
group by card_name
order by difference desc;

-- 17. Compressed Mean, Alibaba SQL Interview Question
select 
round(sum(cast(item_count as decimal) * cast(order_occurrences as decimal))/sum(cast(order_occurrences as decimal)), 1) as mean
from items_per_order;

-- 18. Pharmacy Analytics (Part 1), CVS Health SQL Interview Question
select 
drug,
total_sales - cogs as total_profit
from pharmacy_sales
order by total_profit desc limit 3;

-- 19. Pharmacy Analytics (Part 2), CVS Health SQL Interview Question
select 
manufacturer, 
count(drug) as 	drug_count,
sum(cogs - total_sales) as total_loss
from pharmacy_sales
where cogs > total_sales
group by manufacturer
order by total_loss desc;

-- 20. Pharmacy Analytics (Part 3), CVS Health SQL Interview Question
select 
manufacturer,
concat('$',round(sum(total_sales)/1000000), ' million') as sales_mil
from pharmacy_sales
group by manufacturer
order by sum(total_sales) desc;

-- 21. Patient Support Analysis (Part 1), UnitedHealth SQL Interview Question
select count(*) as policy_holder_count
from (
  select policy_holder_id
  from callers
  group by policy_holder_id
  having count(case_id) >=3
) as sub_q_table;

