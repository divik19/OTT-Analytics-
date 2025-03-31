-- 1. Total Users & Growth Trends
-- What is the total number of users for LioCinema and Jotstar, and how do they compare in terms of growth trends (January–November 2024)?

select 
	'liocinema' as platform,
	count(distinct user_id) as liocinema_total_users 
from liocinema_db.subscribers 

Union all 

select 
	'jotstar' as platform,
	count(distinct user_id) as jotstar_total_users 
from jotstar_db.subscribers ;

with monthly_users as (
	select 
		date_format(subscription_date, '%Y-%m') as month,
		count(distinct user_id) as new_users
	from liocinema_db.subscribers 
	group by month 
	order by month 
)
select
	month,
    new_users,
    lag(new_users) over (order by month) as previous_month_users,
    round((new_users - lag(new_users) over (order by month))*100.0 / nullif(lag(new_users) over (order by month),0), 2) as lio_mom_growth
from monthly_users;


with monthly_users as (
	select 
		date_format(subscription_date, '%Y-%m') as month,
		count(distinct user_id) as new_users
	from jotstar_db.subscribers 
	group by month 
	order by month 
)
select
	month,
    new_users,
    lag(new_users) over (order by month) as previous_month_users,
    round((new_users - lag(new_users) over (order by month))*100.0 / nullif(lag(new_users) over (order by month),0), 2) as jot_mom_growth
from monthly_users;

-- 2. Content Library Comparison
-- What is the total number of contents available on LioCinema vs. Jotstar? How do they differ in terms of language and content type?

select 
	count(distinct content_id) as liocinema_total_content
from liocinema_db.contents ;

select 
	count(distinct content_id) as jotstar_total_content
from jotstar_db.contents ;

select 
	content_type,
	count(distinct content_id) as liocinema_content
from liocinema_db.contents 
group by content_type
order by liocinema_content desc;

select 
	language,
	count(distinct content_id) as liocinema_language
from liocinema_db.contents 
group by language
order by liocinema_language desc;

select 
	content_type,
	count(distinct content_id) as jotstar_content
from jotstar_db.contents 
group by content_type
order by jotstar_content desc;

select 
	language,
	count(distinct content_id) as jotstar_language
from liocinema_db.contents 
group by language
order by jotstar_language desc;

-- 3. User Demographics
-- What is the distribution of users by age group, city tier, and subscription plan for each platform?

select
	age_group,
    count(*) as users
from liocinema_db.subscribers
group by age_group 
order by users desc;

select
	age_group,
    count(*) as users
from jotstar_db.subscribers
group by age_group 
order by users desc;

select
	city_tier,
    count(*) as liocinema_users
from liocinema_db.subscribers
group by city_tier 
order by liocinema_users desc;

select
	city_tier,
    count(*) as jotstar_users
from jotstar_db.subscribers
group by city_tier 
order by jotstar_users desc;

select
	subscription_plan,
    count(*) as liocinema_users
from liocinema_db.subscribers
group by subscription_plan 
order by liocinema_users desc;

select
	subscription_plan,
    count(*) as jotstar_users
from jotstar_db.subscribers
group by subscription_plan 
order by jotstar_users desc;

-- 4. Active vs. Inactive Users
-- What percentage of LioCinema and Jotstar users are active vs. inactive? How do these rates vary by age group and subscription plan?

select 
	round(count(case when last_active_date is not null then user_id end )*100.0 / count(*),2) as '%_active_users',
    round(count(case when last_active_date is null then user_id end )*100.0 / count(*),2) as '%_inactive_users'
from liocinema_db.subscribers ;

select 
	round(count(case when last_active_date is not null then user_id end )*100.0 / count(*),2) as '%_active_users',
    round(count(case when last_active_date is null then user_id end )*100.0 / count(*),2) as '%_inactive_users'
from jotstar_db.subscribers ;

select 
	age_group,
	round(count(case when last_active_date is not null then user_id end )*100.0 / count(*),2) as '%_active_users',
    round(count(case when last_active_date is null then user_id end )*100.0 / count(*),2) as '%_inactive_users'
