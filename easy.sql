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












