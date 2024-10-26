SELECT * FROM pizza_sales;

-- Convert the dataypes of date and time columns
UPDATE pizza_sales
SET order_date = str_to_date(order_date, '%d-%m-%Y');

ALTER TABLE pizza_sales
MODIFY COLUMN order_date DATE;

UPDATE pizza_sales
SET order_time = str_to_date(order_time, '%T');

ALTER TABLE pizza_sales
MODIFY COLUMN order_time TIME;

-- Exploratory Data Analysis

-- Total revenue for all orders
SELECT ROUND(SUM(total_price),2) AS total_revenue
FROM pizza_sales;

-- Average Order value
SELECT ROUND(SUM(total_price)/COUNT(DISTINCT order_id),2) AS avg_order_value
FROM pizza_sales;

-- Total pizzas sold
SELECT SUM(quantity) AS pizzas_sold
FROM pizza_sales;

-- Total orders 
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales;

-- Average pizzas per order
SELECT SUM(quantity)/COUNT(DISTINCT order_id) AS avg_pizza_per_order
FROM pizza_sales;

-- Hourly trend for sold pizzas
SELECT HOUR(order_time) AS order_hour, SUM(quantity) AS pizzas_sold
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);

-- Weekly trend of total orders
SELECT YEAR(order_date) AS order_year, WEEK(order_date) AS order_week, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY YEAR(order_date), WEEK(order_date) 
ORDER BY YEAR(order_date), WEEK(order_date);

-- Percentage of sales by pizza category
SELECT pizza_category, ROUND(SUM(total_price),2) AS total_sales,
ROUND(SUM(total_price)/(SELECT SUM(total_price) FROM pizza_sales)*100, 2) AS percentage_sales
FROM pizza_sales
GROUP BY pizza_category;

-- Percentage of sales by pizza size
SELECT pizza_size, ROUND(SUM(total_price),2) AS total_sales,
ROUND(SUM(total_price)/(SELECT SUM(total_price) FROM pizza_sales)*100,2) AS percentage_sales
FROM pizza_sales
GROUP BY pizza_size
ORDER BY percentage_sales DESC;

-- Top 5 best sellers based on revenue
SELECT pizza_name, ROUND(SUM(total_price),2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Top 5 best sellers based on total quantity
SELECT pizza_name, SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity DESC
LIMIT 5;

-- Top 5 best sellers based on total orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC
LIMIT 5;


-- Bottom 5 best sellers based on revenue,
SELECT pizza_name, ROUND(SUM(total_price),2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue
LIMIT 5;

-- Bottom 5 best sellers based on total quantity
SELECT pizza_name, SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity
LIMIT 5;

-- Bottom 5 best sellers based on total orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders
LIMIT 5;
 