from liocinema_db.subscribers 
group by age_group;

select 
	age_group,
	round(count(case when last_active_date is not null then user_id end )*100.0 / count(*),2) as '%_active_users',
    round(count(case when last_active_date is null then user_id end )*100.0 / count(*),2) as '%_inactive_users'
from jotstar_db.subscribers 
group by age_group;

select 
	subscription_plan,
	round(count(case when last_active_date is not null then user_id end )*100.0 / count(*),2) as '%_active_users',
    round(count(case when last_active_date is null then user_id end )*100.0 / count(*),2) as '%_inactive_users'
from liocinema_db.subscribers 
group by subscription_plan;

select 
	subscription_plan,
	round(count(case when last_active_date is not null then user_id end )*100.0 / count(*),2) as '%_active_users',
    round(count(case when last_active_date is null then user_id end )*100.0 / count(*),2) as '%_inactive_users'
from jotstar_db.subscribers 
group by subscription_plan;

-- 5. Watch Time Analysis
-- What is the average watch time for LioCinema vs. Jotstar during the analysis period? How do these compare by city tier and device type?

select 
	round(avg(total_watch_time_mins)/60,2) as jotstar_avg_watch_time
from jotstar_db.content_consumption ;

select 
	round(avg(total_watch_time_mins)/60,2) as liocinema_avg_watch_time
from liocinema_db.content_consumption ;

select 
	device_type,
	round(avg(total_watch_time_mins)/60,2) as jotstar_avg_watch_time
from jotstar_db.content_consumption 
group by device_type;

select 
	device_type,
	round(avg(total_watch_time_mins)/60,2) as liocinema_avg_watch_time
from liocinema_db.content_consumption 
group by device_type;

select 
	s.city_tier,
    round(avg(total_watch_time_mins)/60,2) as jotstar_avg_watch_time
from jotstar_db.content_consumption as cc
inner join jotstar_db.subscribers as s 
using (user_id)
group by s.city_tier ;

select 
	s.city_tier,
    round(avg(total_watch_time_mins)/60,2) as liocinema_avg_watch_time
from liocinema_db.content_consumption as cc
inner join liocinema_db.subscribers as s 
using (user_id)
group by s.city_tier ;

select 
	Month(s.subscription_date) as month,
    round(avg(total_watch_time_mins)/60,2) as jotstar_avg_watch_time
from jotstar_db.content_consumption as cc
inner join jotstar_db.subscribers as s 
using (user_id)
group by month ;

select 
	Month(s.subscription_date) as month,
    round(avg(total_watch_time_mins)/60,2) as liocinema_avg_watch_time
from liocinema_db.content_consumption as cc
inner join liocinema_db.subscribers as s 
using (user_id)
group by month ;

-- 6. Inactivity Correlation
-- How do inactivity patterns correlate with total watch time or average watch time? Are less engaged users more likely to become inactive?

select 
	case when s.last_active_date is null then 'Active' 
    else 'Not Active' end as jotstar_user_status,
    round(avg(cc.total_watch_time_mins)/60,2) as avg_watch_time
from jotstar_db.content_consumption as cc
inner join jotstar_db.subscribers as s 
using (user_id)
group by jotstar_user_status ;

select 
	case when s.last_active_date is null then 'Active' 
    else 'Not Active' end as liocinema_user_status,
    round(avg(cc.total_watch_time_mins/60),2) as avg_watch_time
from liocinema_db.content_consumption as cc
inner join liocinema_db.subscribers as s 
using (user_id)
group by liocinema_user_status ;

SELECT 
	'jotstar' as platform,
    round((SUM(activity_flag * total_watch_time) - SUM(activity_flag) * SUM(total_watch_time) / COUNT(*)) /
    (SQRT(SUM(activity_flag * activity_flag) - SUM(activity_flag) * SUM(activity_flag) / COUNT(*)) *
     SQRT(SUM(total_watch_time * total_watch_time) - SUM(total_watch_time) * SUM(total_watch_time) / COUNT(*))), 3)
    AS inactivity_watch_time_correlation
