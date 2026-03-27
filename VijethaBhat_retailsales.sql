create database retail_sales
use retail_sales

select * from analyticsdata

-- Identify prices higher than average price within category
select product_name, category, price
from(
select *, 
avg(price) over(partition by category) as avg_category_price
from analyticsdata) subquery
where price > avg_category_price;

--Finding Categories with Highest Average Rating Across Products
select category, avg_rating,
RANK() over(order by avg_rating desc) as rating_rank
from (
select a.Category, AVG(a.rating) as avg_rating
from analyticsdata a
inner join analyticsdata r on a.Product_ID = r.Product_ID
group by a.Category) subquery

--Find the most reviewed product in each warehouse
with reviewcount as (
select warehouse, product_name, 
count(reviews) as review_count
from analyticsdata
group by Warehouse, Product_Name),

rankedproducts as(
select warehouse, product_name, review_count,
RANK() over(partition by warehouse order by review_count desc) as rk
from reviewcount)

select warehouse, product_name, review_count 
from rankedproducts
where rk = 1

--Find products that have higher-than-average prices within their category, along with their discount and supplier
select product_name, category, price, Discount, supplier
from(
select *, 
avg(price) over(partition by category) as avg_category_price
from analyticsdata) subquery
where price > avg_category_price;

--Query to find the top 2 products with the highest average rating in each category
with productrating as(
select product_name, category, AVG(rating) as avg_rating
from analyticsdata
group by Category, Product_Name),

rankproducts as(
select product_name, category, avg_rating,
dense_rank() over(partition by category order by avg_rating desc) as rank_rating 
from productrating)

select product_name, category, avg_rating
from rankproducts
where rank_rating <= 2

-- Analysis Across All Return Policy Categories(Count, Avgstock, total stock, weighted_avg_rating)
select return_policy, 
count(*) as count,
avg(stock_quantity) as avg_stock,
sum(stock_quantity) as total_stock,
AVG(discount) as avg_discount,
avg(rating) as avg_rating
from analyticsdata
group by return_policy

select salary, name, dept, SUM (salary)  as salary
where salary > SUM(sala 
GROUP by (dept)

