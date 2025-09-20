-- Explore the items table
USE restaurant_db;
-- write a query to find the number of items on the menu
SELECT 
    COUNT(*) AS num_of_menu
FROM
    menu_items;
    
-- What are the least and most expensive items on the menu?
SELECT 
    MIN(price) AS min_price, MAX(price) AS max_price
FROM
    menu_items;

-- How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?

SELECT 
    COUNT(*) num_of_dishes
FROM
    menu_items
WHERE
    category = 'Italian';

SELECT 
    MIN(price) AS min_price, MAX(price) AS max_price
FROM
    restaurant_db.menu_items
WHERE
    category = 'Italian';

-- How many dishes are in each category? What is the average dish price within each category?
SELECT 
    category, COUNT(menu_item_id) AS num_of_dishes
FROM
    menu_items
GROUP BY category;

SELECT 
    category, AVG(price) AS avg_price
FROM
    menu_items
GROUP BY category;

-- Explore the orders table

SELECT 
    *
FROM
    order_details;

SELECT 
    MIN(order_date) AS min_date, MAX(order_date) AS max_date
FROM
    order_details;

-- How many orders were made within this date range? 
SELECT 
    COUNT(DISTINCT order_id) AS num_of_order
FROM
    order_details;

-- How many items were ordered within this date range?
SELECT 
    COUNT(item_id) AS num_of_order
FROM
    order_details;

-- Which orders had the most number of items?
SELECT 
    order_id, COUNT(item_id) AS num_order
FROM
    order_details
GROUP BY order_id
ORDER BY num_order DESC;


-- How many orders had more than 12 items?
SELECT 
    COUNT(*) AS over_12_orders
FROM
    (SELECT 
        order_id, COUNT(item_id) AS num_order
    FROM
        order_details
    GROUP BY order_id
    HAVING num_order > 12) AS orders;
    
-- Analyze customer behavior
-- Combine the menu_items and order_details tables into a single table
SELECT 
    *
FROM
    order_details o
        LEFT JOIN
    menu_items m ON m.menu_item_id = o.item_id;

-- What were the least and most ordered items? What categories were they in?

WITH order_menu AS (SELECT item_name, category, COUNT(*) AS num_order
FROM order_details o
LEFT JOIN  menu_items m
ON m.menu_item_id = o.item_id
GROUP BY item_name, category
ORDER BY num_order DESC)
SELECT *
FROM order_menu
WHERE num_order = (SELECT  MIN(num_order)
FROM order_menu) OR num_order = (SELECT  MAX(num_order)
FROM order_menu) ;


-- What were the top 5 orders that spent the most money?
SELECT 
    order_id, SUM(price) AS spent
FROM
    order_details o
        LEFT JOIN
    menu_items m ON m.menu_item_id = o.item_id
GROUP BY order_id
ORDER BY spent DESC
LIMIT 5;

-- View the details of the top 5 highest spend orders
SELECT 
    order_id, category, COUNT(item_id) AS num_orders
FROM
    order_details o
        LEFT JOIN
    menu_items m ON m.menu_item_id = o.item_id
WHERE
    order_id IN (SELECT 
            order_id
        FROM
            (SELECT 
                order_id, COUNT(item_id) AS spent
            FROM
                order_details o
            LEFT JOIN menu_items m ON m.menu_item_id = o.item_id
            GROUP BY order_id
            ORDER BY spent DESC
            LIMIT 5) AS top_5)
GROUP BY order_id , category
ORDER BY order_id , num_orders DESC;

-- How much was the most expensive order in the dataset?
SELECT 
    order_id, SUM(price) AS spent
FROM
    order_details o
        LEFT JOIN
    menu_items m ON m.menu_item_id = o.item_id
GROUP BY order_id
ORDER BY spent DESC
LIMIT 1;