FROM (
    SELECT 
        s.user_id,
        CASE WHEN s.last_active_date IS NOT NULL THEN 1 ELSE 0 END AS activity_flag,
        c.total_watch_time_mins as total_watch_time
    FROM Jotstar_db.subscribers s
    JOIN Jotstar_db.content_consumption c
    ON s.user_id = c.user_id
) subquery

union all 

SELECT 
	'liocinema' as platform,
    round((SUM(activity_flag * total_watch_time) - SUM(activity_flag) * SUM(total_watch_time) / COUNT(*)) /
    (SQRT(SUM(activity_flag * activity_flag) - SUM(activity_flag) * SUM(activity_flag) / COUNT(*)) *
     SQRT(SUM(total_watch_time * total_watch_time) - SUM(total_watch_time) * SUM(total_watch_time) / COUNT(*))), 3)
    AS inactivity_watch_time_correlation
FROM (
    SELECT 
        s.user_id,
        CASE WHEN s.last_active_date IS NOT NULL THEN 1 ELSE 0 END AS activity_flag,
        c.total_watch_time_mins as total_watch_time
    FROM liocinema_db.subscribers s
    JOIN liocinema_db.content_consumption c
    ON s.user_id = c.user_id
) subquery;


-- A negative correlation indicates that lower watch time is linked to higher inactivity.
-- Which is More Useful?
-- ✅ **If the goal is to reduce churn, then inactivity correlation is more useful.
-- ✅ **If the goal is to understand engagement patterns, then activity correlation is better.

SELECT 
	'liocinema' as platform,
    CASE 
        WHEN c.total_watch_time_mins < 500 THEN 'Low Engagement'
        WHEN c.total_watch_time_mins BETWEEN 500 AND 2000 THEN 'Medium Engagement'
        ELSE 'High Engagement'
    END AS engagement_level,
    COUNT(CASE WHEN s.last_active_date IS NOT NULL THEN s.user_id END) * 100.0 / COUNT(*) AS inactivity_percentage
FROM LioCinema_db.subscribers s
JOIN LioCinema_db.content_consumption c
ON s.user_id = c.user_id
GROUP BY engagement_level
ORDER BY inactivity_percentage DESC;

SELECT 
	'jotstar' as platform,
    CASE 
        WHEN c.total_watch_time_mins < 500 THEN 'Low Engagement'
        WHEN c.total_watch_time_mins BETWEEN 500 AND 2000 THEN 'Medium Engagement'
        ELSE 'High Engagement'
    END AS engagement_level,
    COUNT(CASE WHEN s.last_active_date IS NOT NULL THEN s.user_id END) * 100.0 / COUNT(*) AS inactivity_percentage
FROM Jotstar_db.subscribers s
JOIN Jotstar_db.content_consumption c
ON s.user_id = c.user_id
GROUP BY engagement_level
ORDER BY inactivity_percentage DESC;


-- 7. Downgrade Trends
-- How do downgrade trends differ between LioCinema and Jotstar? Are downgrades more prevalent on one platform compared to the other?

select 
	count(*) as total_downgrade
from jotstar_db.subscribers
where (subscription_plan = 'Premium' AND new_subscription_plan IN ('VIP', 'Free')) 
or    (subscription_plan = 'VIP' AND new_subscription_plan = 'Free');

select 
	count(*) as total_downgrade
from liocinema_db.subscribers
where (subscription_plan = 'Premium' AND new_subscription_plan IN ('Basic', 'Free')) 
or    (subscription_plan = 'Basic' AND new_subscription_plan = 'Free');

select 
	date_format( plan_change_date, '%m') as month,
	count(*) as total_downgrade
from jotstar_db.subscribers
where (subscription_plan = 'Premium' AND new_subscription_plan IN ('VIP', 'Free')) 
or    (subscription_plan = 'VIP' AND new_subscription_plan = 'Free')
group by month
order by month;

