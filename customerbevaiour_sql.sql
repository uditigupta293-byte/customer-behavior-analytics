CREATE DATABASE customer_analysis;
USE customer_analysis;
SHOW TABLES;
SELECT *
FROM `customer_shopping_behavior (2)`
LIMIT 10;
RENAME TABLE
`customer_shopping_behavior (2)`
TO customer_data;
SELECT *
FROM customer_data
LIMIT 10;
DESCRIBE customer_data;
SELECT COUNT(*)
FROM customer_data;

-- what is the revenuw genrate by male and female customer
Select gender,sum(purchase_amount) as revenue
from customer_data
group by gender

-- wich customer applied discoun but still  spent more thann the  average purchase amount
DESCRIBE customer_data;
SELECT customer_id, purchase_amount
FROM customer_data
WHERE discount_applied = 'Yes'
AND purchase_amount >= (
    SELECT AVG(purchase_amount)
    FROM customer_data
);

-- which are top 5 product with hghest avf review rating
select item_purchased,ROUND(AVG(review_rating),2) as "AVERAGE PRODUCT REVIEW"
FROM customer_data
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- compare  te average purchase amount  between standard and  express shipping
select shipping_type,
ROUND(AVG(purchase_amount),2)
from customer_data
where shipping_type in ('Standard','Express')
group by shipping_type

-- DO SUBSCRIBED CUTSOMER SPEND MORE?  compare avg spent and total revenue between subscriber and non sub
select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as  avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue 
from customer_data
group by subscription_status
order by total_revenue,avg_spend desc;

-- which  5 product have highest percentage of purchase with discount applied
select item_purchased,
ROUND(SUM(CASE WHEN discount_applied='YES' then 1 else 0 end)/count(*) * 100,2) as discount_rate
from customer_data
group by item_purchased
order by discount_rate desc
limit 5;

-- sement customer into new,returning ,loyal based on their  total o.  of prvous purchses nd show count of each sgment
with customer_type as (
select customer_id,previous_purchases,
case when previous_purchases=1 then 'new' 
when previous_purchases between 2  and 10 then 'returning'
else 'loyal'
end as customer_segment
from customer_data)

select customer_segment,count(*) as "number of customer"
from customer_type
group by customer_segment

-- what are top 3 most purchased product within each category
WITH item_counts AS
(
    SELECT
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER
        (
            PARTITION BY category
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer_data
    GROUP BY category, item_purchased
)

SELECT
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;


-- are customers who are repeat buyers(more than 5 preious purchase) also likey to subscribe
select subscription_status,
count(customer_id) as repeat_buyer
from customer_data
where previous_purchases>5
group by subscription_status

-- what is revenue contribution of each age group
select `age group`,
SUM(purchase_amount) as total_revenue
from customer_data
group by `age group`
order by total_revenue desc;

SELECT user, host, plugin
FROM mysql.user;

ALTER USER 'root'@'localhost'
IDENTIFIED WITH mysql_native_password
BY 'Uditi@0310';

FLUSH PRIVILEGES;