select 
	date_format( plan_change_date, '%m') as month,
	count(*) as total_downgrade
from liocinema_db.subscribers
where (subscription_plan = 'Premium' AND new_subscription_plan IN ('Basic', 'Free')) 
or    (subscription_plan = 'Basic' AND new_subscription_plan = 'Free')
group by month
order by month;

select 
	subscription_plan,
    round(count( case when (subscription_plan = 'Premium' AND new_subscription_plan IN ('VIP', 'Free')) 
						or (subscription_plan = 'VIP' AND new_subscription_plan = 'Free') then user_id end ) *100.0 / count(*), 2) as downgrad_rate
from jotstar_db.subscribers
group by subscription_plan
order by downgrad_rate desc ;

select 
	subscription_plan,
    round(count( case when (subscription_plan = 'Premium' AND new_subscription_plan IN ('Basic', 'Free'))
						or (subscription_plan = 'Basic' AND new_subscription_plan = 'Free') then user_id end ) *100.0 / count(*), 2) as downgrad_rate
from liocinema_db.subscribers
group by subscription_plan
order by downgrad_rate desc ;

-- 8. Upgrade Patterns
-- What are the most common upgrade transitions (e.g., Free to Basic, Free to VIP, Free to Premium) for LioCinema and Jotstar? How do these differ across platforms?

select 
	count(*) as total_upgrade
from jotstar_db.subscribers
where (subscription_plan = 'Free' AND new_subscription_plan IN ('VIP', 'Premium')) 
or    (subscription_plan = 'VIP' AND new_subscription_plan = 'Premium');

select 
	count(*) as total_upgrade
from liocinema_db.subscribers
where (subscription_plan = 'Free' AND new_subscription_plan IN ('Basic', 'Premium')) 
or    (subscription_plan = 'Basic' AND new_subscription_plan = 'Premium');

select 
	date_format( plan_change_date, '%m-%y') as month,
	count(*) as total_upgrade
from jotstar_db.subscribers
where new_subscription_plan is not null 
 and ( (subscription_plan = 'Free' AND new_subscription_plan IN ('VIP', 'Premium')) 
		or (subscription_plan = 'VIP' AND new_subscription_plan = 'Premium') )
group by month
order by month;

select 
	date_format( plan_change_date, '%m-%y') as month,
	count(*) as total_upgrade
from liocinema_db.subscribers
where new_subscription_plan is not null 
 and ( (subscription_plan = 'Free' AND new_subscription_plan IN ('Basic', 'Premium')) 
		or (subscription_plan = 'Basic' AND new_subscription_plan = 'Premium') )
group by month
order by month;

select 
	subscription_plan,
    round(count( case when (subscription_plan = 'Free' AND new_subscription_plan IN ('VIP', 'Premium')) 
						or (subscription_plan = 'VIP' AND new_subscription_plan = 'Premium') then user_id end ) *100.0 / count(*), 2) as upgrad_rate
from jotstar_db.subscribers
group by subscription_plan
order by upgrad_rate desc ;

select 
	subscription_plan,
    round(count( case when (subscription_plan = 'Free' AND new_subscription_plan IN ('Basic', 'Premium')) 
						or (subscription_plan = 'Basic' AND new_subscription_plan = 'Premium') then user_id end ) *100.0 / count(*), 2) as upgrad_rate
from liocinema_db.subscribers
group by subscription_plan
order by upgrad_rate desc ;

-- 9. Paid Users Distribution
-- How does the paid user percentage (e.g., Basic, Premium for LioCinema; VIP, Premium for Jotstar) vary across different platforms? 
-- Analyse the proportion of premium users in Tier 1, Tier 2, and Tier 3 cities and identify any notable trends or differences.

SELECT 
    'LioCinema' AS platform,
    COUNT(CASE WHEN subscription_plan IN ('Basic', 'Premium') THEN user_id END) * 100.0 / COUNT(*) AS paid_user_percentage
FROM LioCinema_db.subscribers
UNION ALL
SELECT 
    'Jotstar' AS platform,
    COUNT(CASE WHEN subscription_plan IN ('VIP', 'Premium') THEN user_id END) * 100.0 / COUNT(*) AS paid_user_percentage
FROM Jotstar_db.subscribers;

SELECT 
    city_tier,
    COUNT(CASE WHEN subscription_plan IN ('Basic', 'Premium') THEN user_id END) AS paid_users_lio
FROM LioCinema_db.subscribers
GROUP BY city_tier
ORDER BY city_tier ;

SELECT 
    city_tier,
    COUNT(CASE WHEN subscription_plan IN ('VIP', 'Premium') THEN user_id END) AS paid_users_jot
FROM Jotstar_db.subscribers
GROUP BY city_tier
ORDER BY city_tier;

-- 10. Revenue Analysis
-- calculate the total revenue generated by both platforms (LioCinema and Jotstar) for the analysis period (January to November 2024).
-- The calculation should consider:
-- Subscribers count under each plan.
-- Active duration of subscribers on their respective plans.
-- Upgrades and downgrades during the period, ensuring revenue reflects the time spent under each plan.

SELECT 
    city_tier,
    subscription_plan,
    COUNT(user_id) AS total_users,
    COUNT(user_id) * 100.0 / SUM(COUNT(user_id)) OVER () AS percentage
FROM Jotstar_db.subscribers
WHERE subscription_plan IN ('VIP', 'Premium')
GROUP BY city_tier, subscription_plan;

SELECT 
    city_tier,
    subscription_plan,
    COUNT(user_id) AS total_users,
    COUNT(user_id) * 100.0 / SUM(COUNT(user_id)) OVER () AS percentage
FROM LioCinema_db.subscribers
WHERE subscription_plan IN ('Basic', 'Premium')
GROUP BY city_tier, subscription_plan;

WITH SubscriptionPeriods AS (
    SELECT 
        user_id,
        subscription_plan AS plan_name,
        subscription_date AS start_date,
        LEAST(COALESCE(plan_change_date, last_active_date, '2024-11-30'), '2024-11-30') AS end_date
    FROM Jotstar_db.subscribers
    
    UNION ALL

    SELECT 
        user_id,
        new_subscription_plan AS plan_name,
        plan_change_date AS start_date,
        LEAST(last_active_date, '2024-11-30') AS end_date
    FROM Jotstar_db.subscribers
    WHERE plan_change_date IS NOT NULL 
     AND plan_change_date < '2024-12-01'
)
SELECT 
    sp.plan_name,
    COUNT(sp.user_id) AS total_users,
    SUM(
        TIMESTAMPDIFF(MONTH, sp.start_date, sp.end_date) * 
        CASE 
            WHEN sp.plan_name = 'VIP' THEN 159
            WHEN sp.plan_name = 'Premium' THEN 359
        END
    ) AS total_revenue
FROM SubscriptionPeriods sp
GROUP BY sp.plan_name;

WITH SubscriptionPeriods AS (
    SELECT 
        user_id,
        subscription_plan AS plan_name,
        subscription_date AS start_date,
        LEAST(COALESCE(plan_change_date, last_active_date, '2024-11-30'), '2024-11-30') AS end_date
    FROM LioCinema_db.subscribers
    
    UNION ALL

    SELECT 
        user_id,
        new_subscription_plan AS plan_name,
        plan_change_date AS start_date,
        LEAST(last_active_date, '2024-11-30') AS end_date
    FROM LioCinema_db.subscribers
    WHERE plan_change_date IS NOT NULL
      AND plan_change_date < '2024-12-01'
)
SELECT 
    sp.plan_name,
    COUNT(sp.user_id) AS total_users,
    SUM(
        TIMESTAMPDIFF(MONTH, sp.start_date, sp.end_date) * 
        CASE 
            WHEN sp.plan_name = 'Basic' THEN 69
            WHEN sp.plan_name = 'Premium' THEN 129
        END
    ) AS total_revenue
FROM SubscriptionPeriods sp
GROUP BY sp.plan_name;
